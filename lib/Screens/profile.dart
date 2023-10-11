import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/Widgets/onlyGlassbg.dart';
import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/size_config.dart';
import 'package:dio/dio.dart' as dpack;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int userLoginCheck = 0;
  String? name, mainuserid, error;
  late int added, withdraw, wingame, totalgame;
  late double  ref_earn;

  TextEditingController? namecontroller;

  getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');
    if (userid != null) {
      getUserInfo(userid);
    } else {
      setState(() {
        userLoginCheck = -1;
      });
    }
  }

  getUserInfo(String userid) async {
    String url = 'http://www.aksdute.com/tsgames/get_all_user_info.php';
    dpack.FormData newData = new dpack.FormData.fromMap({'userid': userid});
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          List data = jsonDecode(value.data);
          for (var i in data) {
            namecontroller!.text = i['name'];
            mainuserid = i['userid'];
            added = int.parse(i['added'].toString());
            withdraw = int.parse(i['withdraw'].toString());
            ref_earn = double.parse(i['ref_earn'].toString());
            wingame = int.parse(i['wingame'].toString());
            totalgame = int.parse(i['totalgame'].toString());
          }
          setState(() {
            userLoginCheck = 1;
          });
        } else {
          setState(() {
            userLoginCheck = -1;
          });
        }
      }
    });
  }

  saveName(String? userid, String name) async {
    setState(() {
      error=null;
    });
    String url = 'http://aksdute.com/tsgames/edit_name.php';
    dpack.FormData newData =
        new dpack.FormData.fromMap({'userid': userid, 'name': name});
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {

        if (jsonDecode(value.data).toString() == 'true') {
          setState(() {
            error = 'Your Name is save';
          });
        } else {
          setState(() {
            error = 'Some Wrong! Check You Internet Connection';
          });
        }
      }
    });
  }

  List<Color> colorList = [
    Colors.red,
    Colors.green,
  ];

  ChartType _chartType = ChartType.ring;
  double _ringStrokeWidth = 40;
  double _chartLegendSpacing = 40;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  LegendPosition _legendPosition = LegendPosition.right;

  @override
  void initState() {
    getCurrentUser();
    namecontroller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        body: SafeArea(
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
            child: userLoginCheck == 1
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 8 * SizeConfig.imageSizeMultiplier,
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFf2709c),
                                    Color(0xFFff9472)
                                  ],
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 6 * SizeConfig.imageSizeMultiplier,
                                    backgroundColor: ColorSystem.klight,

                                    // ignore: unnecessary_null_comparison
                                    child: namecontroller!.text!=null
                                        ? Gtext(
                                            namecontroller!.text[0],
                                            3,
                                            color: Colors.white,
                                          )
                                        : SizedBox(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    decoration: new InputDecoration(
                                      labelText: "Profile Name *",
                                      fillColor: Colors.white,
                                      labelStyle: TextStyle(color: Colors.white),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    keyboardType: TextInputType.text,
                                    controller: namecontroller,
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Gtext(
                                    mainuserid,
                                    1.8,
                                    color: Colors.white,
                                    bold: true,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Gtext(
                                              'Added\nMoney',
                                              1.5,
                                              color: Colors.white70,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Gtext(
                                              '\u20b9 ' + added.toString(),
                                              2,
                                              color: Colors.white,
                                              bold: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Gtext(
                                              'Winning\nMoney',
                                              1.5,
                                              color: Colors.white70,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Gtext(
                                              '\u20b9 ' + withdraw.toString(),
                                              2,
                                              color: Colors.white,
                                              bold: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Gtext(
                                              'Refrence\nEarn',
                                              1.5,
                                              color: Colors.white70,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Gtext(
                                              '\u20b9 ' + ref_earn.toString(),
                                              2,
                                              color: Colors.white,
                                              bold: true,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  PieChart(
                                    dataMap: <String, double>{
                                      "Total Games": totalgame.toDouble(),
                                      "Winning Game": wingame.toDouble()
                                    },
                                    animationDuration:
                                        Duration(milliseconds: 800),
                                    chartLegendSpacing: _chartLegendSpacing,
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 3.2 >
                                                300
                                            ? 300
                                            : MediaQuery.of(context).size.width /
                                                3.2,
                                    colorList: colorList,
                                    initialAngleInDegree: 0,
                                    chartType: _chartType,
                                    legendOptions: LegendOptions(
                                      showLegendsInRow: _showLegendsInRow,
                                      legendPosition: _legendPosition,
                                      showLegends: _showLegends,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValueBackground:
                                          _showChartValueBackground,
                                      showChartValues: _showChartValues,
                                      showChartValuesInPercentage:
                                          _showChartValuesInPercentage,
                                      showChartValuesOutside:
                                          _showChartValuesOutside,
                                    ),
                                    ringStrokeWidth: _ringStrokeWidth,
                                    emptyColor: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(
                          height: 10,
                        ),
                        error != null
                            ? Center(
                                child: Gtext(
                                  error,
                                  2,
                                  color: Colors.red,
                                ),
                              )
                            : SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                        Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              if (namecontroller!.text.length != 0) {
                                saveName(mainuserid, namecontroller!.text);
                              } else {
                                setState(() {
                                  error = 'Please enter your Name';
                                });
                              }
                            },
                            child: Gtext(
                              "Save Name",
                              2,
                              color: Colors.white,
                              bold: true,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFf2709c)),
                          ),
                        ),
                      ],
                    ),
                  )
                : userLoginCheck == -1
                    ? Center(
                        child: Gtext(
                          'Check Internet Connection',
                          2,
                          color: Colors.white,
                        ),
                      )
                    : Center(child: LottieAnimation(5, "images/loading.json")),
          ),
        ),
      );
    });
  }
}
