// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';
//***********************************************
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue_beacon/flutter_blue_beacon.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';

import 'package:csv/csv.dart';
import 'dart:convert';
//***********************************************

import 'package:cron/cron.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:tuple/tuple.dart';

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
import 'package:steel_crypt/steel_crypt.dart';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';

import 'package:csv/csv.dart';
import 'dart:convert';


void main() async {
  runApp(new FlutterBlueApp());
}

Future<Tuple2<String, String>> _generator() async {
  //************************************************************************************************
  //************************************************************************************************
  print("**********UUID Zone....................");
  var uuid = Uuid();
  String varuuid;

  int _x=2;

  uuid.v1(options: {
    'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
    'clockSeq': 0x1234,
    'mSecs': new DateTime.utc(2011,11,01).millisecondsSinceEpoch,
    'nSecs': 5678
  });
  String checker_uid=uuid.v1().toString();
  print("UUID: ${checker_uid}");
  print("**********UUID Zone....................");

  print("**********Hashing Zone....................");
  var hasher = HashCrypt(); //generate SHA-3/512 hasher
  //SHA-3 512 Hash
  print("SHA-3 512 Hash:");
  var hash = hasher.hash(checker_uid);
  print(hash); //perform hash
  print("Verification result of that hashing:");
  print(hasher.checkhash(checker_uid, hash)); //perform check
  print("");
  print("For further processing, convert the hash to bytes:");
  List<int> hash_bytes = utf8.encode(hash);
  print(hash_bytes);
  String temp_key = hex.encode(hash_bytes);
  print("**********Hashing Zone....................!");


  print("**********Random Function Zone....................");
  // Password we want to hash
  final secretKey = SecretKey(hash_bytes);
  var randy_bytes=randomBytes(4, secure: true);
  print("Check out this salt!:");
  print(randy_bytes);
  // A random salt
  final nonce = randy_bytes;
  final hmacp = Hmac(sha256);
  final mac_p = await hmacp.calculateMac(
    nonce,
    secretKey: secretKey,
  );
  final newSecretKeyBytes = await mac_p.bytes;
  String prf = hex.encode(newSecretKeyBytes);
  // print('Result: $newSecretKeyBytes');
  print("output of Random Function (HMAC under SHA-256) in byte format:"+newSecretKeyBytes.toString());
  print("output of Random Function (HMAC under SHA-256):");
  print(prf.toString());
  print("**********Random Function Zone....................!");


  print("**********ChaCha-Cipher Zone........................");
  var FortunaKey = CryptKey().genFortuna(); //generate 32 byte key generated with Fortuna
  var iv2 = CryptKey().genDart(12); //generate iv for ChaCha20 with Dart Random.secure()
  var encrypter3 = LightCrypt(FortunaKey, "ChaCha20/12"); //generate ChaCha20/12 encrypter
  print("ChaCha20 Symmetric:");
  String crypted3 = encrypter3.encrypt(prf, iv2);
  print(crypted3);
  print("ChaCha20 decrypted:");
  print(encrypter3.decrypt(crypted3, iv2)); //decrypt
  print("");
  print("**********ChaCha-Cipher Zone.......................!");



  // // var randy_bytes=randomBytes(32, secure: true);
  // // print('Random Bytes: ${randy_bytes}');
  // var result_hex = hex.encode(randy_bytes);
  // print("Random Hex: ${result_hex}");
  //
  // //********************************************************************************
  //
  // // setState(() {
  // //   _varuuid=result_hex.toString();
  // // });
  // // Create PBKDF2 instance using the SHA256 hash. The default is to use SHA1     // data being hashed
  //
  //
  // // // Password we want to hash
  // // final secretKey = SecretKey(randy_bytes);
  // //
  // // // A random salt
  // // final nonce = [4,5,6,7];
  // //
  // //
  // //
  // // final hmacp = Hmac(sha256);
  // // final mac_p = await hmacp.calculateMac(
  // //   nonce,
  // //   secretKey: secretKey,
  // // );
  // // final newSecretKeyBytes = await mac_p.bytes;
  // // print('Result: $newSecretKeyBytes');
  // print("output of HFDF:"+newSecretKeyBytes.toString());
  //
  // final message = [1,2,3];
  // final secretKey1 = SecretKey(newSecretKeyBytes);
  //
  // // In our example, we calculate HMAC-SHA256
  // final hmac = Hmac(sha256);
  // final mac = await hmac.calculateMac(
  //   message,
  //   secretKey: secretKey1,
  // );
  //
  // final newSecretKeyBytes2 = await mac.bytes;
  // print("HMAC: "+newSecretKeyBytes2.toString());
  //
  // var result_hex2 = hex.encode(newSecretKeyBytes2);
  // print("Random Hex for UUID: ${result_hex2}");
  // _x=_x+1;
  // print("****************************************");
  // print(_x);
  // print("****************************************");
  // varuuid=result_hex2.toString();
  // //************************************************************************************************
  // //************************************************************************************************
  // // Your block of code
  //*******Protocol Induced*******************
  String answer=crypted3.toString();
  // String firstcrypt = answer.substring(0, 16);
  // String secondcrypt = answer.substring(16, 32);
  // String thirdcrypt = answer.substring(32, 32+16);
  // String fourthcrypt = answer.substring(32+16, 64);
  // List<int> firstcrypt_bytes = utf8.encode(firstcrypt);
  // List<int> secondcrypt_bytes = utf8.encode(secondcrypt);
  // List<int> thirdcrypt_bytes = utf8.encode(thirdcrypt);
  // List<int> fourthcrypt_bytes = utf8.encode(fourthcrypt);
  // var newList = [firstcrypt_bytes , secondcrypt_bytes, thirdcrypt_bytes,fourthcrypt_bytes].expand((x) => x).toList();
  // print("Priniting Stuff.....");
  // print(newList);
  // String first_crypt_reduced = hex.encode(firstcrypt_bytes);

  // final int mid = crypted3.length / 2; //get the middle of the String
  // String[] parts = {crypted3.substring(0, mid),s1.substring(mid)};
  // System.out.println(parts[0]); //first part
  // System.out.println(parts[1]); //second part

   return new Tuple2(temp_key.toString(),answer);
   // return new Tuple2(checker_uid,answer);
  // *********UUID induced*******************
  // return checker_uid;

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

    _startScan();
    //****************Attempted Transmission***************
    // setState(() {
    //   var rng = new Random();
    //   _vary=rng.nextInt(9);
    //
    // });
    // onPressed('${_vary}');
    //*****************Attempted Transmission***************
    //_startScan();
    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }

    // List<Widget> lister=_buildScanResultTiles();
    // print("!!!!!!!!!!!!!!!!!!Hello.................!!!!!!!!!!");
    // print(lister);
    tiles.addAll(_buildScanResultTiles());

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('CCR-LAB PLUS'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.beach_access), onPressed: () async{
              // startService();
              // var cron = new Cron();
              // cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
              //   print('******************************Start of Schedule operation*******************************');
              //********************Testing Crypto**********************************************
              print("**************************Testing Crypto********************************");
              final answerer=await _generator();
              String answerizer=answerer.item2;
              String keyter=answerer.item1;
              print("Finally the suff being about to sent...................");
              print(answerizer);
              String firstcrypt = answerizer.substring(0, 16);
              String secondcrypt = answerizer.substring(16, 32);
              String thirdcrypt = answerizer.substring(32, 32+16);
              String fourthcrypt = answerizer.substring(32+16, 64);
              List<int> firstcrypt_bytes = utf8.encode(firstcrypt);
              List<int> secondcrypt_bytes = utf8.encode(secondcrypt);
              List<int> thirdcrypt_bytes = utf8.encode(thirdcrypt);
              List<int> fourthcrypt_bytes = utf8.encode(fourthcrypt);
              String first_crypt_reduced = hex.encode(firstcrypt_bytes);
              String second_crypt_reduced = hex.encode(secondcrypt_bytes);
              String third_crypt_reduced = hex.encode(thirdcrypt_bytes);
              String fourth_crypt_reduced = hex.encode(fourthcrypt_bytes);
              //...............Restarting.........................
              final result = await FlutterRestart.restartApp();
              print("Restarted.......");
              print(result);
              //********************************Enter CSV**********************************************
              getPermission();
              //IDs for a daily key
              csvgenerator(first_crypt_reduced,second_crypt_reduced,third_crypt_reduced,fourth_crypt_reduced);
              //daily key
              csvgenerator2(keyter);
              //UUID testing (for possible repetition)
              // csvgenerator3(keyter);
              //********************************Enter CSV**********************************************
              print("**************************Testing Crypto********************************");
              //********************Testing Crypto/*********************************************
              // startService();
              // var cron = new Cron();
              // cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
              //**********************************Restarting********************************************
              //   final result = await FlutterRestart.restartApp();
              //   print("Restarted.......");
              //   print(result);
                //********************************Restarting********************************************
                // _startScan();




              setState(() async {
              _varuuid=first_crypt_reduced ;
              print("*****************************************************");
              print("Stuff generated and to be sent.....");
              print("*****************************************************");
              print(_varuuid);
              onPressed('${_varuuid}');

              });
      print('******************************End of Schedule operation*******************************');
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
Future<int> _readIndicator() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/ID_Gen.csv";
    final File file = File(fullPath);
    text = await file.readAsString();
    // debugPrint("A file has been read at ${directory.path}");
    indicator=1;
  } catch (e) {
    debugPrint("Couldn't read file");
    indicator=0;

  }
  return indicator;
}
Future<int> _readIndicator2() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/Key_Gen.csv";
    final File file = File(fullPath);
    text = await file.readAsString();
    // debugPrint("A file has been read at ${directory.path}");
    indicator=1;
  } catch (e) {
    debugPrint("Couldn't read file");
    indicator=0;

  }
  return indicator;
}

