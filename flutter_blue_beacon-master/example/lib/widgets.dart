// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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

final imgUrl =
    "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/csv/dummy.csv";

var dio = Dio();


class IBeaconCard extends StatelessWidget {
  final IBeacon iBeacon;
  FlutterBlueBeacon ieacon = FlutterBlueBeacon.instance;
  List<List<dynamic>> rows = List<List<dynamic>>();




  IBeaconCard({@required this.iBeacon});
  // final a = IBeacon.fromScanResult(iBeacon.;
  @override
  Widget build(BuildContext context) {
    final a = iBeacon.uuid;
    final b = iBeacon.distance;
    print("********************************************************");
    print("Let me know the UUID:");
    print(a);
    /// We require the initializers to run after the loading screen is rendered
    Timer(Duration(seconds:20), () {
      print("Yeah, this line is printed after 3 seconds");
      csvgenerator(a.toString(),b.toString());
    });




   print("***************************************************************");
    //********************************************************************************

    //********************************************************************************
    //print(a);
    return Card(
      child: Column(
        children: <Widget>[
          //Text("iBeacon"),

          Text("uuid: ${iBeacon.uuid}"),
          // Text("major: ${iBeacon.major}"),
          // Text("minor: ${iBeacon.minor}"),
          Text("tx: ${iBeacon.tx}"),
          Text("rssi: ${iBeacon.rssi}"),
          Text("distance: ${iBeacon.distance}"),
        ],
      ),
    );
  }
}

class EddystoneUIDCard extends StatelessWidget {
  final EddystoneUID eddystoneUID;

  EddystoneUIDCard({@required this.eddystoneUID});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text("EddystoneUID"),
          Text("beaconId: ${eddystoneUID.beaconId}"),
          Text("namespaceId: ${eddystoneUID.namespaceId}"),
          Text("tx: ${eddystoneUID.tx}"),
          Text("rssi: ${eddystoneUID.rssi}"),
          Text("distance: ${eddystoneUID.distance}"),
        ],
      ),
    );
  }
}

class EddystoneEIDCard extends StatelessWidget {
  final EddystoneEID eddystoneEID;

  EddystoneEIDCard({@required this.eddystoneEID});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text("EddystoneEID"),
          Text("ephemeralId: ${eddystoneEID.ephemeralId}"),
          Text("tx: ${eddystoneEID.tx}"),
          Text("rssi: ${eddystoneEID.rssi}"),
          Text("distance: ${eddystoneEID.distance}"),
        ],
      ),
    );
  }
}
Future<int> _readIndicator() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/Contacters.csv";
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
void csvgenerator(String uuid, String distance) async{
  String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";


  var f = await File(file + "/Contacters.csv");
  int dd=await _readIndicator();
  if (dd==1)
  {
    print("**********************************************************");
    print("There is file!");
    print("**********************************************************");
    final csvFile = new File(file + "/Contacters.csv")
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
    row.add(uuid);
    row.add(distance);

    rows.add(row);


    String csver = const ListToCsvConverter().convert(rows);
    f.writeAsString(csver);
  }
  else {
    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add(uuid);
    row.add(distance);

    rows.add(row);
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }
}


