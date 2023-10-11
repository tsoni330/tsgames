import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/dialogs/game_closed_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../size_config.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  _launchURL(String uri) async {
    String url = uri;
    try {
      await launch(url);
    } catch(e) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return GameClosedDialog('images/error.json', 'Cannot launch url right now, try later '+e.toString(), 15);
          });
    }
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
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                          'Contact Us',
                          2.2,
                          color: Colors.black,
                          bold: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.white,
                          child: Gtext(
                            'Need Help ?',
                            3,
                            //color: Colors.white,
                            bold: true,
                          ),
                        ),
                        SizedBox(
                          height: 1 * SizeConfig.heightMultiplier,
                        ),
                        Gtext(
                          'We are here for you!',
                          2,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          height: 1 * SizeConfig.heightMultiplier,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _launchURL('https://wa.me/+919671775251');
                          },
                          child: Gtext(
                            'Whatsapp:- 9671775251',
                            2,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.cyanAccent),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _launchURL(
                                'mailto:help@tusharsoniquiz.in?subject=Need Help');
                          },
                          child: Gtext(
                            'help@tusharsoniquiz.in',
                            2,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.cyanAccent),
                        ),
                        SizedBox(
                          height: 4 * SizeConfig.heightMultiplier,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                            child: Gtext(
                          "Our working hour is 09:00 AM to 09:00 PM and provide support only on Whatsapp and e-mail. So put your query on whatsapp or mail and please don't try to call us / हम 09:00 AM से 09:00 PM  तक काम करते है | हम आपके सारे प्रश्नो का उत्तर देंगे सिर्फ whatsapp  और mail  पर | कृपया करके कॉल ना करे सिर्फ whatsapp  और mail  करे |",
                          1.5,
                          color: Colors.black45,
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
