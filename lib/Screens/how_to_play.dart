import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tusharsonigames/IconDart/play_game_icon_icons.dart';
import 'package:tusharsonigames/Screens/contacus_Screen.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/iconWidget.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/Widgets/shakeWidget.dart';

import 'package:tusharsonigames/size_config.dart';

import '../appColor.dart';

class HowToPlay extends StatefulWidget {
  @override
  _HowToPlayState createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            'How to play',
                            2.2,
                            color: Colors.black,
                            bold: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4 * SizeConfig.heightMultiplier,
                  ),

                  Gtext(
                    'Step 1 ',
                    2,
                    color: Colors.black,
                    bold: true,
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),
                  FloatingActionButton.extended(
                    onPressed: ()  {
                    },
                    icon: LottieAnimation(15, "images/playgame.json"),
                    backgroundColor: ColorSystem.klight,
                    tooltip: 'Play Games',
                    elevation: 5,
                    splashColor: Colors.black,
                    label: Gtext(
                      '',
                      1,
                      color: Colors.white,
                      bold: true,
                    ),
                  ),

                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),
                  Gtext(
                    'Click on the Play button which is on Home Screen or First Screen / Play बटन पर क्लिक करो जो Home Screen पर दिया हुआ है |',
                    1.5,
                    color: Colors.black45,
                    bold: true,
                  ),
                  SizedBox(
                    height: 4 * SizeConfig.heightMultiplier,
                  ),

                  Gtext(
                    'Step 2 ',
                    2,
                    color: Colors.black,
                    bold: true,
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),

                  Gtext(
                    'You get 3 types of games there, Select which one you want to play / आपको 3 गेम की लिस्ट मिलेगी, आप देखो की आपको कौन सी गेम खेलनी है |',
                    1.5,
                    color: Colors.black45,
                    bold: true,
                  ),

                  SizedBox(
                    height: 4 * SizeConfig.heightMultiplier,
                  ),

                  Gtext(
                    'Step 3 ',
                    2,
                    color: Colors.black,
                    bold: true,
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),

                  Gtext(
                    'You will get full day slot, select in which slot you want to play / आपको पूरे दिन की गेम लिस्ट मिल जाएगी, आप देखो आपको कौन से Slot में गेम खेलनी है |',
                    1.5,
                    color: Colors.black45,
                    bold: true,
                  ),

                  SizedBox(
                    height: 4 * SizeConfig.heightMultiplier,
                  ),

                  Gtext(
                    'Step 4 ',
                    2,
                    color: Colors.black,
                    bold: true,
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),

                  Gtext(
                    'Get list of all number, select which number you want to choose and add how much you want to play on that / पूरे नंबर की लिस्ट आपको मिल जाएगी, उसमे से अपना नंबर सेलेक्ट करके पैसे लगाओ |',
                    1.5,
                    color: Colors.black45,
                    bold: true,
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),

                  Center(
                    child: Gtext(
                      'For More ',
                      1.8,
                      color: Colors.black,
                      bold: true,
                    ),
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),

                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(ContactUs());
                          },
                          child: Gtext(
                            'Contact Us',
                            2,
                            color: Colors.black,
                          )))

                ],
              ),
            ),
          ),
        ),
      );

    });
  }

}
