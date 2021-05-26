import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:randombytes/randombytes.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

//transmitter
onPressed(String superb) async {
  if (broadcasting) {
    await flutterBeacon.stopBroadcast();
  } else {
    //*******************************************************************************
    await flutterBeacon.startBroadcast(BeaconBroadcast(
      proximityUUID: '${superb}',
      major: int.tryParse(majorController.text) ?? 0,
      minor: int.tryParse(minorController.text) ?? 0,
    ));
  }
}

//**************************************************************/
final clearFocus = FocusNode();
bool broadcasting = false;

String _varuuid='123';
var rng = new Random();
final regexUUID = RegExp(r'[0-90-90-0]{8}');
final uuidController = TextEditingController(text: '${_varuuid}');
final majorController = TextEditingController(text: '0');
final minorController = TextEditingController(text: '0');

@override
void initState() {
  initBroadcastBeacon();
}

initBroadcastBeacon() async {
  await flutterBeacon.initializeScanning;
}

@override
void dispose() {
  clearFocus.dispose();
}
