import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/bank_details.dart';
import 'package:tusharsonigames/Screens/noInternet.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/loadingWidget.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/bloc/MyConnectivity.dart';
import 'package:tusharsonigames/bloc/msg_bloc.dart';
import 'package:dio/dio.dart' as dpack;
import 'package:tusharsonigames/dialogs/another_login_dialog.dart';
import 'package:tusharsonigames/dialogs/game_closed_dialog.dart';
import 'package:tusharsonigames/dialogs/loading_dialog.dart';
import '../appColor.dart';
import '../size_config.dart';

class RefrenceWithdraw extends StatefulWidget {
  double? money;

  RefrenceWithdraw(this.money);

  @override
  _RefrenceWithdrawState createState() => _RefrenceWithdrawState();
}

class _RefrenceWithdrawState extends State<RefrenceWithdraw> {
  String? userid, device_id, local_device_id;
  String? name, acc_no, ifsc, type, acc_status;
  late SharedPreferences prefs;
  String? added_money;
  TextEditingController? added_money_controller;
  String? string;
  late Map _source;
  MyConnectivity? _connectivity = MyConnectivity.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? otp, vId;
  final MsgBloc bloc = MsgBloc();
  RegExp regExp = RegExp(r"^[1-9][0-9]*$");
  bool loading = false;

