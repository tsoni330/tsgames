import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/splashScreen.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';

import '../size_config.dart';


class AnotherLoginDialog extends StatefulWidget {
  @override
  _AnotherLoginDialogState createState() => _AnotherLoginDialogState();
}

class _AnotherLoginDialogState extends State<AnotherLoginDialog> {


  removeAll() async{
    print('its working');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if(prefs.getString('userid')==null){
      Get.offAll(()=>SplashScreen());
    }else{
      print('facing error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          // color: Colors.lightGreenAccent,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LottieAnimation(25, 'images/anotherlogin.json'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Your account is already login into another device, Please log in again',
                  style: GoogleFonts.libreBaskerville(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 2 * SizeConfig.heightMultiplier,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          removeAll();
                        },
                        child: Gtext(
                          'Login Again',
                          1.7,
                          bold: true,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
