// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
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

  Future download2(
      Dio dio, String url, String savePath, final uuidd, final dist) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      //  print(response.headers);
      File file = File(savePath);
      List<dynamic> row = List();
      //List<dynamic> col = List();

      // row.add(
      //     "$date"); // ',' $time ',' $latt N ',' $longg E ',' $altt m ',' $speed m/s ',' $accelerometer m/s^2 ',' $gyroscope m/s^2 ");
      //row.add("$time");
      row.add("$uuidd");
      row.add("$dist");
      rows.add(row);

//      }
//      String csv = const ListToCsvConverter().convert(rows);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      String csv = const ListToCsvConverter().convert(rows);
      file.writeAsString(csv, mode: FileMode.append, flush: true);
      //file.writeAsString(g);
      await raf.close();
    } catch (e) {
      //  print(e);
    }
/*    processLines(List<String> lines) {
      for (var line in lines) {
        print(line);
      }
    }*/
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      //  print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  void downloadcsvfile(final uuidd, final dist) async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    //String fullPath = tempDir.path + "/boo2.pdf'";
    String fullPath = "$path/Beacons.csv";
    //print('full path ${fullPath}');
    download2(dio, imgUrl, fullPath, uuidd, dist);
  }

  IBeaconCard({@required this.iBeacon});
  // final a = IBeacon.fromScanResult(iBeacon.;
  @override
  Widget build(BuildContext context) {
    final a = iBeacon.uuid;
    final b = iBeacon.distance;
    print("********************************************************");
    print("Let me know the UUID:");
    print(a);
    csvgenerator(a.toString(),b.toString());

   print("***************************************************************");
    // downloadcsvfile(a, b);
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
    String fullPath = "$path/BT_collection7.csv";
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


  var f = await File(file + "/BT_collection7.csv");
  int dd=await _readIndicator();
  if (dd==1)
  {
    print("**********************************************************");
    print("There is file!");
    print("**********************************************************");
    final csvFile = new File(file + "/BT_collection7.csv")
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