  phoneVerification(String phonenumber) async {
    bloc.blocSink.add(null);
    await auth.verifyPhoneNumber(
        phoneNumber: '+91' + phonenumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          await auth.signInWithCredential(authCredential).then((value) {
            if (value.user != null) {
              withdrawRequest(int.parse(added_money_controller!.text));
            } else {
              bloc.blocSink.add('Something wronge, Check Internet Connection');
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          bloc.blocSink.add('Something wronge ' + e.toString());
        },
        codeSent: (String verificationId, int? resendToken) async {
          vId = verificationId;
          bloc.blocSink.add('Congrulation, Code sent to your number');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          otp = verificationId;
          bloc.blocSink.add('Time is out, Send OTP again');
        });
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

  signinMannually(String verificationID, String otp) async {
    ScaffoldMessenger.of(context).showSnackBar(mysnack('Wait...'));
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otp);
    try {
      var result = await auth.signInWithCredential(phoneAuthCredential);
      if (result.user != null) {
        withdrawRequest(int.parse(added_money_controller!.text));
      } else {
        bloc.blocSink.add('Something wronge, Check Internet Connection');
      }
    } catch (e) {
      bloc.blocSink.add('Error:- ' + e.toString());
    }
  }

  getBankDetail(String? userid) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    String url = 'http://www.aksdute.com/tsgames/get_bank_detail.php';
    dpack.FormData newData = new dpack.FormData.fromMap({'userid': userid});
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          List data = jsonDecode(value.data);
          for (var i in data) {
            name = i['name'].toString();
            acc_no = i['acc_no'].toString();
            ifsc = i['ifsc'].toString();
            type = i['acc_type'].toString();
            acc_status = i['acc_status'].toString();
          }

          if (mounted) {
            setState(() {
              loading = false;
            });
          }
        } else {
          setState(() {
            loading = false;
            bloc.blocSink.add('Something wronge, Check Internet Connection');
          });
        }
      }
    });
  }

  /*getBankDetail(String? userid) async {
    String url = 'http://www.aksdute.com/tsgames/get_bank_detail.php';
    dpack.FormData newData = new dpack.FormData.fromMap({'userid': userid});
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          List data = jsonDecode(value.data);
          for (var i in data) {
            prefs.setString('upi_id', i['upi_id'].toString());
            prefs.setString('upi_name', i['upi_name'].toString());
            upi_id = i['upi_id'].toString();
            upi_name = i['upi_name'].toString();

          }
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }*/

  getSaveBankDetails() async {
    prefs = await SharedPreferences.getInstance();
    local_device_id = prefs.getString('device_id');
    userid = prefs.getString('userid');
    if (userid != null) {
      getBankDetail(userid);
    }
  }

  withdrawRequest(int amount) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return LoadingDialog(
              'images/loading.json',
              'Please Wait! May take some time / इंतज़ार करे ! थोड़ा टाइम लग सकता है ',
              15);
        });

    String url = 'http://www.aksdute.com/tsgames/add_refearn_tran.php';
    dpack.FormData newData = new dpack.FormData.fromMap({
      'userid': userid,
      'amount': amount,
      'device_id': local_device_id, //device_id,
      'name': name,
      'acc_no': acc_no
    });
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          if (jsonDecode(value.data).toString() == 'true') {
            widget.money = widget.money! - amount;
            Navigator.pop(context);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return GameClosedDialog(
                      'images/successful.json',
                      'Your withdraw request is successfully registerd / आपकी request हमको मिल चुकी है, धन्यवाद!',
                      15);
                });
          } else {
            if (jsonDecode(value.data).toString() == 'device_id') {
              Navigator.pop(context);
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) {
                    return AnotherLoginDialog();
                  });
            }
          }
        } else {
          Navigator.pop(context);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return GameClosedDialog(
                    'images/error.json', 'Check your internet connection', 15);
              });
        }
        if (mounted) {
          setState(() {});
        }
      } else {
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) {
              return GameClosedDialog(
                  'images/error.json', 'Check your internet connection', 15);
            });
      }
    });
  }

  @override
  void initState() {
    _connectivity!.initialise();
    _connectivity!.myStream.listen((source) {
      if (mounted) {
        setState(() => _source = source);
      }

      if (_source.keys.toList()[0] == ConnectivityResult.none) {
        string = "Offline";
      } else {
        string = "Online";
        getSaveBankDetails();
      }
    });
    added_money_controller = TextEditingController();
    //getSaveBankDetails();
    super.initState();
  }

  @override
  void dispose() {
    added_money_controller!.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    Get.back(result: 'true');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return WillPopScope(
        onWillPop: _willPopCallback,
        child: SafeArea(
          child: Scaffold(
            body: string != null
                ? string != 'Offline'
                    ? Container(
                        padding: EdgeInsets.all(10),
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFC9D6FF), Color(0xFFE2E2E2)
                            ],
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.back(result: 'true');
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 3.5 * SizeConfig.heightMultiplier,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2 * SizeConfig.heightMultiplier,
                                  ),
                                  Gtext(
                                    "Instant Refrence Withdraw",
                                    2,
                                    color: Colors.black,
                                    bold: true,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Gtext(
                                    "Note:- We work between 9am to 9pm. your money will transfer to your account "
                                    "within 30 minute to 1 hour. "
                                    "If you request after 9 pm then your money will transfer to next day"
                                    " / "
                                    "हम सुबह 9 बजे से रात 9 बजे के बीच काम करते हैं। आपका पैसा 30 मिनट से 1 "
                                    "घंटे के भीतर आपके खाते में ट्रांसफर हो जाएगा।"
                                    " अगर आप रात 9 बजे के बाद request भेजते हो तो आपका पैसा अगले दिन ट्रांसफर हो जाएगा",
                                    1.3,
                                    color: Colors.black45,
                                  )),
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                width: double.maxFinite,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFE8CBC0),
                                      Color(0xFF636FA4)
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Gtext(
                                      'Your Winnings',
                                      1.8,
                                      bold: true,
                                      color: Colors.black,
                                    ),
                                    Gtext(
                                      '\u20b9' + widget.money.toString(),
                                      1.8,
                                      bold: true,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3 * SizeConfig.heightMultiplier,
                              ),
                              loading == false
                                  ? name != null
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Gtext(
                                              'Your Bank Details',
                                              1.7,
                                              bold: true,
                                              color: Colors.black,
                                            ),
                                            SizedBox(
                                              height: 1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(15),
                                              width: double.maxFinite,
                                              decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF83a4d4),
                                                    Color(0xFF83a4d4)
                                                  ],
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Gtext(
                                                        name!,
                                                        1.5,
                                                        color: Colors.black,
                                                        bold: true,
                                                      ),
                                                      Gtext(
                                                        acc_no.toString(),
                                                        1.5,
                                                        color: Colors.white,
                                                        bold: true,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Gtext(
                                                        ifsc.toString(),
                                                        1.5,
                                                        color: Colors.black,
                                                        bold: true,
                                                      ),
                                                      Gtext(
                                                        type.toString(),
                                                        1.5,
                                                        color: Colors.white,
                                                        bold: true,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(10),
                                          color: Colors.red,
                                          width: double.maxFinite,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Gtext(
                                                'Opps! Your Bank Details Not Saved',
                                                2,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                height: 1 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Get.off(BankDetails());
                                                  },
                                                  child: Gtext(
                                                    "Go to Bank Details Page",
                                                    1.7,
                                                    color: Colors.black,
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                  : LoadingWidget('Getting your bank details'),
                              SizedBox(
                                height: 3 * SizeConfig.heightMultiplier,
                              ),
                              loading==false?
                              acc_status=='Pending'?Column(
                                children: [
                                  Gtext(
                                    '-- Pending --',
                                    3,
                                    color: Colors.redAccent,
                                    bold: true,
                                  ),
                                  SizedBox(height: 5,),
                                  Gtext(
                                    'Your Account status is pending/अभी आपका बैंक स्टेटस Pending है आप पैसे तब तक ट्रांसफर नहीं होंगे ',
                                    1.3,
                                    color: Colors.black45,
                                    bold: true,
                                  ),
                                ],
                              ):
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      Gtext(
                                        '-- Update --',
                                        3,
                                        color: Colors.green,
                                        bold: true,
                                      ),
                                      SizedBox(height: 5,),
                                      Gtext(
                                        'Your Account status is update/आपका अकाउंट अपडेट हो चुका है ',
                                        1.3,
                                        color: Colors.black45,
                                        bold: true,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF5f2c82),
                                          Color(0xFF49a09d)

                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Gtext(
                                          'Amount',
                                          1.8,
                                          color: Colors.white,
                                          bold: true,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Gtext(
                                              '\u20b9 ',
                                              2.5,
                                              color: Colors.white,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                                keyboardType: TextInputType.number,
                                                controller: added_money_controller,
                                                decoration: InputDecoration(
                                                    hintText: 'Enter Amount Here',
                                                    hintStyle: TextStyle(color: Colors.white70)
                                                ),
                                                autofocus: false,
                                                textInputAction:
                                                TextInputAction.done,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1 * SizeConfig.heightMultiplier,
                                        ),
                                        Gtext(
                                          'Min \u20b950 & Max \u20b945000 allowed per day ',
                                          1.3,
                                          color: Colors.white70,
                                          bold: true,
                                        ),
                                        SizedBox(
                                          height: 1 * SizeConfig.heightMultiplier,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: StreamBuilder(
                                              stream: bloc.blocStream,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Gtext(
                                                    snapshot.data.toString(),
                                                    1.3,
                                                    color: Colors.red,
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                          height: 2 * SizeConfig.heightMultiplier,
                                        ),

                                        Container(
                                          width: double.maxFinite,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              bloc.blocSink.add(null);
                                              try {
                                                if (regExp.hasMatch(
                                                    added_money_controller!
                                                        .text) ==
                                                    true) {
                                                  if (name != null) {
                                                    if (int.parse(
                                                        added_money_controller!
                                                            .text) >=
                                                        50 &&
                                                        int.parse(
                                                            added_money_controller!
                                                                .text) <=
                                                            45000) {
                                                      if (int.parse(
                                                          added_money_controller!
                                                              .text) <=
                                                          widget.money!) {
                                                        ScaffoldMessenger.of(context).showSnackBar(mysnack('Wait...'));

                                                        withdrawRequest(int.parse(added_money_controller!.text));

                                                      } else {
                                                        bloc.blocSink.add(
                                                            'Insufficient Balance / खाते में कम पैसे है');
                                                      }
                                                    } else {
                                                      bloc.blocSink.add(
                                                          'Min \u20b950 & Max \u20b945000 allowed per day ');
                                                    }
                                                  } else {
                                                    bloc.blocSink.add(
                                                        'Please save your UPI Details first');
                                                  }
                                                } else {
                                                  bloc.blocSink.add(
                                                      'Please Enter only number like (150,90,20) not like (020, 010, 125.5) / सिर्फ number डालो इसकी तरह (120 , 50 , 45000 ) ना की इसकी तरह (0120 , 150.50 , 080) ');
                                                }
                                              } catch (e) {
                                                if (e.runtimeType ==
                                                    FormatException) {
                                                  bloc.blocSink.add(
                                                      'Please enter only numbers ' +
                                                          e.runtimeType
                                                              .toString());
                                                } else {
                                                  bloc.blocSink.add(
                                                      e.runtimeType.toString());
                                                }
                                              }
                                            },
                                            child: Gtext(
                                              'Withdraw',
                                              2,
                                              color: Colors.black,
                                              bold: true,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xFFC9D6FF)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ):SizedBox()
                              /*Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Gtext(
                                      'Amount',
                                      1.5,
                                      color: Colors.black,
                                      bold: true,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Gtext(
                                          '\u20b9 ',
                                          2,
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            keyboardType: TextInputType.number,
                                            controller: added_money_controller,
                                            autofocus: false,
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            bloc.blocSink.add(null);
                                            try {
                                              if (regExp.hasMatch(
                                                      added_money_controller!
                                                          .text) ==
                                                  true) {
                                                if (name != null) {
                                                  if (int.parse(
                                                              added_money_controller!
                                                                  .text) >=
                                                          50 &&
                                                      int.parse(
                                                              added_money_controller!
                                                                  .text) <=
                                                          49000) {
                                                    if (int.parse(
                                                            added_money_controller!
                                                                .text) <=
                                                        widget.money!) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(mysnack(
                                                              'Wait...'));
                                                      phoneVerification(
                                                          userid!);
                                                    } else {
                                                      bloc.blocSink.add(
                                                          'Insufficient Balance / खाते में कम पैसे है');
                                                    }
                                                  } else {
                                                    bloc.blocSink.add(
                                                        'Min \u20b950 & Max \u20b945000 allowed per day ');
                                                  }
                                                } else {
                                                  bloc.blocSink.add(
                                                      'Please save your UPI detail first');
                                                }
                                              } else {
                                                bloc.blocSink.add(
                                                    'Please Enter only number like (150,90,20) not like (020, 010, 125.5) / सिर्फ number डालो इसकी तरह (120 , 50 , 45000 ) ना की इसकी तरह (0120 , 150.50 , 080) ');
                                              }
                                            } catch (e) {
                                              if (e.runtimeType ==
                                                  FormatException) {
                                                bloc.blocSink.add(
                                                    'Please enter only numbers ' +
                                                        e.runtimeType
                                                            .toString());
                                              } else {
                                                bloc.blocSink.add(
                                                    e.runtimeType.toString());
                                              }
                                            }
                                          },
                                          child: Gtext(
                                            'Get OTP',
                                            1.7,
                                            color: Colors.white,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: ColorSystem.klight),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    Gtext(
                                      'Min \u20b950 & Max \u20b949000 allowed per day ',
                                      1.5,
                                      color: Colors.grey,
                                      bold: true,
                                    ),
                                    SizedBox(
                                      height: 1.5 * SizeConfig.heightMultiplier,
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
                                      height: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    TextField(
                                      style: TextStyle(
                                          fontSize:
                                              2 * SizeConfig.textMultiplier,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Enter OTP here",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize:
                                                2 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Colors.pinkAccent),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 10, bottom: 11, top: 11),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) => otp = value,
                                    ),
                                    SizedBox(
                                      height: 1.5 * SizeConfig.heightMultiplier,
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          bloc.blocSink.add(null);
                                          if (vId != null && otp != null) {
                                            signinMannually(vId!, otp!);
                                          }
                                        },
                                        child: Gtext(
                                          'Withdraw now',
                                          2,
                                          color: Colors.white,
                                          bold: true,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: ColorSystem.klight),
                                      ),
                                    )
                                  ],
                                ),
                              )*/
                            ],
                          ),
                        ),
                      )
                    : noInternet()
                : LottieAnimation(10, "images/loading.json"),
          ),
        ),
      );
    });
  }
}
