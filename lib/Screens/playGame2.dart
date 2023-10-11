import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tusharsonigames/IconDart/play_game_icon_icons.dart';
import 'package:tusharsonigames/Screens/noInternet.dart';
import 'package:tusharsonigames/Screens/playGame3.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/iconWidget.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/bloc/MyConnectivity.dart';
import 'package:tusharsonigames/bloc/animation_bloc.dart';
import 'package:tusharsonigames/model/subgamelistModel.dart';
import 'package:tusharsonigames/size_config.dart';

import 'package:dio/dio.dart' as dpack;

class GameList extends StatefulWidget {
  String? type, length;

  GameList(this.type, this.length);

  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends State<GameList> with TickerProviderStateMixin {
  List? rowdata;
  List<subGameListModel> mainData = [];

  AnimationBloc bloc = AnimationBloc();
  AnimationBloc bloc2 = AnimationBloc();
  late Animation animation, animation2;
  late AnimationController controller;

  String? string;

  late Map _source;

  MyConnectivity? _connectivity = MyConnectivity.instance;

  getAllGameList() async {

    String url = 'http://www.aksdute.com/tsgames/get_all_game_list.php';

    dpack.FormData newData =
        new dpack.FormData.fromMap({'g_type': widget.type});

    try{
      await dpack.Dio().post(url, data: newData).then((response) {
        if (response.statusCode == 200) {
          if (response.data != null) {
            rowdata = jsonDecode(response.data);
            mainData.clear();
            for (var i in rowdata!) {
              mainData.add(subGameListModel(i['g_number'], i['g_timing'],
                  i['status'], i['result'], i['date']));
            }
            if(mounted){
              setState(() {});
            }
          }
        }
      });
    }on dpack.DioError catch (e) {
      print('The exception is '+e.toString());
    }

  }

  @override
  void initState() {

    _connectivity!.initialise();
    _connectivity!.myStream.listen((source) {

      if(mounted){
        setState(() => _source = source);
      }


      if(_source.keys.toList()[0] == ConnectivityResult.none){
        string = "Offline";
      }else{
        string = "Online";
        getAllGameList();
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

    animation2 =
        ColorTween(begin: Colors.white, end: Colors.green).animate(controller)
          ..addListener(
            () {
              bloc2.blocSink.add(animation2.value);
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        body: string!=null?string!='Offline'?SafeArea(
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
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
                      'All Games',
                      2.2,
                      color: Colors.black,
                      bold: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1 * SizeConfig.heightMultiplier,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gtext(
                      '* Notes:- The result will declare after 15 -30 min   of game timing / रिजल्ट, गेम की timing ख़तम होने के 15 से 30 मिनट के अंदर आ जायेगा ',
                      1.3,
                      color: Colors.black45,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1 * SizeConfig.heightMultiplier,
                ),
                mainData.length>0
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: mainData.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (mainData[index].status == 'Open') {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => PlayMainGame(widget.type,
                                            int.parse(widget.length!) ,mainData[index].g_number, mainData[index].g_timing ));
                                      },
                                      child: Card(
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Gtext(
                                                        'Game no. '+mainData[index]
                                                            .g_number.toString(),
                                                        1.5,
                                                        color: Colors.white,
                                                        bold: true,
                                                      ),
                                                    ),
                                                    Gtext(
                                                      mainData[index].date,
                                                      1.3,
                                                      color: Colors.white,
                                                      bold: true,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2 *
                                                      SizeConfig.heightMultiplier,
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Gtext(
                                                          'Result',
                                                          1.5,
                                                          color: Colors.white70,
                                                        ),
                                                        SizedBox(
                                                          height: 1 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        ),
                                                        Gtext(
                                                          mainData[index].result,
                                                          2.5,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 1 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        ),
                                                        Container(
                                                          child: StreamBuilder(
                                                              stream: bloc2
                                                                  .blocStream,
                                                              builder: (context,
                                                                  snapshot) {
                                                                if(snapshot.data!=null){
                                                                  Color c = snapshot.data as Color;
                                                                  return Gtext(
                                                                    'Game is running now...',
                                                                    1.5,
                                                                    color: c,
                                                                  );
                                                                }else{
                                                                  return Gtext(
                                                                    'Game is running now...',
                                                                    1.5,
                                                                    color: Colors.white,
                                                                  );
                                                                }
                                                              }),
                                                        ),
                                                        SizedBox(
                                                          height: 1 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Gtext(
                                                          'Play Now',
                                                          1.5,
                                                          color: Colors.white70,
                                                        ),
                                                        SizedBox(height: 1*SizeConfig.heightMultiplier,),
                                                        StreamBuilder(
                                                            stream:
                                                                bloc.blocStream,
                                                            builder: (context,
                                                                snapshot) {
                                                              if(snapshot.data!=null){
                                                                Color c = snapshot.data as Color;
                                                                return CustomIconWidget(
                                                                  PlayGameIcon
                                                                      .games,
                                                                  size: 4.5,
                                                                  color:
                                                                  c,
                                                                );
                                                              }else{
                                                                return CustomIconWidget(
                                                                  PlayGameIcon
                                                                      .games,
                                                                  size: 4.5,
                                                                  color: Colors.white,
                                                                );
                                                              }
                                                            }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 1 *
                                                      SizeConfig.heightMultiplier,
                                                ),
                                                Container(
                                                  width: double.maxFinite,
                                                  child: Gtext(
                                                    'Game Timing:- ' +
                                                        mainData[index]
                                                            .g_timing!,
                                                    1.5,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 3 * SizeConfig.heightMultiplier,
                                    )
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SizeConfig()
                                                .mysnack('Game Closed Now'));
                                      },
                                      child: Card(
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
                                                  Color(0xFFD66D75),
                                                  Color(0xFFE29587)
                                                ],
                                              ),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Gtext(
                                                        'Game no. '+mainData[index]
                                                            .g_number.toString(),
                                                        1.5,
                                                        color: Colors.white,
                                                        bold: true,
                                                      ),
                                                    ),
                                                    Gtext(
                                                      mainData[index].date,
                                                      1.3,
                                                      color: Colors.white,
                                                      bold: true,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2 *
                                                      SizeConfig.heightMultiplier,
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Gtext(
                                                          'Result',
                                                          1.5,
                                                          color: Colors.white70,
                                                        ),
                                                        SizedBox(
                                                          height: 1 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        ),
                                                        Gtext(
                                                          mainData[index].result,
                                                          2.5,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 1 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        ),
                                                        Container(
                                                          child: Gtext(
                                                            'Game Closed.....',
                                                            1.5,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 1 *
                                                      SizeConfig.heightMultiplier,
                                                ),
                                                Container(
                                                  width: double.maxFinite,
                                                  child: Gtext(
                                                    'Game Timing:- ' +
                                                        mainData[index]
                                                            .g_timing!,
                                                    1.5,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 3 * SizeConfig.heightMultiplier,
                                    )
                                  ],
                                );
                              }
                            }),
                      )
                    : Center(child: LottieAnimation(10,"images/loading.json"))
              ],
            ),
          ),
        ):noInternet():LottieAnimation(10,"images/loading.json"),
      );
    });
  }
}
