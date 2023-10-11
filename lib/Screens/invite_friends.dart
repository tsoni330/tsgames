import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';

import 'package:tusharsonigames/size_config.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  String text = 'https://play.google.com/store/apps/details?id=com.tusharsonigames.tusharsonigames'; //'http://www.aksdute.com/TSGames.apk';
  String subject = 'Download now';

  int userLoginCheck = 0;
  late String mainuserid;


  getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');
    if (userid != null) {
      setState(() {
        mainuserid= userid;
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
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        body: SafeArea(
          child: Container(
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
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Row(
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
                                  'Invite Friends',
                                  2.2,
                                  color: Colors.black,
                                  bold: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2 * SizeConfig.heightMultiplier,
                        ),

                        Lottie.asset('images/refrence.json',
                            width: double.infinity,
                            height: 25 * SizeConfig.heightMultiplier,
                            fit: BoxFit.contain,
                        ),

                        SizedBox(
                          height: 2 * SizeConfig.heightMultiplier,
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Gtext(
                                'Boost the earnings without spendings',
                                1.7,
                                color: Colors.black,
                                bold: true,
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Gtext(
                                'हाँ, ढेर सारे पैसे कमा सकते हो वो भी बिना पैसा invest और खर्च किये | ज्यादा से ज्यादा लोगो जोड़ो अपनी id से और ज्यादा से ज्यादा पैसे कमाए  | जब जब वो गेम खेलेंगे तब तब आपको 5 - 15 % तक कमीशन आपके अकाउंट में आ जायेगा | जैसे मैं आपकी id से जुड़ा हुआ हु और मैं ( Big Blast ) गेम खेलता हु 100 रुपए  तो 15 रुपए का कमीशन आपके खाते में आ जायेगा | अधिक जानकारी के लिए contact us पर क्लिक करे |',
                                1.5,
                                color: Colors.black45,
                                bold: true,
                              ),
                              SizedBox(
                                height: 3 * SizeConfig.heightMultiplier,
                              ),
                              Gtext(
                                'Your Id',
                                2,
                                color: Colors.black,
                                bold: true,
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Container(
                                width: double.infinity,
                                child: DottedBorder(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.black,
                                  //color of dotted/dash line
                                  strokeWidth: 1,
                                  //thickness of dash/dots
                                  dashPattern: [3, 3],
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      mainuserid,
                                      style: TextStyle(
                                        letterSpacing: 1.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3 * SizeConfig.heightMultiplier,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.black,
                                highlightColor: Colors.white,
                                child: Gtext(
                                  'Commission Rates',
                                  2.5,
                                  //color: Colors.white,
                                  bold: true,
                                ),
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Gtext(
                                'Big Blast ' + ' = ' + '15 %',
                                1.8,
                                color: Colors.black45,
                                bold: true,
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Gtext(
                                '₹10 ka ₹90 ' + ' = ' + '10 %',
                                1.8,
                                color: Colors.black45,
                                bold: true,
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Gtext(
                                '₹10 ka ₹20 ' + ' = ' + '5 %',
                                1.8,
                                color: Colors.black45,
                                bold: true,
                              ),
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        final RenderBox box = context.findRenderObject() as RenderBox;
                                        Share.share(text,
                                            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                                      },
                                      child: Gtext(
                                        'Share Now',
                                        2.2,
                                        color: Colors.black,
                                      )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : userLoginCheck == -1
                    ? Center(
                        child: Gtext(
                          'No User Found',
                          2.2,
                          color: Colors.white,
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
          ),
        ),
      );
    });
  }
}
