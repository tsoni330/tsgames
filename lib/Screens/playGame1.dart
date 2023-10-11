import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tusharsonigames/IconDart/play_game_icon_icons.dart';
import 'package:tusharsonigames/Screens/noInternet.dart';
import 'package:tusharsonigames/Screens/playGame2.dart';
import 'package:tusharsonigames/Screens/playGame3.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/iconWidget.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/bloc/MyConnectivity.dart';
import 'package:tusharsonigames/bloc/animation_bloc.dart';
import 'package:tusharsonigames/model/gamelistModel.dart';
import 'package:tusharsonigames/size_config.dart';
import 'package:dio/dio.dart' as dpack;

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  List? rowdata;
  List<MainGameListModel> mainData = [];

  AnimationBloc bloc = AnimationBloc();
  Color? color;
  late Animation animation;
  late AnimationController controller;

  String? string;

  late Map _source;

  MyConnectivity? _connectivity = MyConnectivity.instance;

  getGameData() async {
    String url = 'http://www.aksdute.com/tsgames/get_game_list.php';

    try {
      await dpack.Dio().get(url).then((response) {
        if (response.statusCode == 200) {
          if (response.data != null) {
            rowdata = jsonDecode(response.data);
            mainData.clear();
            for (var i in rowdata!) {
              mainData.add(MainGameListModel(i['g_name'], i['g_type'],
                  i['example'], i['poss'], i['length'], i['status']));
            }
            if (mounted) {
              setState(() {});
            }
          }
        }
      });
    } on dpack.DioError catch (e) {
      print('The exception is ' + e.toString());
    }
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
        getGameData();
      }
    });

    controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    animation =
        ColorTween(begin: Colors.white, end: Colors.white38).animate(controller)
          ..addListener(
            () {
              bloc.blocSink.add(animation.value);
            },
          );

    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    // _connectivity.disposeStream();

    super.dispose();
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
        child: Scaffold(
          body: string != null
              ? string != 'Offline'
                  ? SafeArea(
                      child: RefreshIndicator(
                        onRefresh: () {
                          return getGameData();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFC9D6FF), Color(0xFFE2E2E2)],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    LottieAnimation(10, "images/playgame.json"),
                                    Gtext(
                                      "It's Best Time to Play",
                                      1.3,
                                      color: Colors.black,
                                      bold: true,
                                    ),
                                    SizedBox(
                                      height: 0.5 * SizeConfig.heightMultiplier,
                                    ),
                                    Text(
                                      "Don't rush, Play slowly and safely / जल्दबाजी न करे , आराम से और ध्यान से खेले",
                                      style: GoogleFonts.libreBaskerville(
                                          fontSize:
                                              1.2 * SizeConfig.textMultiplier,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.3),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 2 * SizeConfig.heightMultiplier,
                                    ),
                                  ],
                                ),
                              ),
                              mainData.length > 0
                                  ? Expanded(
                                      child: ListView.builder(
                                          itemCount: mainData.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (mainData[index].poss ==
                                                        '1') {

                                                      if(mainData[index].status=='Open'){
                                                        Get.to(() => PlayMainGame(mainData[index].gtype, 100, '1', '10:45 PM'));
                                                      }else{
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(SizeConfig()
                                                            .mysnack('Game is Closed'));
                                                      }



                                                    } else {
                                                      Get.to(() => GameList(
                                                          mainData[index].gtype,
                                                          mainData[index]
                                                              .length
                                                              .toString()));
                                                    }
                                                  },
                                                  child: mainData[index].poss ==
                                                          '1'
                                                      ? Card(
                                                          borderOnForeground:
                                                              true,
                                                          elevation: 5,
                                                          color: Colors
                                                              .transparent,
                                                          shadowColor:
                                                              Colors.black,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                new BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFF108dc7),
                                                                  Color(
                                                                      0xFFaa4b6b)
                                                                ],
                                                              ),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Column(
                                                              children: [
                                                                Shimmer
                                                                    .fromColors(
                                                                  baseColor: Colors
                                                                      .cyanAccent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .white,
                                                                  child: Gtext(
                                                                    mainData[
                                                                            index]
                                                                        .gname,
                                                                    3,
                                                                    color: Colors
                                                                        .black,
                                                                    bold: true,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Gtext(
                                                                    mainData[
                                                                            index]
                                                                        .example,
                                                                    1.3,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: double
                                                                      .maxFinite,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Gtext(
                                                                            '10:45 PM',
                                                                            2.5,
                                                                            color:
                                                                                Colors.white,
                                                                            bold:
                                                                                true,
                                                                          ),
                                                                          StreamBuilder(
                                                                              stream: bloc.blocStream,
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.data != null) {
                                                                                  Color c = snapshot.data as Color;
                                                                                  return CustomIconWidget(
                                                                                    PlayGameIcon.games,
                                                                                    size: 4.5,
                                                                                    color: c,
                                                                                  );
                                                                                } else {
                                                                                  return CustomIconWidget(
                                                                                    PlayGameIcon.games,
                                                                                    size: 4.5,
                                                                                    color: Colors.white,
                                                                                  );
                                                                                }
                                                                              }),
                                                                        ],
                                                                      ),
                                                                      mainData[index].status ==
                                                                              'Open'
                                                                          ? Container(
                                                                              child: StreamBuilder(
                                                                                  stream: bloc.blocStream,
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.data != null) {
                                                                                      Color c = snapshot.data as Color;
                                                                                      return Gtext(
                                                                                        'Game is running now...',
                                                                                        1.5,
                                                                                        color: c,
                                                                                      );
                                                                                    } else {
                                                                                      return Gtext(
                                                                                        'Game is running now...',
                                                                                        1.5,
                                                                                        color: Colors.white,
                                                                                      );
                                                                                    }
                                                                                  }),
                                                                            )
                                                                          : Gtext(
                                                                              'Game is closed',
                                                                             2,
                                                                              color: Colors.red,
                                                                              bold: true,
                                                                            ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ))
                                                      : mainData[index].poss ==
                                                      '10'? Column(
                                                        children: [
                                                          SizedBox(height: 1*SizeConfig.heightMultiplier,),
                                                          Gtext('Play every Hour / हर घंटे खेलें और जीतें', 2,color: Colors.black,bold: true,),
                                                          SizedBox(height: 1*SizeConfig.heightMultiplier,),
                                                          Card(
                                                              borderOnForeground:
                                                                  true,
                                                              elevation: 5,
                                                              color: Colors
                                                                  .transparent,
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Container(
                                                                width:
                                                                    double.infinity,
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(Radius
                                                                              .circular(
                                                                                  5)),
                                                                      gradient:
                                                                      LinearGradient(
                                                                        colors: [
                                                                          Color(
                                                                              0xFFE8CBC0),
                                                                          Color(
                                                                              0xFF636FA4)
                                                                        ],
                                                                      ),
                                                                ),
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        10),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                                  10),
                                                                      child: Gtext(
                                                                        mainData[
                                                                                index]
                                                                            .example,
                                                                        1.3,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: double
                                                                          .maxFinite,
                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Gtext(
                                                                                mainData[index].gname,
                                                                                2,
                                                                                color:
                                                                                    Colors.black,
                                                                              ),
                                                                              StreamBuilder(
                                                                                  stream: bloc.blocStream,
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.data != null) {
                                                                                      Color c = snapshot.data as Color;
                                                                                      return CustomIconWidget(
                                                                                        PlayGameIcon.games,
                                                                                        size: 4.5,
                                                                                        color: c,
                                                                                      );
                                                                                    } else {
                                                                                      return CustomIconWidget(
                                                                                        PlayGameIcon.games,
                                                                                        size: 4.5,
                                                                                        color: Colors.white,
                                                                                      );
                                                                                    }
                                                                                  }),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 0.7 *
                                                                                SizeConfig.heightMultiplier,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )),
                                                        ],
                                                      ):Card(
                                                      borderOnForeground:
                                                      true,
                                                      elevation: 5,
                                                      color: Colors
                                                          .transparent,
                                                      shadowColor:
                                                      Colors.black,
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            5),
                                                      ),
                                                      child: Container(
                                                        width:
                                                        double.infinity,
                                                        decoration:
                                                        new BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .all(Radius
                                                              .circular(
                                                              5)),
                                                          gradient:
                                                          LinearGradient(
                                                            colors: [
                                                              Color(
                                                                  0xFFE8CBC0),
                                                              Color(
                                                                  0xFF636FA4)
                                                            ],
                                                          ),
                                                        ),
                                                        padding:
                                                        EdgeInsets.all(
                                                            10),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding:
                                                              EdgeInsets
                                                                  .all(
                                                                  10),
                                                              child: Gtext(
                                                                mainData[
                                                                index]
                                                                    .example,
                                                                1.3,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .maxFinite,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Gtext(
                                                                        mainData[index].gname,
                                                                        2,
                                                                        color:
                                                                        Colors.black,
                                                                      ),
                                                                      StreamBuilder(
                                                                          stream: bloc.blocStream,
                                                                          builder: (context, snapshot) {
                                                                            if (snapshot.data != null) {
                                                                              Color c = snapshot.data as Color;
                                                                              return CustomIconWidget(
                                                                                PlayGameIcon.games,
                                                                                size: 4.5,
                                                                                color: c,
                                                                              );
                                                                            } else {
                                                                              return CustomIconWidget(
                                                                                PlayGameIcon.games,
                                                                                size: 4.5,
                                                                                color: Colors.white,
                                                                              );
                                                                            }
                                                                          }),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 0.7 *
                                                                        SizeConfig.heightMultiplier,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 2 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                )
                                              ],
                                            );
                                          }),
                                    )
                                  : Center(
                                      child: LottieAnimation(
                                          10, "images/loading.json"))
                            ],
                          ),
                        ),
                      ),
                    )
                  : noInternet()
              : LottieAnimation(10, "images/loading.json"),
        ),
      );
    });
  }
}
