import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/model/que_ans.dart';
import '../size_config.dart';
import 'package:dio/dio.dart' as dpack;

class Rules extends StatefulWidget {
  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {

  List<QueAns> mainData = [];
  List? rowdata;


  getRules() async{
    mainData.clear();
    String url = 'http://www.aksdute.com/tsgames/get_rules.php';

    await dpack.Dio().get(url).then((response) {
      if (response.statusCode == 200) {
        if (response.data != null) {
          rowdata = jsonDecode(response.data);
          for (var i in rowdata!) {
            mainData.add(QueAns(i['eng'], i['hindi']));
          }
          setState(() {

          });
        }
      }
    });
  }

  @override
  void initState() {
    getRules();
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
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 2 * SizeConfig.heightMultiplier,
                    ),
                    Gtext(
                      "Rules & Regulatoins",
                      2.2,
                      color: Colors.black,
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
                          borderRadius: BorderRadius.circular(5),
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
                                            topLeft: Radius.circular(5),
                                            topRight:
                                            Radius.circular(5))),
                                    child: Container(
                                      child: Gtext(
                                          mainData[index].que,
                                          1.7,
                                          color: Colors.black
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
                                          bottomLeft: Radius.circular(5),
                                          bottomRight:
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Container(
                                        child: Gtext(
                                            mainData[index].ans,
                                            1.7,
                                            color: Colors.black
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
