import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tusharsonigames/Screens/chart.dart';
import 'package:tusharsonigames/Widgets/onlyGlassbg.dart';
import '../size_config.dart';
import 'Gtext.dart';

class CurrentResult extends StatefulWidget {
  String? twotime, tentime, g_date, timing;

  CurrentResult(
      this.twotime, this.tentime, this.g_date, this.timing);

  @override
  _CurrentResultState createState() => _CurrentResultState();
}

class _CurrentResultState extends State<CurrentResult> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        borderOnForeground: true,
        elevation: 5,
        color: Colors.transparent,
        shadowColor: Colors.black,
        margin: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(5)
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3a7bd5),
                      Color(0xFF3a6073)
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gtext(
                                'Game Time',
                                1.2,
                                color: Colors.white70,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Gtext(
                                widget.timing,
                                1.5,
                                bold: true,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Gtext(
                                'Date',
                                1.2,
                                color: Colors.white70,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Gtext(
                                widget.g_date.toString(),
                                1.5,
                                bold: true,
                                color: Colors.white,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(

                      padding: const EdgeInsets.only(top: 5,left: 15,right: 15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Gtext(
                                'Game Name',
                                1.4,
                                color: Colors.white70,
                                bold: true,
                              ),
                              Gtext(
                                'Result',
                                1.4,
                                bold: true,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                          Divider(
                            height: 10,
                            thickness: 0.5,
                            color: Colors.white70,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Gtext(
                                '₹10 ka ₹20',
                                2,
                                color: Colors.white,

                              ),
                              Gtext(
                                widget.twotime.toString(),
                                2,
                                bold: true,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Gtext(
                                '₹10 ka ₹90',
                                2,
                                color: Colors.white,
                              ),
                              Gtext(
                                widget.tentime.toString(),
                                2,
                                bold: true,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => FullChart());
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
                              Color(0xFFE55D87),
                              Color(0xFF5FC3E4)
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(10),
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
                  ],
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
}
