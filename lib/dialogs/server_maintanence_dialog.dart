import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';

import '../size_config.dart';

class ServerMaintanenceDialog extends StatelessWidget {

  String w_msg;
  ServerMaintanenceDialog(this.w_msg);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child:   Dialog(
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
              LottieAnimation(
                  25, 'images/maintainance.json'),
              SizedBox(
                height: 10,
              ),
              Text(
                w_msg+' / '+'अभी हमारा server पर काम चल रहा है, थोड़ा 10-15 मिनट का इंतज़ार करे | असुविधा के लिए खेद है | ',
                style: GoogleFonts.libreBaskerville(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize:
                  1.5 * SizeConfig.textMultiplier,
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
                        'Ok',
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
    )
    );
  }
}
