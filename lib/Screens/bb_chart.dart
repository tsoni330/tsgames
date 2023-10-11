import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart' as dpack;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/model/bb_chart_model.dart';
import 'package:tusharsonigames/model/chartModel.dart';
import 'package:tusharsonigames/size_config.dart';

class BBChart extends StatefulWidget {
  @override
  _BBChartState createState() => _BBChartState();
}

class _BBChartState extends State<BBChart> {
  List<BB_Chart> maindata = [];
  List? rowdata;
  ScrollController _scrollController = new ScrollController();
  int pageno = 1;
  bool isLoading = false;
  bool removeit = false;
  List<TableRow> dr = [];

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

  @override
  void initState() {
    dr.add(TableRow(
        children: [
          TableCell(child: Padding(
              padding: EdgeInsets.all(5),
              child:Gtext('Number',2.5,bold: true,color: Colors.white,)
          )
          ),
          TableCell(child: Padding(
              padding: EdgeInsets.all(5),
              child:Gtext('Date',2.5,bold: true,color: Colors.white,)
          )
          ),
        ]
    ));
    getChartData();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (isLoading == false && removeit == false) getChartData();
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  getChartData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      String url = 'http://www.aksdute.com/tsgames/get_bb_chart.php';

      dpack.FormData newData =
          new dpack.FormData.fromMap({'pageno': pageno}); //pageno

      await dpack.Dio().post(url, data: newData).then((response) {
        if (response.statusCode == 200) {
          rowdata = jsonDecode(response.data);
          if (rowdata == null) {
            setState(() {
              isLoading = false;
            });
          } else {
            if (rowdata!.length <= 0) {
              setState(() {
                removeit = true;
              });
            } else {
              for (var i in rowdata!) {
                dr.add(TableRow(
                  children: [
                    TableCell(child: Padding(
                        padding: EdgeInsets.all(5),
                        child:Gtext(i['number'],2,bold: true,color: Colors.yellow,)
                    )
                    ),
                    TableCell(child: Padding(
                        padding: EdgeInsets.all(5),
                        child:Gtext(i['date'],2,bold: true,color: Colors.yellow,)
                    )
                    ),
                  ]
                ));

                //maindata.add(BB_Chart(i['number'], i['date']));
              }
              setState(() {
                isLoading = false;
              });
              pageno = pageno + 1;
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(constraints);
        return SafeArea(
          child: Scaffold(
            body: Container(
              padding: EdgeInsets.all(10),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFaa4b6b),Color(0xFF6b6b83), Color(0xFF3b8d99)],
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
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 2 * SizeConfig.heightMultiplier,
                      ),
                      Gtext(
                        'Complete Chart',
                        2.2,
                        color: Colors.white,
                        bold: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: dr.length >= 2
                          ? Table(
                         textDirection: TextDirection.rtl,
                         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                         border:TableBorder.all(width: 1.0,color: Colors.white70),


                      children: dr,
                      )
                          : Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
