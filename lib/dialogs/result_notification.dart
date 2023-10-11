
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';

import '../size_config.dart';

class ResultNotificationDialog extends StatefulWidget {

  @override
  _ResultNotificationDialogState createState() => _ResultNotificationDialogState();
}

class _ResultNotificationDialogState extends State<ResultNotificationDialog> {

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
                LottieAnimation(25, 'images/resultout.json'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'New result is out! Refresh Now',
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
                          Get.back();
                        },
                        child: Gtext(
                          'Ok!',
                          1.7,
                          bold: true,
                        ),
                      )
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
