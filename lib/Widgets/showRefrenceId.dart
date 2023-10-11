import 'package:flutter/material.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/onlyGlassbg.dart';

class ShowRefrenceID extends StatelessWidget {
  String? userid;
  ShowRefrenceID(this.userid);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
            borderOnForeground: true,
            elevation: 5,
            color: Colors.transparent,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(5),
            ),
          child:Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5)
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4B79A1),
                  Color(0xFF283E51)

                ],
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Gtext('User ID:-', 1.5,color: Colors.white,bold: true,),

                    Gtext(userid, 1.5,color: Colors.white,bold: true,),

                  ],
                ),
                SizedBox(height: 5,),
                Gtext('Use it when you add someone / जब आप किसी को App डाउनलोड कराओ,'
                    ' तब इसका उपयोग करो और पैसे कमाओ |', 1.2,color: Colors.white,bold: true,)
              ],
            ),
          )
        );
      },
    );
  }
}
