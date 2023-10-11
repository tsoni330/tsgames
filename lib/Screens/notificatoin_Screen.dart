import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/model/que_ans.dart';

import '../size_config.dart';
import 'package:dio/dio.dart' as dpack;


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<QueAns> mainData = [];
  List? rowdata;


  get_notification() async{
    mainData.clear();
    String url = 'http://www.aksdute.com/tsgames/get_notifications.php';

    await dpack.Dio().get(url).then((response) {
      if (response.statusCode == 200) {
        if (response.data != null) {
          rowdata = jsonDecode(response.data);
          for (var i in rowdata!) {
            mainData.add(QueAns(i['notification'], i['date']));
          }
          setState(() {

          });
        }
      }
    });
  }

  @override
  void initState() {
    get_notification();
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
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364)
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 2 * SizeConfig.heightMultiplier,
                    ),
                    Gtext(
                      "Notifications",
                      2.2,
                      color: Colors.white,
                      bold: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                mainData.length>=0
                    ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: mainData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        borderOnForeground: true,
                        elevation: 0,
                        color: Colors.transparent,
                        margin: EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 10),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              child: new ClipRect(
                                child: new BackdropFilter(
                                  filter: new ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: new Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: new BoxDecoration(
                                        color: Colors.blue
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight:
                                            Radius.circular(10))),
                                    child: Container(
                                      child: Gtext(
                                          mainData[index].que,
                                          1.8,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.maxFinite,
                              child: new ClipRect(
                                child: new BackdropFilter(
                                  filter: new ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: new Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: new BoxDecoration(
                                        color:
                                        Colors.brown.withOpacity(0.3),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight:
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Gtext(
                                            mainData[index].ans,
                                            1.4,
                                            color: Colors.white70
                                        ),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
