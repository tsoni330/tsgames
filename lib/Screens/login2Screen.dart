import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart' as dpack;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/homeScreen.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/bloc/msg_bloc.dart';
import 'package:tusharsonigames/dialogs/game_closed_dialog.dart';
import 'package:tusharsonigames/dialogs/loading_dialog.dart';

import '../size_config.dart';

class Login2Screen extends StatefulWidget {
  String? number;

  Login2Screen(this.number);

  @override
  _Login2ScreenState createState() => _Login2ScreenState();
}

class _Login2ScreenState extends State<Login2Screen> {
  FocusNode? namefocus, reffocus;
  String? name, refid, device_id;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final MsgBloc bloc = MsgBloc();
  RegExp regExp = RegExp(r"^[0-9]{10}$");

  _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      device_id = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      device_id = androidDeviceInfo.androidId;
    }
  }

  @override
  void initState() {
    _getId();
    namefocus = FocusNode();
    reffocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    namefocus!.dispose();
    reffocus!.dispose();
    bloc.dispose();
    super.dispose();
  }

  checkRefrence(String refid) async {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return LoadingDialog('images/loading.json' ,'Please Wait! May take some time / इंतज़ार करे ! थोड़ा टाइम लग सकता है ', 15 );
        });

    String url = 'http://www.aksdute.com/tsgames/refrence_check.php';
    dpack.FormData newData = new dpack.FormData.fromMap({'refid': refid});
    new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (jsonDecode(value.data).toString() == 'true') {
          insertUser();
        } else {
          Navigator.pop(context);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return GameClosedDialog('images/error.json', 'No Refrence Id  found, Please check again / आपकी refrence id हमारे पास save नहीं है , किरपया दोबारा देखे |', 15);
              });
        }
        // Get.offAll(HomeScreen());
      } else {
        SizeConfig().mysnack('Please check your internet connection');
      }
    });
  }

  insertUser() async {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return LoadingDialog('images/loading.json' ,'Please Wait! May take some time / इंतज़ार करे ! थोड़ा टाइम लग सकता है ', 15 );
        });
    String url = 'http://aksdute.com/tsgames/add_user.php';
    final prefs = await SharedPreferences.getInstance();

    await firebaseMessaging.getToken().then((value) {
      dpack.FormData newData = new dpack.FormData.fromMap({
        'name': name,
        'userid': widget.number,
        'refid': refid,
        'token': value.toString(),
        'device_id': device_id
      });
      new dpack.Dio().post(url, data: newData).then((value) {
        if (value.statusCode == 200) {
          if (jsonDecode(value.data).toString() == 'true') {
            Navigator.of(context).pop();
            prefs.setString('userid', widget.number!);
            prefs.setString('name', name!);
            prefs.setString('device_id', device_id!);
            ScaffoldMessenger.of(context)
                .showSnackBar(SizeConfig().mysnack('Your data is save'));
            Get.off(() => HomeScreen());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SizeConfig().mysnack('Something wornge, Please Check in true'));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SizeConfig().mysnack('Check your Internet please... in status code'));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC9D6FF),
                  Color(0xFFE2E2E2)
                ],
              ),
            ),
            width: constraints.maxWidth,
            height: constraints.minHeight,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gtext(
                    'Last Step...',
                    3,
                    color: Colors.black,
                    bold: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Gtext(
                    'Need some more information',
                    1.7,
                    color: Colors.black45,
                    bold: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    borderOnForeground: true,
                    elevation: 5,
                    color: Colors.transparent,
                    shadowColor: Colors.black,
                    margin: EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(5),
                    ),
                    child: Container(
                      decoration:
                      new BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFBD3E9),
                            Color(0xFFddd6f3),

                          ],
                        ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gtext('Enter your name / अपना नाम डाले', 1.7,color: Colors.black,),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            autofocus: true,
                            focusNode: namefocus,
                            style: TextStyle(
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                            decoration: InputDecoration(
                              labelText: 'Your Name',
                              labelStyle: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: new OutlineInputBorder(
                                borderRadius:
                                new BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black45),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius:
                                new BorderRadius.circular(10.0),
                                borderSide:
                                BorderSide(color: Colors.pinkAccent),
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 10, bottom: 11, top: 11),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => name = value,
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(reffocus);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Gtext('If someone given you refrence id then enter it, otherwise leave empty / अगर किसी ने आपको रेफरेंस आईडी दी है तो दर्ज करें, नहीं तो खाली छोड़ दें', 1.7,color: Colors.black,),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            focusNode: reffocus,
                            style: TextStyle(
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                            decoration: InputDecoration(
                              labelText: "Refrence Id",
                              labelStyle: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: new OutlineInputBorder(
                                borderRadius:
                                new BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black45),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius:
                                new BorderRadius.circular(10.0),
                                borderSide:
                                BorderSide(color: Colors.pinkAccent),
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 10, bottom: 11, top: 11),
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) => refid = value,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: StreamBuilder(
                                stream: bloc.blocStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Gtext(
                                      snapshot.data.toString(),
                                      1.7,
                                      color: Colors.red,
                                      bold: true,
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                SizeConfig().mysnack('Please wait....');
                                bloc.blocSink.add(null);

                                if (widget.number == refid) {
                                  bloc.blocSink.add(
                                      "Can't use your number as refrence / आपका अकाउंट नंबर और refrence नंबर एक जैसे नहीं हो सकते |");
                                } else {
                                  if (name!.length <= 0) {
                                    bloc.blocSink.add("Plese Enter Name");
                                  } else {

                                    if(refid!=null){
                                      if (refid!.length>0) {
                                        if(regExp.hasMatch(refid!) == true){
                                          SizeConfig().mysnack('Wait...');
                                          checkRefrence(refid!);
                                        } else{
                                          bloc.blocSink.add("Please Enter only number 10 Digit number / सिर्फ number डालो 10 अंको का");
                                        }
                                      }else{
                                        insertUser();
                                      }
                                    }else {
                                      insertUser();
                                    }
                                  }
                                }

                              },
                              child: Gtext(
                                ' Submit ',
                                2,
                                color: Colors.white,
                                bold: true,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFC04848) ),
                            ),
                          ),
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
