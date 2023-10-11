import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dpack;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/addMoney.dart';
import 'package:tusharsonigames/Screens/bb_chart.dart';
import 'package:tusharsonigames/Screens/introScreen.dart';
import 'package:tusharsonigames/Screens/noInternet.dart';
import 'package:tusharsonigames/Screens/playGame1.dart';
import 'package:tusharsonigames/Screens/refrenceWithdraw.dart';
import 'package:tusharsonigames/Screens/splashScreen.dart';
import 'package:tusharsonigames/Screens/withdrawMoney.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/Ltext.dart';
import 'package:tusharsonigames/Widgets/currentResultDesign.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/Widgets/navigationDrawerWidget.dart';
import 'package:tusharsonigames/Widgets/showRefrenceId.dart';

import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/bloc/MyConnectivity.dart';
import 'package:tusharsonigames/bloc/animation_bloc.dart';
import 'package:tusharsonigames/dialogs/another_login_dialog.dart';
import 'package:tusharsonigames/dialogs/game_closed_dialog.dart';
import 'package:tusharsonigames/dialogs/result_notification.dart';
import 'package:tusharsonigames/dialogs/server_maintanence_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../size_config.dart';
import 'chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  User? user;
  final FirebaseAuth auth = FirebaseAuth.instance;

  AnimationController? animationController;
  Animation? animation;
  AnimationBloc? animationBloc = AnimationBloc();

  int userLoginCheck = 0;
  int walletLoading = 0;
  String? name,
      mainuserid,
      twotime,
      tentime,
      g_date,
      timing,
      latest_version,
      v_msg,
      working,
      w_msg,
      version_prefs,
      db_deviceid,
      local_device_id,
  bb_today,bb_yesterday,bb_date;
  int? added, withdraw, wingame, totalgame;
  double? ref_earn;

  String? string;

  late Map _source;

  MyConnectivity? _connectivity = MyConnectivity.instance;

  getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    mainuserid = prefs.getString('userid');
    version_prefs = prefs.getString('versionCode');
    local_device_id = prefs.getString('device_id');
    if (mainuserid != null) {
      getUserInfo(mainuserid);
    } else {
      if (mounted) {
        setState(() {
          userLoginCheck = -1;
        });
      }
    }
  }

  _launchURL(String url) async {
    try {
      if (!await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      )) {
        throw 'Error';
      }
    } catch (e) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return GameClosedDialog('images/error.json',
                'Cannot launch url right now, try later', 15);
          });
    }
  }

  removeAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (prefs.getString('userid') == null) {
      Get.offAll(() => SplashScreen());
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return GameClosedDialog('images/error.json', 'Try again!', 15);
          });
    }
  }

  getUserInfo(String? userid) async {
    if (mounted) {
      setState(() {
        userLoginCheck = 0;
        walletLoading = 0;
      });
    }
    String url = 'http://www.aksdute.com/tsgames/get_all_user_info.php';
    dpack.FormData newData = new dpack.FormData.fromMap({'userid': userid});
    await new dpack.Dio().post(url, data: newData,options: dpack.Options(followRedirects: false)).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          List data = jsonDecode(value.data);
          for (var i in data) {
            name = i['name'];
            mainuserid = i['userid'];
            db_deviceid = i['device_id'];
            added = int.parse(i['added'].toString());
            withdraw = int.parse(i['withdraw'].toString());
            ref_earn = double.parse(i['ref_earn'].toString());
            wingame = int.parse(i['wingame'].toString());
            totalgame = int.parse(i['totalgame'].toString());
            tentime = i['tentime'].toString();
            twotime = i['twotime'].toString();
            g_date = i['g_date'].toString();
            timing = i['timing'].toString();
            latest_version = i['version'].toString();
            v_msg = i['v_msg'].toString();
            working = i['working'].toString();
            w_msg = i['w_msg'].toString();
            bb_today= i['today'];
            bb_yesterday= i['yesterday'];
            bb_date = i['date'];
          }
          if (mounted) {
            setState(() {
              userLoginCheck = 1;
              walletLoading = 1;
            });
          }
          if (version_prefs != latest_version) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        // color: Colors.lightGreenAccent,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LottieAnimation(25, 'images/updateApp.json'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                v_msg!,
                                style: GoogleFonts.libreBaskerville(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 1.5 * SizeConfig.textMultiplier,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        exit(0);
                                      },
                                      child: Gtext(
                                        'Exit App',
                                        1.7,
                                        bold: true,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2 * SizeConfig.heightMultiplier,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _launchURL(
                                            'https://play.google.com/store/apps/details?id=com.tusharsonigames.tusharsonigames');
                                      },
                                      child: Gtext(
                                        'Update Now',
                                        1.7,
                                        bold: true,
                                      ),
                                    )
                                  ],
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
          if (db_deviceid != local_device_id) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return AnotherLoginDialog();
                });
          }
        } else {
          if (mounted) {
            setState(() {
              userLoginCheck = -1;
              walletLoading = -1;
            });
          }
        }
      }
    });
  }

  getOnlyWalletInfo(String? userid) async {
    if (mounted) {
      setState(() {
        walletLoading = 0;
      });
    }
    String url = 'http://www.aksdute.com/tsgames/get_only_wallet.php';
    dpack.FormData newData = new dpack.FormData.fromMap({'userid': userid});
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          List data = jsonDecode(value.data);
          for (var i in data) {
            added = int.parse(i['added'].toString());
            withdraw = int.parse(i['withdraw'].toString());
            ref_earn = double.parse(i['ref_earn'].toString());
          }
          if (mounted) {
            setState(() {
              walletLoading = 1;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              walletLoading = -1;
            });
          }
        }
      }
    });
  }

  googleSignout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userid').then((value) {
      if (value == true) {
        Get.off(() => IntroScreen());
      }
    });
  }

  @override
  void initState() {

    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    animation =
    ColorTween(begin: Colors.white, end: Colors.red).animate(animationController!)
      ..addListener(
            () {
          animationBloc!.blocSink.add(animation!.value);
        },
      );

    animationController!.forward();
    animation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController!.forward();
      }
    });

    _connectivity!.initialise();
    _connectivity!.myStream.listen((source) {
      if (mounted) {
        setState(() => _source = source);
      }

      if (_source.keys.toList()[0] == ConnectivityResult.none) {
        string = "Offline";
      } else {
        string = "Online";
        getCurrentUser();
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (event.data['type'].toString() == 'result') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ResultNotificationDialog();
            });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      if (event.data['type'].toString() == 'result') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ResultNotificationDialog();
            });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);

      if (string != null) {
        if (string != 'Offline' && string != null) {
          if (userLoginCheck == 1) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: Builder(
                builder: (context) {
                  return SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return getCurrentUser();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFC9D6FF),
                              Color(0xFFE2E2E2)

                            ],
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    child: Icon(
                                      Icons.menu,
                                      size: 7 * SizeConfig.imageSizeMultiplier,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Gtext(
                                    'Welcome ' + name! + ' !',
                                    2,
                                    color: Colors.black,
                                    bold: true,
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              ShowRefrenceID(mainuserid),
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Ltext(
                                    'My Wallet',
                                    1.8,
                                    color: Colors.black,
                                    bold: true,
                                  ),

                                  walletLoading == 1
                                      ? Card(
                                          borderOnForeground: true,
                                          elevation: 5,
                                          color: Colors.transparent,
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: new BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)
                                              ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF83a4d4),
                                                  Color(0xFF83a4d4)
                                                ],
                                              ),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Gtext('Total Balance', 1.3,color: Colors.white),
                                                    SizedBox(height: 5,),
                                                    Gtext('\u20b9'+(added!+withdraw!+ref_earn!).toString(), 2.7,color: Colors.black,bold: true,),

                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Container(
                                                  width: double.maxFinite,
                                                  child: Wrap(
                                                    alignment: WrapAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                        children: [
                                                          Ltext(
                                                            'Added\nMoney',
                                                            1.3,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Gtext(
                                                            '\u20b9'+
                                                                added.toString(),
                                                            2.5,
                                                            color: Colors.black,
                                                            bold: true,
                                                          ),
                                                          SizedBox(height: 2,),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (working !=
                                                                  'true') {
                                                                var result =
                                                                await Get.to(() =>
                                                                    AddMoney(
                                                                        added));
                                                                if (result
                                                                    .toString() ==
                                                                    'true') {
                                                                  getOnlyWalletInfo(
                                                                      mainuserid);
                                                                }
                                                              } else {
                                                                showDialog(
                                                                    barrierDismissible:
                                                                    false,
                                                                    context:
                                                                    context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return ServerMaintanenceDialog(
                                                                          w_msg!);
                                                                    });
                                                              }
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: ColorSystem
                                                                      .kprimary,
                                                                  borderRadius: BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                      5))),
                                                              padding:
                                                              EdgeInsets.all(
                                                                  7),
                                                              child: Gtext(
                                                                'Add Money',
                                                                1.4,
                                                                color: Colors
                                                                    .white,
                                                                bold: true,
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Ltext(
                                                            'Winning\nMoney',
                                                            1.3,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Gtext(
                                                            '\u20b9' +

                                                                withdraw
                                                                    .toString(),
                                                            2.5,
                                                            color: Colors.black,
                                                            bold: true,
                                                          ),
                                                          SizedBox(height: 2,),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (working !=
                                                                  'true') {
                                                                var result =
                                                                await Get.to(() =>
                                                                    MoneyWithdraw(
                                                                        withdraw));
                                                                if (result
                                                                    .toString() ==
                                                                    'true') {
                                                                  getOnlyWalletInfo(
                                                                      mainuserid);
                                                                }
                                                              } else {
                                                                showDialog(
                                                                    barrierDismissible:
                                                                    false,
                                                                    context:
                                                                    context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return ServerMaintanenceDialog(
                                                                          w_msg!);
                                                                    });
                                                              }
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: ColorSystem
                                                                      .kprimary,
                                                                  borderRadius: BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                      5))),
                                                              padding:
                                                              EdgeInsets.all(
                                                                  7),
                                                              child: Gtext(
                                                                'Withdraw',
                                                                1.4,
                                                                color: Colors
                                                                    .white,
                                                                bold: true,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),

                                                      Column(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Ltext(
                                                            'Reference\nEarning',
                                                            1.3,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Gtext(
                                                            '\u20b9' +
                                                                ref_earn
                                                                    .toString(),
                                                            2.5,
                                                            color: Colors.black,
                                                            bold: true,
                                                          ),
                                                          SizedBox(height: 2,),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (working !=
                                                                  'true') {
                                                                var result =
                                                                await Get.to(() =>
                                                                    RefrenceWithdraw(
                                                                        ref_earn));
                                                                if (result
                                                                    .toString() ==
                                                                    'true') {
                                                                  getOnlyWalletInfo(
                                                                      mainuserid);
                                                                }
                                                              } else {
                                                                showDialog(
                                                                    barrierDismissible:
                                                                    false,
                                                                    context:
                                                                    context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return ServerMaintanenceDialog(
                                                                          w_msg!);
                                                                    });
                                                              }
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: ColorSystem
                                                                      .kprimary,
                                                                  borderRadius: BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                      5))),
                                                              padding:
                                                              EdgeInsets.all(
                                                                  7),
                                                              child: Gtext(
                                                                'Withdraw',
                                                                1.3,
                                                                color: Colors
                                                                    .white,
                                                                bold: true,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),


                                              ],
                                            ),
                                          ),
                                        )
                                      : walletLoading == -1
                                          ? Center(
                                              child: Gtext(
                                                'Try again later ',
                                                2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : LottieAnimation(
                                              10, "images/loading.json"),
                                  SizedBox(
                                    height: 2 * SizeConfig.heightMultiplier,
                                  ),

                                  Card(
                                    borderOnForeground: true,
                                    elevation: 5,
                                    color: Colors.transparent,
                                    shadowColor: Colors.black,
                                    margin: EdgeInsets.all(5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Container(
                                      width: double.maxFinite,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1D976C),
                                            Color(0xFF1D976C)
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 1 * SizeConfig.heightMultiplier,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Gtext('Big Blast', 2.3,bold: true,color: Colors.white,),
                                              SizedBox(
                                                height: 1 * SizeConfig.heightMultiplier,
                                              ),
                                              Gtext('( 10:45 PM )', 1.8,bold: true,color: Colors.yellowAccent,),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 0.5 * SizeConfig.heightMultiplier,
                                          ),

                                          SizedBox(
                                            height: 0.5 * SizeConfig.heightMultiplier,
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Gtext('{'+bb_yesterday!+'}', 2.3,bold: true,color: Colors.white,),
                                              SizedBox(width: 4,),
                                              StreamBuilder(
                                                  stream: animationBloc!.blocStream,
                                                  initialData: Colors.tealAccent,
                                                  builder: (context, snapshot) {
                                                  return Container(
                                                    color: (snapshot.data) as Color,
                                                    child: Gtext(
                                                      'NEW',
                                                      1.3,
                                                      color: Colors.black
                                                    ),
                                                  );
                                                }
                                              ),
                                              SizedBox(width: 4,),
                                              Gtext('['+bb_today!+']', 2.3,color: Colors.tealAccent,bold: true,),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 1.5 * SizeConfig.heightMultiplier,
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              Get.to(() => BBChart());
                                            },
                                            child: Container(
                                              width: double.maxFinite,
                                              decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:Radius.circular(5),
                                                    bottomRight: Radius.circular(5)
                                                ),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.tealAccent,
                                                    Color(0xFF5FC3E4)
                                                  ],
                                                ),
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Gtext(
                                                    'Big Blast Chart',
                                                    2,
                                                    color: Colors.black,
                                                    bold: true,
                                                  ),
                                                  Gtext(
                                                    '\u2794',
                                                    2,
                                                    color: Colors.black,
                                                    bold: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2 * SizeConfig.heightMultiplier,
                                  ),
                                  Ltext(
                                    'Current Result',
                                    1.8,
                                    color: Colors.black,
                                    bold: true,
                                  ),

                                  CurrentResult(twotime, tentime,
                                      g_date, timing),
                                  SizedBox(
                                    height: 2 * SizeConfig.heightMultiplier,
                                  ),
                                  Ltext(
                                    'Join us',
                                    1.8,
                                    color: Colors.black,
                                    bold: true,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          _launchURL('https://www.facebook.com/TS-Games-109708218379372');
                                        },
                                          child: LottieAnimation(10, 'images/facebook.json')
                                      ),
                                      GestureDetector(
                                          onTap: (){
                                            _launchURL('https://t.me/tsgames');

                                          },
                                          child: LottieAnimation(10, 'images/telegram.json')
                                      ),
                                      GestureDetector(
                                          onTap: (){
                                            _launchURL('https://wa.me/+919671775251');
                                          },
                                          child: LottieAnimation(10, 'images/whatsapp.json')
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12 * SizeConfig.heightMultiplier,
                                  ),
                                 /* Card(
                                    borderOnForeground: true,
                                    elevation: 5,
                                    color: Colors.transparent,
                                    shadowColor: Colors.black,
                                    margin: EdgeInsets.all(5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => FullChart());
                                      },
                                      child: Container(
                                        width: double.maxFinite,
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFE55D87),
                                              Color(0xFF5FC3E4)
                                            ],
                                          ),
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Gtext(
                                              'Complete chart',
                                              2,
                                              color: Colors.white,
                                              bold: true,
                                            ),
                                            Gtext(
                                              '\u2794',
                                              2,
                                              color: Colors.white,
                                              bold: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  if (working != 'true') {
                    var result = await Get.to(() => PlayScreen());
                    if (result.toString() == 'true') {
                      getOnlyWalletInfo(mainuserid);
                    }
                  } else {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (ctx) {
                          return ServerMaintanenceDialog(w_msg!);
                        });
                  }
                },
                icon: LottieAnimation(15, "images/playgame.json"),
                backgroundColor: Color(0xFFC9D6FF),
                tooltip: 'Play Games',
                elevation: 5,
                splashColor: Colors.black,
                label: Gtext(
                  '',
                  1,
                  color: Colors.white,
                  bold: true,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              drawer: NavigationDrawerWidget(
                  name, mainuserid, context, latest_version),
            );
          } else if (userLoginCheck == -1) {
            return Scaffold(
              body: Container(
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
                child: Center(
                    child: Gtext(
                  'Not able to load data, Please check you internet connection or try again later',
                  2.2,
                  bold: true,
                  color: Colors.red,
                )),
              ),
            );
          } else {
            return Scaffold(
              body: Container(
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
                child:
                    Center(child: LottieAnimation(10, "images/loading.json")),
              ),
            );
          }
        } else {
          return Scaffold(
            body: noInternet(),
          );
        }
      } else {
        return Scaffold(
          body: Container(
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
            child: Center(child: LottieAnimation(10, "images/loading.json")),
          ),
        );
      }
    });
  }
}
