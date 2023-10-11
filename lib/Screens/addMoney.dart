import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/contacus_Screen.dart';
import 'package:tusharsonigames/Screens/noInternet.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/bloc/MyConnectivity.dart';
import 'package:tusharsonigames/dialogs/game_closed_dialog.dart';
import 'package:tusharsonigames/dialogs/loading_dialog.dart';
import 'package:tusharsonigames/model/instant_cash.dart';
import 'package:dio/dio.dart' as dpack;
import '../appColor.dart';
import '../size_config.dart';

class AddMoney extends StatefulWidget {
  int? added;

  AddMoney(this.added);

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  static const platform = const MethodChannel("razorpay_flutter");
  TextEditingController controller = TextEditingController();

  String? amount;
  late Razorpay _razorpay;
  String? error, verified, userid, name;
  bool usercheck = false;
  String key =
      'rzp_live_gni6cqFDq5jIPa';
  String secret =
      'fCYhGRrL7kt55XX8sNcD31K4';

  String? string;

  late Map _source;

  MyConnectivity? _connectivity = MyConnectivity.instance;
  RegExp regExp = RegExp(r"^[1-9][0-9]*$");

  List<InstantCash> instantcash = [
    InstantCash(10, Colors.brown),
    InstantCash(20, Colors.green),
    InstantCash(30, Colors.green),
    InstantCash(40, Colors.green),
    InstantCash(50, Colors.blueGrey),
    InstantCash(100, Colors.blue),
    InstantCash(200, Colors.deepOrangeAccent),
    InstantCash(300, Colors.deepOrangeAccent),
    InstantCash(500, Colors.grey),
    InstantCash(1000, Colors.red),
    InstantCash(2000, Colors.pink),
    InstantCash(5000, Colors.cyan)
  ];

  getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    name = prefs.getString('name');
    if (userid != null) {
      if (mounted) {
        setState(() {
          usercheck = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
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
      }
    });

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _razorpay.clear();
  }

