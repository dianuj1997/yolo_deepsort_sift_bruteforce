import 'package:flutter/material.dart';
import 'package:sampleproject/forgot_email_newpassword.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class Email {
  final String email;

  Email(this.email);
}

class ForgotForm extends StatefulWidget
{







  @override
  State<StatefulWidget> createState() {
    return _ForgotFormState();
  }

}
class _ForgotFormState extends State<ForgotForm> {
  final myController_email = TextEditingController();
  final myController_code = TextEditingController();
  final _minpad = 5.0;
  bool _x=false;



  forgotemail(email) async {
    var url = Uri.http('13.229.160.192:5000', '/verifycodeviaemail');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          "email": email
        }));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['Token'];
      if (itemCount != null) {
        print('Here is the returned token: $itemCount.');
        return 0;
      } else {
        // print('Here is the returned token: $itemCount.');
        print('Password update successful with status: ${response.statusCode}.');
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
      // appBar: AppBar(
      //   title: Text('COVID Tracker'),
      // ),
      body: Container(
          margin: EdgeInsets.all(_minpad * 2),
          child: Column(
            children: <Widget>[

              Padding(
                  padding: EdgeInsets.only(top: _minpad*30, bottom: _minpad * 10),
                  child: Text(
                    "Forgot Password",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 40.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  )),

              // Padding(
              //     padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
              //     child: TextField(
              //       keyboardType: TextInputType.name,
              //       decoration: InputDecoration(
              //           labelText: 'Enter Email',
              //           hintText: 'e.g.xyz@gotmail.com',
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(5.0))),
              //     )),
              Padding(
                  padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          // child: Padding(
                            padding:
                            EdgeInsets.only(top: _minpad, bottom: _minpad),
                            child: TextField(
                              controller: myController_email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Enter Email',
                                  hintText: 'e.g.xyz@gotmail.com',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(5.0))),
                            )),
                      ),
                      Container(
                        width: _minpad * 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                        // child: Expanded(
                        child: SizedBox(
                            width: 70.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: Theme
                                  .of(context)
                                  .primaryColorDark,
                              textColor: Theme
                                  .of(context)
                                  .primaryColorLight,
                              child: Text('Send Code'),
                              onPressed: () async{
                                _onCheckPushed(true);
                                debugPrint("Next is pressed");
                                final login_result = await forgotemail(myController_email.text);
                                print("Update password result: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" + login_result.toString());
                                // Navigator.push(context, MaterialPageRoute(builder: (
                                //     context) {
                                //   return ResetForm();
                                // }
                                // ));
                              },
                              elevation: 20.0,
                            )),),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                  child: TextField(
                     enabled: _x,
                    controller: myController_code,
                      keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Enter Verification Code',
                        hintText: 'e.g. XXXXX',
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
                padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                // child: Expanded(
                child: SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: RaisedButton(
                      color: Theme
                          .of(context)
                          .primaryColorDark,
                      textColor: Theme
                          .of(context)
                          .primaryColorLight,
                      child: Text('Next'),
                      onPressed: () async{
                        debugPrint("Next is pressed");
                        Navigator.push(context, new MaterialPageRoute(builder: (
                            context) {
                          return new ResetForm(email:myController_email.text);
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
  void _onCheckPushed(bool newSelected) {
    setState(() {
      this._x = newSelected;
    });
  }
}