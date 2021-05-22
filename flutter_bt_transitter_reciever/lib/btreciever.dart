import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';

void generateCsvFile() async {
  // Map<PermissionGroup, PermissionStatus> permissions =
  // await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  List<dynamic> associateList = [
    {"number": 1, "lat": "14.97534313396318", "lon": "101.22998536005622"},
    {"number": 2, "lat": "14.97534313396318", "lon": "101.22998536005622"},
    {"number": 3, "lat": "14.97534313396318", "lon": "101.22998536005622"},
    {"number": 4, "lat": "14.97534313396318", "lon": "101.22998536005622"}
  ];

  List<List<dynamic>> rows = [];

  List<dynamic> row = [];
  row.add("number");
  row.add("latitude");
  row.add("longitude");
  rows.add(row);
  for (int i = 0; i < associateList.length; i++) {
    List<dynamic> row = [];
    row.add(associateList[i]["number"] - 1);
    row.add(associateList[i]["lat"]);
    row.add(associateList[i]["lon"]);
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);

  String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";

  var f = await File(file + "/BT_collection_data.csv");
  // File(file + "/filename.csv").readAsString().then((csv) {
  //   print(csv);
  // });

  f.writeAsString(csv);

  // setState(() {
  //   _counter++;
  // });
}








// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(Reception());
// }

class Reception extends StatefulWidget {
  @override
  _ReceptionState createState() => _ReceptionState();
}

class _ReceptionState extends State<Reception> {
  String _beaconResult = 'Not Scanned Yet.';
  int _nrMessaggesReceived = 0;
  int _availablecheck=0;
  var isRunning = false;

  final StreamController<String> beaconEventsController =
  StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    beaconEventsController.close();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    await BeaconsPlugin.addRegion(
        "BeaconType1", "909c3cf9-fc5c-4841-b695-380958a51a5a");
    await BeaconsPlugin.addRegion(
        "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");

    //***************************************************************************
    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir";


      var f = await File(file + "/BT_collection5.csv");



    //***************************************************************************

    beaconEventsController.stream.listen(
            (data) async{
          if (data.isNotEmpty) {
            setState(() {
              _beaconResult = data;
              _nrMessaggesReceived++;
            });
            var parseddata = json.decode(data);

            var uuid = parseddata['uuid'];
            var distance = parseddata['distance'];
            var proximity = parseddata['proximity'];
            var scantime= parseddata['scanTime'];
            var rssi = parseddata['rssi'];

            int dd=await _readIndicator();
            if (dd==1)
              {
                print("**********************************************************");
                print("There is file!");
                print("**********************************************************");
                final csvFile = new File(file + "/BT_collection5.csv")
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
                  row.add(dat[i][4]);
                  rows.add(row);
                }
                for (int i = 0; i < dat.length; i++) {
                  List<dynamic> row = [];
                  row.add(dat[i][0]);
                  row.add(dat[i][1]);
                  row.add(dat[i][2]);
                  row.add(dat[i][3]);
                  row.add(dat[i][4]);
                  rows.add(row);
                }
                row.add(uuid);
                row.add(distance);
                row.add(proximity);
                row.add(scantime);
                row.add(rssi);

                rows.add(row);
                String csver = const ListToCsvConverter().convert(rows);
                f.writeAsString(csver);
              }
            else {
              List<List<dynamic>> rows = [];

              List<dynamic> row = [];
              row.add(uuid);
              row.add(distance);
              row.add(proximity);
              row.add(scantime);
              row.add(rssi);

              rows.add(row);
              String csv = const ListToCsvConverter().convert(rows);
              f.writeAsString(csv);
            }

            print("Beacons DataReceived: " + data);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring();
          setState(() {
            isRunning = true;
          });
        }
      });
    } else if (Platform.isIOS) {
      await BeaconsPlugin.startMonitoring();
      setState(() {
        isRunning = true;
      });
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Monitoring Beacons'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$_beaconResult'),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Text('$_nrMessaggesReceived'),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if(isRunning)
                  {
                    await BeaconsPlugin.stopMonitoring();
                  }
                  else
                  {

                    initPlatformState();

                    await BeaconsPlugin.startMonitoring();

                  }
                  setState(() {
                    isRunning = !isRunning;
                  });
                },
                child: Text(isRunning?'Stop Scanning':'Start Scanning', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }}
Future<int> _readIndicator() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/BT_collection5.csv";
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