  void openCheckout(int money, String orderid) async {
    var options = {
      'key': key,
      'amount': money * 100,
      'name': name,
      'description': 'Add to my wallet',
      'order_id': orderid,
      'retry': {'enabled': true, 'max_count': 1},
      'prefill': {'contact': userid}
    };
    try {
      Navigator.of(context).pop();
      _razorpay.open(options);
    } catch (e) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return GameClosedDialog(
                'images/error.json', 'Error:- ' + e.toString(), 15);
          });
    }
  }

  generateOrderId(String key, String secret, int amount) async {
    try {
      var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

      dpack.Dio dio = new dpack.Dio();
      dio.options.headers["Authorization"] = authn;
      dio.options.headers["content-type"] = 'application/json';

      var data =
          '{ "amount": $amount, "currency": "INR", "payment_capture": 1 }';

      var res =
          await dio.post('https://api.razorpay.com/v1/orders', data: data);
      if (res.statusCode != 200) {
        throw Exception('http.post error: statusCode= ${res.statusCode}');
      } else {
        openCheckout(amount, res.data['id'].toString());
      }
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return GameClosedDialog(
                'images/error.json', 'Please try again ' + e.toString(), 15);
          });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    addMoney(response.paymentId, response.orderId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return GameClosedDialog(
              'images/error.json',
              'Payment is Failed \nPlease Check Againg / कृपया दोबारा जांच करें',
              15);
        });
  }

  addMoney(String? paymentid, String? orderid) async {
    String url = 'http://www.aksdute.com/tsgames/add_money.php';
    dpack.FormData newData = new dpack.FormData.fromMap({
      'userid': userid,
      'amount': amount,
      'payment_id': paymentid,
      'order_id': orderid
    });
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (jsonDecode(value.data).toString() == 'true') {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return GameClosedDialog('images/successful.json',
                    'Your payment is successfully added', 15);
              });
        }
      }
    });
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
        child: SafeArea(
          child: Scaffold(
            body: string != null
                ? string != 'Offline'
                    ? Container(
                        padding: EdgeInsets.all(10),
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFC9D6FF), Color(0xFFE2E2E2)],
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
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
                                  SizedBox(
                                    width: 2 * SizeConfig.heightMultiplier,
                                  ),
                                  Gtext(
                                    "Add Money",
                                    2,
                                    color: Colors.black,
                                    bold: true,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5 * SizeConfig.heightMultiplier,
                              ),
                              /*Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                            decoration: InputDecoration(
                              labelText: "Enter Amount",
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.pinkAccent),
                              ),
                              contentPadding:
                              EdgeInsets.only(left: 10, bottom: 11, top: 11),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) => amount = value,
                          ),
                        ),
                        SizedBox(
                          width: 1 * SizeConfig.heightMultiplier,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              error=null;
                            });
                            if(amount!=null){
                              if(regExp.hasMatch(amount!) == true){

                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (ctx) {
                                      return LoadingDialog('images/loading.json', 'Please wait.....\n\n\n May take some time', 15);
                                    });
                                generateOrderId(key, secret, int.parse(amount!)*100);

                              }else{
                                setState(() {
                                  error = 'Please Enter only number like (150,90,20) not like (020, 010, 125.5) / सिर्फ number डालो इसकी तरह (120 , 50 , 45000 ) ना की इसकी तरह (0120 , 150.50 , 080) ';
                                });
                              }
                            }else{
                              setState(() {
                                error='Please enter Number';
                              });
                            }

                          },
                          child: Gtext(
                            ' Add ',
                            2,
                            color: Colors.white,
                            bold: true,
                          ),
                          style: ElevatedButton.styleFrom(primary: ColorSystem.klight),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5 * SizeConfig.heightMultiplier,
                    ),*/
                              Gtext(
                                'Quick Selection',
                                1.5,
                                color: Colors.black45,
                                bold: true,
                              ),
                              Container(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: instantcash.length,
                                  physics: ScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 4,
                                          mainAxisSpacing: 1),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: instantcash[index].color,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(1),
                                      margin:
                                          EdgeInsets.only(top: 15, bottom: 15),
                                      child: Container(
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          highlightColor: ColorSystem.kprimary
                                              .withOpacity(0.5),
                                          onTap: () {
                                            setState(() {
                                              amount = instantcash[index]
                                                  .money
                                                  .toString();
                                            });

                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (ctx) {
                                                  return LoadingDialog(
                                                      'images/loading.json',
                                                      'Please wait.....\n\n\n May take some time',
                                                      15);
                                                });

                                            generateOrderId(
                                                key,
                                                secret,
                                                (instantcash[index].money *
                                                    100));
                                          },
                                          child: Ink(
                                            padding: EdgeInsets.all(5),
                                            child: Center(
                                              child: AutoSizeText(
                                                '\u20b9' +
                                                    instantcash[index]
                                                        .money
                                                        .toString(),
                                                style: GoogleFonts.gotu(
                                                    fontSize: 2.3 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 3 * SizeConfig.heightMultiplier,
                              ),
                              error != null
                                  ? Center(
                                      child: Gtext(
                                        error,
                                        2,
                                        color: Colors.red,
                                        bold: true,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 3 * SizeConfig.heightMultiplier,
                                    ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Gtext(
                                "If you have any payment issue, you don't need to worry about it. You can whatsapp or mail us to given number. Click to Contact Us / अगर कोई भी समस्या आती है तो हमको contact करे | नीचे दिए हुआ बटन दबाये |",
                                1.5,
                                color: Colors.black45,
                                bold: true,
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Get.off(() => ContactUs());
                                    },
                                    child: Gtext(
                                      'Contact Us',
                                      2.2,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ),
                      )
                    : noInternet()
                : LottieAnimation(10, "images/loading.json"),
          ),
        ),
      );
    });
  }
}
