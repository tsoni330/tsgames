import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/size_config.dart';

class LoadingWidget extends StatelessWidget {
  String msg;

  LoadingWidget(this.msg);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Lottie.asset('images/loading.json',
                        width: 6 * SizeConfig.heightMultiplier,
                        height: 6 * SizeConfig.heightMultiplier),
                    SizedBox(
                      width: 10,
                    ),
                    Gtext(
                      msg,
                      1.5,
                      bold: true,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
