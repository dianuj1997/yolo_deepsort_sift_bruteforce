import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bt_transitter_reciever/btreciever.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


void main() {
  //******************************************************************************************************************************
  // Workmanager.initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  // );
  //******************************************************************************************************************************
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Login',
    home: Transmission(),
    theme: ThemeData(
        primaryColor: Colors.indigoAccent, accentColor: Colors.indigoAccent),
  ));
}

class Transmission extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransmissionState();
  }
}

class _TransmissionState extends State<Transmission> {
  static const String uuid = '39ED98FF-2900-441A-802F-9C398FC199E1';
  static const int majorId = 1;
  static const int minorId = 100;
  static const int transmissionPower = -59;
  static const String identifier = 'com.example.myDeviceRegion';
  static const AdvertiseMode advertiseMode = AdvertiseMode.lowPower;
  static const String layout = BeaconBroadcast.ALTBEACON_LAYOUT;
  static const int manufacturerId = 0x0118;
  static const List<int> extraData = [100];

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  BeaconStatus _isTransmissionSupported;
  bool _isAdvertising = false;
  StreamSubscription<bool> _isAdvertisingSubscription;

  @override
  void initState() {
    super.initState();
    beaconBroadcast
        .checkTransmissionSupported()
        .then((isTransmissionSupported) {
      setState(() {
        _isTransmissionSupported = isTransmissionSupported;
      });
    });

    _isAdvertisingSubscription =
        beaconBroadcast.getAdvertisingStateChange().listen((isAdvertising) {
          setState(() {
            _isAdvertising = isAdvertising;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Beacon Broadcast'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Is transmission supported?',
                    style: Theme.of(context).textTheme.headline5),
                Text('$_isTransmissionSupported',
                    style: Theme.of(context).textTheme.subtitle1),
                Container(height: 16.0),
                Text('Is beacon started?',
                    style: Theme.of(context).textTheme.headline5),
                Text('$_isAdvertising',
                    style: Theme.of(context).textTheme.subtitle1),
                Container(height: 16.0),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      beaconBroadcast
                          .setUUID(uuid)
                          .setMajorId(majorId)
                          .setMinorId(minorId)
                          .setTransmissionPower(transmissionPower)
                          .setAdvertiseMode(advertiseMode)
                          .setIdentifier(identifier)
                          .setLayout(layout)
                          .setManufacturerId(manufacturerId)
                          .setExtraData(extraData)
                          .start();
                    },
                    child: Text('START'),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      beaconBroadcast.stop();
                    },
                    child: Text('STOP'),
                  ),
                ),
                Text('Beacon Data',
                    style: Theme.of(context).textTheme.headline5),
                Text('UUID: $uuid'),
                Text('Major id: $majorId'),
                Text('Minor id: $minorId'),
                Text('Tx Power: $transmissionPower'),
                Text('Advertise Mode Value: $advertiseMode'),
                Text('Identifier: $identifier'),
                Text('Layout: $layout'),
                Text('Manufacturer Id: $manufacturerId'),
                Text('Extra data: $extraData'),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) {
                      //       return Reception();
                      //     }));
                      // beaconBroadcast.stop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Reception()));

                    },
                    child: Text('Reception'),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () async{
                      int dd=await _readIndicator();
                      if (dd==1) {
                        String dir = await ExtStorage
                            .getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOWNLOADS);
                        print("dir $dir");
                        String path = "$dir";
                        final csvFile = new File(path + "/BT_collection3.csv")
                            .openRead();
                        var dat = await csvFile
                            .transform(utf8.decoder)
                            .transform(
                          CsvToListConverter(),
                        )
                            .toList();
                        print(dat[0][0]);
                        List<List<dynamic>> rows = [];

                        List<dynamic> row = [];
                        for (int i = 0; i < dat.length; i++) {
                          List<dynamic> row = [];
                          row.add(dat[i][0]);
                          row.add(dat[i][1]);
                          row.add(dat[i][2]);
                          row.add(dat[i][3]);
                          row.add(dat[i][4]);
                          rows.add(row);
                        }
                        String csver = const ListToCsvConverter().convert(rows);
                        var f = await File(path + "/BT_collection3.csv");
                        f.writeAsString(csver);
                        print("Ok done");
                      }
                      else{
                        print("No Action");
                      }
                    },
                    child: Text('Check csv'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_isAdvertisingSubscription != null) {
      _isAdvertisingSubscription.cancel();
    }
  }
}


Future<int> _readIndicator() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/BT_collection3.csv";
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


