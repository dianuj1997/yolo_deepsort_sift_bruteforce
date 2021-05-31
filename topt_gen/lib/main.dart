import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_otp/dart_otp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOPT_Gen_Val',
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
      home: MyHomePage(title: ''),
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
  final delayer = TextEditingController();
  String shared_secret="J22U6B3WIWRRBTAV";
  String _totpNow="";
  String _totpDelay="";
  String _boolNow="";
  String _boolDelay="";
  var _opac=0.0;



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
        Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 60.0,left: 30.0,right:30.0),
        child:TextField(
            controller: delayer,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Delay in Seconds',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ),),
            Text(
              'Shared Secret: ${shared_secret}',
            ),
            Text(
              'Current TOTP: ${_totpNow}',
            ),

      Text(
              'Delayed TOTP: ${_totpDelay}',
            ),
            Text(
              'Current TOTP Verification: ${_boolNow}',
            ),
            Text(
              'Delayed TOPT Verification: ${_boolDelay}',
            ),
            Text(
              '',
            ),
            Text(
              '',
            ),
            new Opacity(opacity: _opac, child: new Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Please fill non zero delay',
                    ),
              new Icon(Icons.error, color: CupertinoColors.destructiveRed),])
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if (delayer.text=='')
          {
            setState(() {
              _opac = 1.0;
            });

          }
          else {
            setState(() {
              _opac = 0.0;

              TOTP totp_now = TOTP(secret: shared_secret,digits: 8);


              TOTP totp_later = TOTP(secret: shared_secret, interval: int.parse(delayer.text), digits: 8);

              if (delayer.text==null)
                {
                  _opac=100.0;
                }

              _totpNow=totp_now.now();
              _totpDelay=totp_later.now();
              print("Current TOTP: "+totp_now.now());
              print("Later TOTP: "+totp_later.now());

              /// verify for the current time
              if (totp_now.verify(otp: totp_now.now()))
              {
                _boolNow="True";
              }
              else
              {
                _boolNow="False";
              }

              /// verify after mentioned
              if (totp_later.verify(otp: totp_now.now()))
                {
                  _boolDelay="True";
                }
              else
                {
                  _boolDelay="False";
                }/// => false

            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.check_circle_outline),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
