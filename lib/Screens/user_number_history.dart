import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/glassBgWithColor.dart';
import 'package:tusharsonigames/Widgets/loadingWidget.dart';
import 'package:tusharsonigames/model/user_number_history_model.dart';

import 'package:tusharsonigames/size_config.dart';
import 'package:dio/dio.dart' as dpack;

class UserNumberHistory extends StatefulWidget {
  @override
  _UserNumberHistoryState createState() => _UserNumberHistoryState();
}

class _UserNumberHistoryState extends State<UserNumberHistory> {
  int userLoginCheck = 0;
  String? userid;
  List<UserNumberHistoryModel> maindata = [];
  List? rowdata;
  ScrollController _scrollController = new ScrollController();
  int pageno = 1;
  bool isLoading = false;
  int dataloading = 0;

  getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if (userid != null) {
      setState(() {
        getTransaction(userid);
      });
    } else {
      setState(() {
        userLoginCheck = -1;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  getTransaction(String? uid) async {
    userLoginCheck = 1;
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      String url = 'http://www.aksdute.com/tsgames/get_user_number_history.php';

      dpack.FormData newData =
          new dpack.FormData.fromMap({'userid': uid, 'pageno': pageno});

      await dpack.Dio().post(url, data: newData).then((response) {
        if (response.statusCode == 200) {
          rowdata = jsonDecode(response.data);
          if (rowdata == null) {
            setState(() {
              isLoading = false;
              dataloading = 1;
            });
          } else {
            if (rowdata!.length <= 0) {
              setState(() {
                isLoading = true;
                dataloading = 1;
              });
            } else {
              for (var i in rowdata!) {
                if (int.parse(i['number']) < 10) {
                  maindata.add(UserNumberHistoryModel(i['gtype'],
                      '0' + i['number'], i['amount'], i['gtime'], i['date']));
                } else {
                  maindata.add(UserNumberHistoryModel(i['gtype'], i['number'],
                      i['amount'], i['gtime'], i['date']));
                }
              }
              setState(() {
                isLoading = false;
                pageno = pageno + 1;
                dataloading = 1;
              });
            }
          }
        }
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (isLoading == false && userLoginCheck == 1) getTransaction(userid);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                      width: 1.5 * SizeConfig.heightMultiplier,
                    ),
                    Expanded(
                      child: Gtext(
                        "Number's History",
                        2,
                        color: Colors.black,
                        bold: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                dataloading == 1
                    ? maindata.length > 0
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: maindata.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == maindata.length) {
                                  return _buildProgressIndicator();
                                }
                                if (maindata[index].gtype == 'hundtime') {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: GlassBGWtihColor(
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Gtext(
                                                      maindata[index].date,
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Gtext(
                                                      maindata[index].gtime,
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Gtext(
                                                      'Big Blast',
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Gtext(
                                                      '\u20b9'+maindata[index].amount.toString(),
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Gtext(
                                                      'Your Number:-  ',
                                                      1.3,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Gtext(
                                                      maindata[index].number,
                                                      2,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        Colors.cyanAccent),
                                  );
                                }
                                else if (maindata[index].gtype == 'tentime') {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: GlassBGWtihColor(
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Gtext(
                                                      maindata[index].date,
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Gtext(
                                                      maindata[index].gtime,
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Gtext(
                                                      '₹10 ka ₹90',
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Gtext(
                                                      '\u20b9'+maindata[index].amount.toString(),
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Gtext(
                                                      'Your Number:-  ',
                                                      1.3,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Gtext(
                                                      maindata[index].number,
                                                      2,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        Colors.greenAccent),
                                  );
                                } else {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: GlassBGWtihColor(
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Gtext(
                                                      maindata[index].date,
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Gtext(
                                                      maindata[index].gtime,
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Gtext(
                                                      '₹10 ka ₹20',
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Gtext(
                                                      '\u20b9'+maindata[index].amount.toString(),
                                                      1.8,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Gtext(
                                                      'Your Number:-  ',
                                                      1.3,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Gtext(
                                                      maindata[index].number,
                                                      2,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        Colors.blueAccent),
                                  );
                                }
                              },
                            ),
                          )
                        : Center(
                            child: Gtext(
                              'No Transaction found',
                              2,
                              color: Colors.black45,
                            ),
                          )
                    : LoadingWidget('Getting you data'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
