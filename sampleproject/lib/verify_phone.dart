import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sampleproject/main_page.dart';
import 'package:sampleproject/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';




class VerifyForm extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _VerifyFormState();
  }

}
class _VerifyFormState extends State<VerifyForm>
{
  final _minpad=5.0;
  final myController1 = TextEditingController();


  verify(username,otp) async {
    var url = Uri.http('13.229.160.192:5000', '/verifyotp');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode({
          "username": username,
          "otp": int.parse(otp),
        }));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['Token'];
      if (itemCount != null) {
        print('Here is the returned token: $itemCount.');
        print(jsonResponse["status"]);
        return 0;
      } else {
        // print('Here is the returned token: $itemCount.');
        print('Verification successful with status: ${response.statusCode}.');
        return 1;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return 2;
    }
  }

  local_store() async {}

  @override
  Widget build(BuildContext context) {
    //TextStyle textStyle=Theme.of(context).textTheme.title;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar:AppBar(
      //   title:Text('COVID Tracker'),
      // ),
      body:Container(
          margin:EdgeInsets.all(_minpad*2) ,
          child:Column(
            children: <Widget>[
              getImageAsset(),
              Padding(
                  padding:EdgeInsets.only(top:_minpad,bottom: _minpad*10),
                  child:Text(
                    "Phone Verification",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 40.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  )),

              Padding(
                  padding: EdgeInsets.only(top:_minpad,bottom: _minpad),
                  child:TextField(
                    controller: myController1,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        hintText: 'XXXXX',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              // Padding(
              //     padding: EdgeInsets.only(top:_minpad,bottom: _minpad),
              //     child:TextField(
              //       keyboardType: TextInputType.emailAddress,
              //       decoration: InputDecoration(
              //           labelText: 'Email',
              //           hintText: 'e.g.xyz@hotmail.com',
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(5.0))),
              //     )),
              // Padding(
              //     padding:EdgeInsets.only(top:_minpad,bottom: _minpad),
              //
              //     child:Row(children: <Widget>[
              //
              //       Expanded(
              //         child: Padding(
              //             padding: EdgeInsets.only(top:_minpad,bottom: _minpad),
              //             child:TextField(
              //               keyboardType: TextInputType.phone,
              //               decoration: InputDecoration(
              //                   labelText: 'Phone Number',
              //                   hintText: '(+Country Code)(Phone Number))',
              //                   border: OutlineInputBorder(
              //                       borderRadius: BorderRadius.circular(5.0))),
              //             )),),
              //
              //       Container(width: _minpad*5,),
              //       Expanded(
              //           child:DropdownButton<String>(
              //               hint: Text('Category'),
              //               items:_cat.map((String value){
              //                 return DropdownMenuItem<String>(
              //                   value:value,
              //                   child:Text(value),
              //                 );
              //               }
              //               ).toList(),
              //               value:_currentCat,
              //               onChanged: (String newValueSelected)
              //               {
              //                 _onDroDownItemSelected(newValueSelected);
              //               }
              //
              //           ))
              //     ],)),
              // Padding(
              //     padding: EdgeInsets.only(top:_minpad,bottom: _minpad),
              //     child:TextField(
              //       keyboardType: TextInputType.name,
              //       decoration: InputDecoration(
              //           labelText: 'New Password',
              //           hintText:'only characters and numbers are allowed',
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(5.0)
              //           )
              //       ),
              //     )),

              Padding(
                padding: EdgeInsets.only(top: _minpad,bottom: _minpad),
                // child:Expanded(
                child:SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child:RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child:Text('Verify'),
                      onPressed: ()
                      async{
                        debugPrint("Verify is pressed");
                        //************************************************************************************************
                        final login_result = await verify("Junaid11",myController1.text);
                        print("Verification Result" + login_result.toString());
                        _write(login_result.toString());
                        //***********************************************************************************

                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return MainForm();
                        }
                        ));
                      },
                      elevation: 20.0,
                    )),),
              //

            ],
          )
      ),
    );
  }




  Widget getImageAsset()
  {
    AssetImage assetImage=AssetImage('images/verify_fig.png');
    Image image=Image(image:assetImage,width: 125.0,height:125.0,);
    return Container(child: image,margin: EdgeInsets.only(left:_minpad*10,right:_minpad*10,top:_minpad*10),);
  }
}
_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/ref_signup_Data.txt');
  await file.writeAsString(text);
  debugPrint(
      "A file with new content,i.e. ${text} has been stored at ${directory.path}");
}