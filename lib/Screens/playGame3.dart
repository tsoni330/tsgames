import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/noInternet.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/addedWallet.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/Widgets/onlyGlassbg.dart';
import 'package:tusharsonigames/Widgets/questionDesign.dart';
import 'package:tusharsonigames/bloc/MyConnectivity.dart';
import 'package:tusharsonigames/dialogs/another_login_dialog.dart';
import 'package:tusharsonigames/dialogs/game_closed_dialog.dart';
import 'package:tusharsonigames/dialogs/loading_dialog.dart';
import 'package:tusharsonigames/model/selectednumberModel.dart';
import 'package:tusharsonigames/size_config.dart';
import 'package:dio/dio.dart' as dpack;

import '../appColor.dart';

class PlayMainGame extends StatefulWidget {
  String? type, g_number, g_timing;
  int number_list;

  PlayMainGame(this.type, this.number_list, this.g_number, this.g_timing);

  @override
  _PlayMainGameState createState() => _PlayMainGameState();
}

class _PlayMainGameState extends State<PlayMainGame> {
  String? question, userid;

  List<String?> values = [];
  int userlogincheck = 0;
  List<String> numbersList = [];

  List<SelectedNumberModel> selectedNumberList = [];
  bool selecnumberloading = true;
  int? added, withdraw;
  double? ref_earn;

  String? string, local_device_id;

  late Map _source;

  MyConnectivity? _connectivity = MyConnectivity.instance;

  List<int> points = [
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    200,
    300,
    400,
    500,
    1000
  ];