Future<int> _readIndicator3() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/UUID_test.csv";
    final File file = File(fullPath);
    text = await file.readAsString();
    // debugPrint("A file has been read at ${directory.path}");
    indicator=1;
  } catch (e) {
    debugPrint("Couldn't read file");
    indicator=0;

  }
  return indicator;
}


void csvgenerator(String first, String second, String third, String fourth) async{
  String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";


  var f = await File(file + "/ID_Gen.csv");
  int dd=await _readIndicator();
  if (dd==1)
  {
    print("**********************************************************");
    print("There is file!");
    print("**********************************************************");
    final csvFile = new File(file + "/ID_Gen.csv")
        .openRead();
    var dat = await csvFile
        .transform(utf8.decoder)
        .transform(
      CsvToListConverter(),
    )
        .toList();

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    for (int i = 0; i < dat.length; i++) {
      List<dynamic> row = [];
      row.add(dat[i][0]);
      row.add(dat[i][1]);
      row.add(dat[i][2]);
      row.add(dat[i][3]);
      rows.add(row);
    }
    // for (int i = 0; i < dat.length; i++) {
    //   List<dynamic> row = [];
    //   row.add(dat[i][0]);
    //   row.add(dat[i][1]);
    //   row.add(dat[i][2]);
    //   row.add(dat[i][3]);
    //   row.add(dat[i][4]);
    //   rows.add(row);
    // }
    row.add(first);
    row.add(second);
    row.add(third);
    row.add(fourth);

    rows.add(row);


    String csver = const ListToCsvConverter().convert(rows);
    f.writeAsString(csver);
  }
  else {
    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add(first);
    row.add(second);
    row.add(third);
    row.add(fourth);

    rows.add(row);
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }
}
void getPermission() async {
  //  print("getPermission");
  final PermissionHandler _permissionHandler = PermissionHandler();
  var permissions =
  await _permissionHandler.requestPermissions([PermissionGroup.storage]);

//    Map<PermissionGroup, PermissionStatus> permissions =
//        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
}


