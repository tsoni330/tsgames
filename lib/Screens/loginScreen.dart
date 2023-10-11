import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart' as dpack;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/IconDart/main_icon_icons.dart';
import 'package:tusharsonigames/Screens/homeScreen.dart';
import 'package:tusharsonigames/Screens/login2Screen.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/glassContainer.dart';
import 'package:tusharsonigames/Widgets/iconWidget.dart';
import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/bloc/msg_bloc.dart';
import 'package:tusharsonigames/dialogs/loading_dialog.dart';

import '../size_config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  String? phonenumber, otp, vId,device_id;
  RegExp regExp = RegExp(r"^[0-9]{10}$");
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final MsgBloc? bloc = MsgBloc();

  @override
  void initState() {
    _getId();
    super.initState();
  }


  @override
  void dispose() {
    bloc!.dispose();
    super.dispose();
  }

  _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      device_id = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      device_id = androidDeviceInfo.androidId;
    }
  }

  mysnack(String msg) {
    final waiting = SnackBar(
      content: Gtext(
        msg,
        2,
        color: Colors.white,
      ),
      duration: Duration(milliseconds: 2500),
      elevation: 5,
      backgroundColor: Colors.red,
    );
    return waiting;
  }

  checkUser(String? phonenumber) async {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return LoadingDialog('images/loading.json' ,'Please Wait! May take some time / इंतज़ार करे ! थोड़ा टाइम लग सकता है ', 15 );
        });

    String url = 'http://www.aksdute.com/tsgames/user_login_check.php';
    final prefs = await SharedPreferences.getInstance();
    dpack.FormData newData =
        new dpack.FormData.fromMap({'userid': phonenumber,'device_id':device_id});
    new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (jsonDecode(value.data).toString() == 'false') {
          Navigator.of(context).pop();
          Get.off(() => Login2Screen(phonenumber));
        } else {
          List data = jsonDecode(value.data);
          for (var i in data) {
            prefs.setString('name', i['name']);
            prefs.setString('userid', i['userid']);
            prefs.setString('device_id',device_id!);
          }
          Navigator.of(context).pop();
          Get.off(() => HomeScreen());
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(mysnack('Check your Internet please...'));
      }
    });
  }

  phoneVerification(String phonenumber) async {
    bloc!.blocSink.add(null);
    await auth.verifyPhoneNumber(
        phoneNumber: '+91' + phonenumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          await auth.signInWithCredential(authCredential).then((value) {
            if (value.user != null) {
              checkUser(phonenumber);
            } else {
              bloc!.blocSink.add('Something wronge, Check Internet Connection');
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          bloc!.blocSink.add('Something wronge ' + e.toString());
        },
        codeSent: (String verificationId, int? resendToken) async {
          vId = verificationId;
          bloc!.blocSink.add('Congrulation, Code sent to your number');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          otp = verificationId;
          if(!bloc!.streamController.isClosed){
            bloc!.blocSink.add('Time is out, Send OTP again');
          }
        });
  }

  signinMannually(String verificationID, String otp) async {
    ScaffoldMessenger.of(context).showSnackBar(mysnack('Wait...'));
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otp);

    try {
      var result = await auth.signInWithCredential(phoneAuthCredential);
      if (result.user != null) {
        checkUser(phonenumber);
      } else {
        bloc!.blocSink.add('Something wronge, Check Internet Connection');
      }
    } catch (e) {
      bloc!.blocSink.add('Error:- ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: CustomIconWidget(
                      MainIcon.mainicon,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gtext(
                        'Welcome ',
                        2.5,
                        color: Colors.black,
                        bold: true,
                      ),
                      Gtext(
                        'Login / Signup here',
                        1.8,
                        color: Colors.black45,
                      )
                    ],
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gtext(
                            'Why you choose us ',
                            2,
                            color: Colors.black,
                            bold: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Gtext(
                            '1. Earn money limitless every hour',
                            1.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Gtext(
                            '2. Minimum withdraw ' + '\u20b9' + '50',
                            1.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Gtext(
                            '3. Get exciting offers every hour',
                            1.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Gtext(
                            '4. Easy in Use',
                            1.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Gtext(
                            '5. Get highest commission from Refer and Earn program',
                            1.5,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Gtext(
                      '--Join Us Now--',
                      2.2,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Gtext(
                    'Enter your 10 digit number / अपना 10 अंको का फ़ोन नंबर दर्ज करे |',
                    1.3,
                    color: Colors.black45,
                    bold: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          autofocus: true,
                          style: TextStyle(
                              fontSize: 2 * SizeConfig.textMultiplier,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Ex: 9999999999",
                            hintStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 2 * SizeConfig.textMultiplier),
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black45),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.pinkAccent),
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 11, top: 11),
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) => phonenumber = value,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration:
                        new BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFC04848),
                              Color(0xFF480048),

                            ],
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            if(regExp.hasMatch(
                                phonenumber!) ==
                                true){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(mysnack('Wait...'));
                              phoneVerification(phonenumber!);
                            }else{
                              bloc!.blocSink.add('Please Enter only number 10 Digit number / सिर्फ number डालो 10 अंको का');
                            }

                          },
                          child: Gtext(
                            'Get OTP',
                            1.7,
                            color: Colors.white,
                            bold: true,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: StreamBuilder(
                        stream: bloc!.blocStream,
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
                  TextField(
                    style: TextStyle(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Enter OTP here",
                      hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold),
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.pinkAccent),
                      ),
                      contentPadding:
                          EdgeInsets.only(left: 10, bottom: 11, top: 11),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) => otp = value,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          signinMannually(vId!, otp!);
                        },
                        child: Gtext(
                          ' Submit ',
                          2,
                          color: Colors.black,
                          bold: true,
                        ),
                        style: ElevatedButton.styleFrom(
                            primary:  Color(0xFFFBD3E9)),
                      )),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
