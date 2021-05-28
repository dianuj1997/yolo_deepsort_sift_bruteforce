// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:cron/cron.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_beacon_example/widgets.dart';
import 'package:flutter_blue_beacon/flutter_blue_beacon.dart';
import 'app_broadcasting.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:randombytes/randombytes.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:randombytes/randombytes.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';


void main() async {
  runApp(new FlutterBlueApp());
}

Future<String> _generator() async {
  //************************************************************************************************
  //************************************************************************************************
  var uuid = Uuid();
  String varuuid;


  int _x=2;

  uuid.v1(options: {
    'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
    'clockSeq': 0x1234,
    'mSecs': new DateTime.utc(2011,11,01).millisecondsSinceEpoch,
    'nSecs': 5678
  });
  print("UUID: ${uuid.v1()}");
  var randy_bytes=randomBytes(32, secure: true);
  print('Random Bytes: ${randy_bytes}');
  var result_hex = hex.encode(randy_bytes);
  print("Random Hex: ${result_hex}");

  //********************************************************************************

  // setState(() {
  //   _varuuid=result_hex.toString();
  // });
  // Create PBKDF2 instance using the SHA256 hash. The default is to use SHA1     // data being hashed


  // Password we want to hash
  final secretKey = SecretKey(randy_bytes);

  // A random salt
  final nonce = [4,5,6,7];



  final hmacp = Hmac(sha256);
  final mac_p = await hmacp.calculateMac(
    nonce,
    secretKey: secretKey,
  );
  final newSecretKeyBytes = await mac_p.bytes;
  // print('Result: $newSecretKeyBytes');
  print("output of HFDF:"+newSecretKeyBytes.toString());

  final message = [1,2,3];
  final secretKey1 = SecretKey(newSecretKeyBytes);

  // In our example, we calculate HMAC-SHA256
  final hmac = Hmac(sha256);
  final mac = await hmac.calculateMac(
    message,
    secretKey: secretKey1,
  );

  final newSecretKeyBytes2 = await mac.bytes;
  print("HMAC: "+newSecretKeyBytes2.toString());

  var result_hex2 = hex.encode(newSecretKeyBytes2);
  print("Random Hex for UUID: ${result_hex2}");
  _x=_x+1;
  print("****************************************");
  print(_x);
  print("****************************************");
  varuuid=result_hex2.toString();
  //************************************************************************************************
  //************************************************************************************************
  // Your block of code
  return varuuid;

}

class FlutterBlueApp extends StatefulWidget {
  FlutterBlueApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlutterBlueAppState createState() => new _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  String _varuuid='1';
  int _vary=1;
  int _y=1;
  var rng = new Random();

  //******************************************* */
  void getPermission() async {
    //  print("getPermission");
    final PermissionHandler _permissionHandler = PermissionHandler();
    var permissions =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);

//    Map<PermissionGroup, PermissionStatus> permissions =
//        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  //Transmitter

  //********************************************** */
  FlutterBlueBeacon flutterBlueBeacon = FlutterBlueBeacon.instance;
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<int, Beacon> beacons = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    super.dispose();
  }

  _clearAllBeacons() {
    setState(() {
      beacons = Map<int, Beacon>();
    });
  }

  _startScan() {
    print("Scanning now");
    _scanSubscription = flutterBlueBeacon
        .scan(timeout: const Duration(seconds: 20))
        .listen((beacon) {
      print('localName: ${beacon.scanResult.advertisementData.localName}');
      print(
          'manufacturerData: ${beacon.scanResult.advertisementData.manufacturerData}');
      print('serviceData: ${beacon.scanResult.advertisementData.serviceData}');
      print(beacon.id);
      print("Scanning is happening!!");
      print(beacon.scanResult.device);
      setState(() {
        beacons[beacon.hash] = beacon;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    print("Scan stopped");
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _buildScanResultTiles() {
    return beacons.values.map<Widget>((b) {
      //IBeaconCard({@required this.iBeacon});
      if (b is IBeacon) {
        return IBeaconCard(iBeacon: b);
      }
      if (b is EddystoneUID) {
        return EddystoneUIDCard(eddystoneUID: b);
      }
      if (b is EddystoneEID) {
        return EddystoneEIDCard(eddystoneEID: b);
      }
      return Card();
    }).toList();
  }

  _buildAlertTile() {
    return new Container(
      color: Colors.redAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  @override
  void initState() {
    getPermission();
    super.initState();
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });

  }
  Future<void> startService()
  async {
    if(Platform.isAndroid)
    {
      var methodChannel=MethodChannel("com.example.messages");
      String data=await methodChannel.invokeMethod("startService");
      debugPrint('*******************************************************************************************');
      debugPrint(data);
      debugPrint('*******************************************************************************************');

    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      var rng = new Random();
      _vary=rng.nextInt(9);

    });
    onPressed('${_vary}');

    //_startScan();
    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }


    tiles.addAll(_buildScanResultTiles());

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('CCR-LAB PLUS'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.clear), onPressed: () async{
              // startService();
              // var cron = new Cron();
              // cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
                final result = await FlutterRestart.restartApp();
                print("Restarted.......");
                print(result);
                // _startScan();
              // setState(() async {
              // String indian_bit=await _generator();
              // _varuuid=indian_bit;
              // print("Stuff generated and to be sent.....");
              // print(_varuuid);
              // });
    // });
              // startService();
              // var cron = new Cron();
              // cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
              //   print('******************************Start of Schedule operation*******************************');
              //   print('Occurs every one minute');
              //   String indian_bit=await _generator();
              //   print("India:******************");
              //   _startScan();
              //   setState(() {
              //     _varuuid=indian_bit;
              //     print(indian_bit);
              //     print(_varuuid);
              //     _y=rng.nextInt(9);
              //     print("Stuff to be sending.......................");
              //     print(_y);
              //     // onPressed('${_y}');
              //   });
              //   print('******************************End of Schedule operation*******************************');
              // });
            })
          ],
        ),
        //floatingActionButton: _buildScanningButton(),
        body: new Stack(
          children: <Widget>[
            (isScanning) ? _buildProgressBarTile() : new Container(),
            new ListView(
              children: tiles,
            )
          ],
        ),
      ),
    );
  }
}
void _restartApp() async {
  FlutterRestart.restartApp();
}
