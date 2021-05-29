import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:tuple/tuple.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:cron/cron.dart';

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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


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
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          getPermission();
          startService();
          var cron = new Cron();
          cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
            print('******************************Start of Schedule operation*******************************');
            var answerer=await _generator();
            String uuid_n=answerer.item1;
            csvgenerator(uuid_n.toString());
            print("............Increment: ${_counter}");
              print('******************************End of Schedule operation*******************************');
            });
          },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
Future<int> _readIndicator() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/UUID_testing.csv";
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
void csvgenerator(String uuid) async{
  String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";


  var f = await File(file + "/UUID_testing.csv");
  int dd=await _readIndicator();
  if (dd==1)
  {
    print("**********************************************************");
    print("There is file!");
    print("**********************************************************");
    final csvFile = new File(file + "/UUID_testing.csv")
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

    // }
    row.add(uuid);

    rows.add(row);


    String csver = const ListToCsvConverter().convert(rows);
    f.writeAsString(csver);
  }
  else {
    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add(uuid);

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

  String answer=crypted3.toString();

  return new Tuple2(checker_uid,answer);
  // *********UUID induced*******************
  // return checker_uid;

}