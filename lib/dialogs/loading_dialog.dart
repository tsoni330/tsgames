
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:tusharsonigames/Widgets/lottieWidget.dart';


import '../size_config.dart';

class LoadingDialog extends StatefulWidget {
  String uri,msg;
  double size;


  LoadingDialog(this.uri, this.msg, this.size);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {


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
                LottieAnimation(widget.size, widget.uri),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.msg,
                  style: GoogleFonts.libreBaskerville(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 2 * SizeConfig.heightMultiplier,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
