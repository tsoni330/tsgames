import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/refrenceTransaction.dart';
import 'package:tusharsonigames/Screens/walletTransaction.dart';
import 'package:tusharsonigames/Screens/withdrawTransaction.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/loadingWidget.dart';
import 'package:tusharsonigames/Widgets/transactionCard.dart';
import '../size_config.dart';

class Transaction1 extends StatefulWidget {
  @override
  _Transaction1State createState() => _Transaction1State();
}

class _Transaction1State extends State<Transaction1> {
  int userLoginCheck = 0;
  String? userid;

  getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if (userid != null) {
      setState(() {
        userLoginCheck = 1;
      });
    } else {
      setState(() {
        userLoginCheck = -1;
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
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
            child: userLoginCheck == 1
                ? SingleChildScrollView(
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
                                'Transactions',
                                2,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => WalletTransaction(userid));
                            },
                            child: TransactionCard('1', 'Wallet Transaction',
                                'What you add and what you spend / कितने जमा किया और कितने के no. लिए '),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => WithdrawTransaction(userid));
                            },
                            child: TransactionCard('2', 'Withdraw Transaction',
                                'How much you withdraw / कितने पैसा आपके बैंक खाते में गया '),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => RefrenceTransaction(userid));
                            },
                            child: TransactionCard(
                                '3',
                                'Refrence Earning Transaction',
                                'How much you earn / कितने पैसे कमाए Refrence से और कितने अपने बैंक खाते में डाले'),
                          ),
                        ),
                      ],
                    ),
                  )
                : userLoginCheck == -1
                    ? Center(
                        child: Gtext(
                          'No user found, Get back again',
                          2,
                          color: Colors.white,
                        ),
                      )
                    : LoadingWidget('Getting your data...'),
          ),
        ),
      );
    });
  }
}