void csvgenerator2(String first) async{
  String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";


  var f = await File(file + "/Key_Gen.csv");
  int dd=await _readIndicator2();
  if (dd==1)
  {
    print("**********************************************************");
    print("There is file!");
    print("**********************************************************");
    final csvFile = new File(file + "/Key_Gen.csv")
        .openRead();
    var dat = await csvFile
        .transform(utf8.decoder)
        .transform(
      CsvToListConverter(),
    )
        .toList();

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    for (int i = 0; i < dat.length; i++) {
      List<dynamic> row = [];
      row.add(dat[i][0]);
      rows.add(row);
    }
    // for (int i = 0; i < dat.length; i++) {
    //   List<dynamic> row = [];
    //   row.add(dat[i][0]);
    //   row.add(dat[i][1]);
    //   row.add(dat[i][2]);
    //   row.add(dat[i][3]);
    //   row.add(dat[i][4]);
    //   rows.add(row);
    // }
    row.add(first);

    rows.add(row);


    String csver = const ListToCsvConverter().convert(rows);
    f.writeAsString(csver);
  }
  else {
    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add(first);

    rows.add(row);
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }
}
void csvgenerator3(String first) async{
  String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";


  var f = await File(file + "/UUID_test.csv");
  int dd=await _readIndicator3();
  if (dd==1)
  {
    print("**********************************************************");
    print("There is file!");
    print("**********************************************************");
    final csvFile = new File(file + "/UUID_test.csv")
        .openRead();
    var dat = await csvFile
        .transform(utf8.decoder)
        .transform(
      CsvToListConverter(),
    )
        .toList();

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    for (int i = 0; i < dat.length; i++) {
      List<dynamic> row = [];
      row.add(dat[i][0]);
      rows.add(row);
    }
    // for (int i = 0; i < dat.length; i++) {
    //   List<dynamic> row = [];
    //   row.add(dat[i][0]);
    //   row.add(dat[i][1]);
    //   row.add(dat[i][2]);
    //   row.add(dat[i][3]);
    //   row.add(dat[i][4]);
    //   rows.add(row);
    // }
    row.add(first);

    rows.add(row);


    String csver = const ListToCsvConverter().convert(rows);
    f.writeAsString(csver);
  }
  else {
    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add(first);

    rows.add(row);
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }
}