  getSelectedNumberList() async {
    selectedNumberList.clear();
    String url = 'http://aksdute.com/tsgames/get_selected_number.php';
    dpack.FormData newData = new dpack.FormData.fromMap(
        {'userid': userid, 'g_type': widget.type, 'g_number': widget.g_number});

    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          List data = jsonDecode(value.data);
          selectedNumberList.clear();
          for (var i in data) {
            if (int.parse(i['number']) < 10) {
              selectedNumberList.add(SelectedNumberModel(
                  '0' + i['number'].toString(), i['amount'].toString()));
            } else {
              selectedNumberList.add(SelectedNumberModel(
                  i['number'].toString(), i['amount'].toString()));
            }
          }
          if (mounted) {
            setState(() {
              selecnumberloading = false;
            });
          }
        }
      }
    });
  }

  generateNumnerList(int length) async {
    numbersList.clear();
    for (int i = 0; i < length; i++) {
      if (i < 10) {
        numbersList.add('0' + i.toString());
      } else {
        numbersList.add(i.toString());
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if (userid != null) {
      local_device_id = prefs.getString('device_id');
      getWalletDetails(userid);
      getSelectedNumberList();
    } else {
      setState(() {
        userlogincheck = -1;
      });
    }
  }

  getWalletDetails(String? userid) async {
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
          //setState(() {});
        }
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  getTodayQuestion() async {
    String url = 'http://www.aksdute.com/tsgames/get_today_question.php';
    dpack.FormData newData = new dpack.FormData.fromMap({'type': widget.type});
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          List data = jsonDecode(value.data);
          for (var i in data) {
            question = i['que'];
            values.add(i['val1']);
            values.add(i['val2']);
            values.add(i['val3']);
            values.add(i['val4']);
            values.add(i['val5']);
            values.add(i['val6']);
            values.add(i['val7']);
            values.add(i['val8']);
            values.add(i['val9']);
          }
          //setState(() {});
        }
        /*else {
          setState(() {});
        }*/
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  addUserNumber(int number, int amount, String wallet_type) async {
    Navigator.pop(context);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return LoadingDialog(
              'images/loading.json',
              'Please Wait! May take some time / इंतज़ार करे ! थोड़ा टाइम लग सकता है ',
              15);
        });

    String url = 'http://www.aksdute.com/tsgames/add_number.php';
    dpack.FormData newData = new dpack.FormData.fromMap({
      'userid': userid,
      'g_type': widget.type,
      'g_number': widget.g_number,
      'number': number,
      'g_time': widget.g_timing,
      'amount': amount,
      'device_id': local_device_id,
      'wallet_type':wallet_type
    });

    await dpack.Dio().post(url, data: newData).then((response) {
      if (response.statusCode == 200) {
        if (jsonDecode(response.data).toString() == 'true') {
          switch(wallet_type){
            case 'added':
              added = added! - amount;
              break;

            case 'withdraw':
              withdraw=withdraw!-amount;
              break;

            case 'ref_earn':
              ref_earn = ref_earn!-amount;
              break;


            default:
              print('error');
              break;

          }
          if (number < 10) {
            selectedNumberList.add(SelectedNumberModel(
                '0' + number.toString(), amount.toString()));
          } else {
            selectedNumberList
                .add(SelectedNumberModel(number.toString(), amount.toString()));
          }
          Navigator.pop(context);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return GameClosedDialog(
                    'images/successful.json',
                    'Your number is added successfully / तुम्हारा नंबर जुड़ चूका है',
                    15);
              });
          setState(() {});
        } else {
          if (jsonDecode(response.data).toString() == 'device_id') {
            Navigator.pop(context);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) {
                  return AnotherLoginDialog();
                });
          } else {
            if (jsonDecode(response.data).toString() == 'Closed') {
              Navigator.pop(context);
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) {
                    return GameClosedDialog(
                        'images/gameclose.json',
                        'You are late, Game is closed now, Play next one / आप लेट हो, गेम बंद हो गई है क्रपा अगली गेम खेले |',
                        20);
                  });
            } else {
              Navigator.pop(context);
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) {
                    return GameClosedDialog('images/error.json',
                        'Check your internet connection', 15);
                  });
            }
          }
        }
      } else {
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) {
              return GameClosedDialog('images/error.json',
                  'Check your internet connection status coe not 200', 15);
            });
      }
    });
    if (mounted) {
      setState(() {});
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
        getCurrentUser();
        getTodayQuestion();
        generateNumnerList(widget.number_list);
      }
    });

    super.initState();
  }

  contentBox(context, int selectedNumber) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFC9D6FF),
                    Color(0xFFE2E2E2)
                  ],
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Constants.padding),
                    topLeft: Radius.circular(Constants.padding)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Gtext(
                  'Choose money / रूपये चुने ',
                  2,
                  bold: true,
                ),
                SizedBox(
                  height: 1 * SizeConfig.heightMultiplier,
                ),
                Expanded(
                  child: Container(

                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: points.length,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 1),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5)
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF9794f0),
                                Color(0xFF9896f9)
                              ],
                            ),
                          ),
                          padding: EdgeInsets.all(1),
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                //addUserNumber(selectedNumber, points[index]);
                                Navigator.pop(context);

                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return chooseWallet(
                                          context, selectedNumber,int.parse(points[index].toString()));
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: AutoSizeText(
                                    '\u20b9' + points[index].toString(),
                                    style: GoogleFonts.gotu(
                                        fontSize:
                                            2.3 * SizeConfig.textMultiplier,
                                        color: Colors.white),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                        // ye phele ka
                        /*if (points[index] <= added!) {
                          return Container(
                            decoration: BoxDecoration(
                              color: ColorSystem.kprimary,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            padding: EdgeInsets.all(1),
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  addUserNumber(selectedNumber, points[index]);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                    child: AutoSizeText(
                                      '\u20b9' + points[index].toString(),
                                      style: GoogleFonts.gotu(
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          color: Colors.white),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            padding: EdgeInsets.all(1),
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            child: Container(
                              child: InkWell(
                                splashColor: Colors.white,
                                highlightColor:
                                    ColorSystem.kprimary.withOpacity(0.5),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SizeConfig()
                                          .mysnack('Insufficient Balance'));
                                },
                                child: Ink(
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                    child: AutoSizeText(
                                      '\u20b9' + points[index].toString(),
                                      style: GoogleFonts.gotu(
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          color: Colors.white),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }*/
                        // yha tak
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 2 * SizeConfig.heightMultiplier,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorSystem.klight),
                        ),
                        child: Gtext(
                          " Cancel ",
                          3,
                          color: Colors.white,
                          bold: false,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: ColorSystem.klight,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Gtext(
                    selectedNumber < 10
                        ? '0' + selectedNumber.toString()
                        : selectedNumber.toString(),
                    3.5,
                    bold: true,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  chooseWallet(context, int selectedNumber,int money) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(5)
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFFC9D6FF),
            Color(0xFFE2E2E2)
          ],
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Gtext(
              selectedNumber < 10
                  ? '0' + selectedNumber.toString()+' -> '+'\u20b9'+money.toString()
                  : selectedNumber.toString(),
             2.2,
              color: Colors.black,
              bold: true,
            ),
          ),
          SizedBox(
            height: 1 * SizeConfig.heightMultiplier,
          ),
          Gtext(
            'Your Wallet',
            1.7,
            color: Colors.black45,
            bold: true,
          ),
          SizedBox(
            height: 1 * SizeConfig.heightMultiplier,
          ),
          Card(
            borderOnForeground: true,
            elevation: 5,
            color: Colors.transparent,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(5),
            ),
            child: Container(
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Gtext(
                            'Added Money',
                            1.3,
                            color: Colors.white,

                          ),
                          Gtext(
                            '  \u20b9' + added.toString() + '  ',
                            2.5,
                            color: Colors.black,
                          )
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child:  added!>=money?ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFC9D6FF)),
                            ),
                            child: Gtext(
                              "Add",
                              1.5,
                              color: Colors.black,
                            ),
                            onPressed: () {

                              addUserNumber(selectedNumber, money, 'added');
                            },
                          ):Gtext('Insufficient\nBalance', 1.3,color: Colors.white,bold: true,)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Gtext(
                            'Winning Money',
                            1.3,
                            color: Colors.white,
                          ),
                          Gtext(
                            '  \u20b9' + withdraw.toString() + '  ',
                            2.5,
                            color: Colors.black,
                          )
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: withdraw!>=money?ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFC9D6FF)),
                            ),
                            child: Container(
                              child: Gtext(
                                "Add",
                                1.5,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              addUserNumber(selectedNumber, money, 'withdraw');
                            },
                          ):Gtext('Insufficient\nBalance', 1.3,color: Colors.white,bold: true,)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2* SizeConfig.heightMultiplier,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Gtext(
                            'Earning Money',
                            1.3,
                            color: Colors.white,
                          ),
                          Gtext(
                            '  \u20b9' + ref_earn.toString() + '  ',
                            2.5,
                            color: Colors.black,
                          )
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ref_earn!>=double.parse(money.toString())?ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFC9D6FF)),
                            ),
                            child: Gtext(
                              "Add",
                              1.5,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              addUserNumber(selectedNumber,money, 'ref_earn');
                            },
                          ):Gtext('Insufficient\nBalance', 1.3,color: Colors.white,bold: true,)
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 2 * SizeConfig.heightMultiplier,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorSystem.klight),
                  ),
                  child: Gtext(
                    " Cancel ",
                    3,
                    color: Colors.white,
                    bold: false,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        body: string != null
            ? string != 'Offline'
                ? SafeArea(
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
                              colors: [Color(0xFFC9D6FF), Color(0xFFE2E2E2)],
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
                                    'Play Now',
                                    2.2,
                                    color: Colors.black,
                                    bold: true,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              added != null
                                  ? WalletDetails(added, withdraw, ref_earn)
                                  : userlogincheck < 0
                                      ? Gtext(
                                          'not found',
                                          3,
                                          color: Colors.white,
                                        )
                                      : LottieAnimation(
                                          10, "images/loading.json"),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              values.length > 0
                                  ? QuestionDesign(question, values)
                                  : Gtext(
                                      'Wait...',
                                      2,
                                      color: Colors.white70,
                                    ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Gtext(
                                'Select Numbers',
                                1.5,
                                color: Colors.black,
                                bold: true,
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              numbersList.length > 0
                                  ? Expanded(
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: numbersList.length,
                                        physics: ScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                        ),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  enableDrag: false,
                                                  backgroundColor:
                                                  Colors.transparent,
                                                  context: context,
                                                  builder: (context) {
                                                    return contentBox(
                                                        context,
                                                        int.parse(numbersList[
                                                        index]));
                                                  });
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
                                              child: new Container(
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFFA1FFCE),
                                                        Color(0xFFFAFFD1)
                                                      ],
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Gtext(
                                                      numbersList[index],
                                                      2,
                                                      color: Colors.black,
                                                      bold: true,
                                                    ),
                                                  )),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier,
                                  ),
                                  if (selectedNumberList.length > 0)
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (ctx) {
                                              return Dialog(
                                                backgroundColor: Colors.white,
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.7,
                                                  padding: EdgeInsets.all(10),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        selectedNumberList
                                                            .length,
                                                    physics: ScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        margin: EdgeInsets.all(5),
                                                        alignment: Alignment.center,
                                                        decoration: new BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(5)
                                                          ),
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              Color(0xFF9796f0),
                                                              Color(0xFFfbc7d4)
                                                            ],
                                                          ),
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Gtext(
                                                              "\u20b9" +
                                                                  selectedNumberList[
                                                                  index]
                                                                      .amount
                                                                      .toString(),
                                                              2.2,
                                                              bold: true,
                                                            ),
                                                            Gtext(
                                                              "-->",
                                                              2.2,
                                                              bold: true,
                                                            ),
                                                            Gtext(
                                                              selectedNumberList[index]
                                                                  .number
                                                                  .toString(),
                                                              2.2,
                                                              color:
                                                              Colors.black,
                                                              bold:
                                                              true,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            });
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
                                          padding: EdgeInsets.all(15),
                                          decoration: new BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF3a6186),
                                                Color(0xFF89253e)
                                              ],
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Gtext(
                                                'Your Selected Number ',
                                                2,
                                                color: Colors.white,
                                              ),
                                              Gtext(
                                                selectedNumberList.length
                                                    .toString(),
                                                2,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    selecnumberloading
                                        ? LottieAnimation(
                                            10, "images/loading.json")
                                        : SizedBox(),
                                ],
                              ),
                            ],
                          )),
                    ),
                  )
                : noInternet()
            : LottieAnimation(10, "images/loading.json"),
      );
    });
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 40;
}
