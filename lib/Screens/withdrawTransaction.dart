import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shimmer/shimmer.dart';
import 'package:tusharsonigames/IconDart/wallet_icon_icons.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/glassBgWithColor.dart';
import 'package:tusharsonigames/Widgets/loadingWidget.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/model/withdraw_tran_model.dart';
import 'package:dio/dio.dart' as dpack;
import '../size_config.dart';

class WithdrawTransaction extends StatefulWidget {
  String? userid;

  WithdrawTransaction(this.userid);

  @override
  _WithdrawTransactionState createState() => _WithdrawTransactionState();
}

class _WithdrawTransactionState extends State<WithdrawTransaction> {
  List<TranWithdrawModel> maindata = [];
  List? rowdata;
  ScrollController _scrollController = new ScrollController();
  int pageno = 1;
  bool isLoading = false;
  int dataloading = 0;

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

  getTransaction() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      String url = 'http://www.aksdute.com/tsgames/get_withdraw_tran.php';

      dpack.FormData newData = new dpack.FormData.fromMap(
          {'userid': widget.userid, 'pageno': pageno});

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
                maindata.add(TranWithdrawModel(i['amount'], i['status'],
                    i['bank_tran_id'], i['date'], i['acc_name'], i['acc_no']));
              }
              setState(() {
                isLoading = false;
                dataloading = 1;
                pageno = pageno + 1;
              });
            }
          }
        }
      });
    }
  }

  @override
  void initState() {
    getTransaction();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (isLoading == false) getTransaction();
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
                      width: 2 * SizeConfig.heightMultiplier,
                    ),
                    Expanded(
                      child: Gtext(
                        'Withdraw Transaction',
                        2,
                        color: Colors.black,
                        bold: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2 * SizeConfig.heightMultiplier,
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
                                if (maindata[index].status == 'pending') {
                                  return Card(
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
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Shimmer.fromColors(
                                                  baseColor: Colors.white,
                                                  highlightColor:
                                                  Colors.cyanAccent,
                                                  child: Icon(
                                                    Icons.watch_later,
                                                    size: 2.5 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  )),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                      maindata[index].date!,
                                                  1.3,
                                                  color: Colors.white,
                                                  bold: true,
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 1 *
                                                SizeConfig
                                                    .imageSizeMultiplier,
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                  maindata[index]
                                                          .status!
                                                          .capitalizeFirst!,
                                                  1.5,
                                                  color: Colors.black,
                                                  bold: true,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                  '\u20b9' +
                                                      maindata[index].amount!,
                                                  1.5,
                                                  color: Colors.black,
                                                  bold: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          


                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: Gtext(
                                              'Acc Name:-  ' +
                                                  maindata[index]
                                                      .acc_name
                                                      .toString(),
                                              1.3,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: Gtext(
                                              'Acc No:-  ' +
                                                  maindata[index]
                                                      .acc_no
                                                      .toString(),
                                              1.3,
                                              color: Colors.white,
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                  );
                                }
                                else if (maindata[index].status == 'winning') {
                                  return Card(
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
                                      width: double.maxFinite,
                                      decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)
                                          ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF6190E8),
                                            Color(0xFFA7BFE8)
                                          ],
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Shimmer.fromColors(
                                                  baseColor: Colors.white,
                                                  highlightColor:
                                                  Colors.cyanAccent,
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .attach_money_outlined,
                                                        size: 2.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward,
                                                        size: 2.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                      ),
                                                      Icon(
                                                        WalletIcon.wallet,
                                                        size: 2.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                      )
                                                    ],
                                                  )),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                  maindata[index].date!,
                                                  1.3,
                                                  color: Colors.white,
                                                  bold: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(

                                                  maindata[index]
                                                      .status!
                                                      .capitalizeFirst! +
                                                      ' / आपने जीते है ',
                                                  1.5,
                                                  color: Colors.black,
                                                  bold: true,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                  '\u20b9' +
                                                      maindata[index].amount!,
                                                  1.5,
                                                  color: Colors.black,
                                                  bold: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                else if(maindata[index].status=='done'){
                                  return Card(
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
                                            Color(0xFF50C9C3),
                                            Color(0xFF96DEDA)
                                          ],
                                        ),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                      ),
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
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Shimmer.fromColors(
                                                  baseColor: Colors.white,
                                                  highlightColor:
                                                  Colors.cyanAccent,
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        WalletIcon.wallet,
                                                        size: 2.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward,
                                                        size: 2.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                      ),
                                                      Icon(
                                                        Icons.account_balance,
                                                        size: 2.5 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                      )
                                                    ],
                                                  )),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                      maindata[index].date!,
                                                  1.3,
                                                  color: Colors.white,
                                                  bold: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 1 *
                                                SizeConfig
                                                    .imageSizeMultiplier,
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(

                                                      maindata[index]
                                                          .status!
                                                          .capitalizeFirst! +
                                                      ' / आपके बैंक खाते में जमा',
                                                  1.5,
                                                  color: Colors.black,
                                                  bold:true
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                  '\u20b9' +
                                                      maindata[index].amount!,
                                                  1.5,
                                                  color: Colors.black,
                                                  bold: true,
                                                ),
                                              ),
                                            ],
                                          ),


                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: Gtext(
                                              'Acc Name:-  ' +
                                                  maindata[index]
                                                      .acc_name
                                                      .toString(),
                                              1.3,
                                              color: Colors.white,

                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: Gtext(
                                              'Acc No:-  ' +
                                                  maindata[index]
                                                      .acc_no
                                                      .toString(),
                                              1.3,
                                              color: Colors.white,
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.all(5),
                                            child: Gtext(
                                              'Transfer Id:-  ' +
                                                  maindata[index]
                                                      .bank_tran_id!,
                                              1.3,
                                              color: Colors.white,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  );
                                } else{
                                  return Card(
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
                                      width: double.maxFinite,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF649173),
                                            Color(0xFFDBD5A4)
                                          ],
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Shimmer.fromColors(
                                                  baseColor: Colors.white,
                                                  highlightColor:
                                                  Colors.cyanAccent,
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      Icon(WalletIcon.wallet,size: 2.5*SizeConfig.heightMultiplier,),
                                                      Icon(Icons.arrow_forward,size: 2.5*SizeConfig.heightMultiplier,),
                                                      Icon(Icons.shopping_cart,size: 2.5*SizeConfig.heightMultiplier,)
                                                    ],
                                                  )),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                  maindata[index].date!,
                                                  1.3,
                                                  color: Colors.white,
                                                  bold: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(

                                                  'Debit' +
                                                      ' / नंबर ख़रीदा',
                                                  1.5,
                                                  color: Colors.black,
                                                  bold: true,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Gtext(
                                                  '\u20b9' +
                                                      maindata[index].amount!,
                                                  1.5,
                                                  color: Colors.black,
                                                  bold: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        : Center(
                            child: Gtext(
                              'No Transaction found',
                              2.5,
                              color: Colors.white70,
                            ),
                          )
                    : LoadingWidget('Data is loading'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
