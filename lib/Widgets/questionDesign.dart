import 'package:flutter/material.dart';

import '../size_config.dart';
import 'Gtext.dart';


class QuestionDesign extends StatelessWidget {

  String? question;
  List<String?> values;


  QuestionDesign(this.question, this.values);

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      elevation: 5,
      color: Colors.transparent,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFFC9FFBF),
              Color(0xFFFFAFBD)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            question != null
                ? Gtext(
              question!+' :-',
              1.3,
              bold: true,
              color: Colors.black,
            )
                : SizedBox(),
            SizedBox(height:1*SizeConfig.heightMultiplier),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Gtext(values[0], 1.5,color: Colors.black,),
                  Gtext(values[1], 1.5,color: Colors.black,),
                  Gtext(values[2], 1.5,color: Colors.black,),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Gtext(values[3], 1.5,color: Colors.black,),
                  Gtext(values[4], 1.5,color: Colors.black,),
                  Gtext(values[5], 1.5,color: Colors.black,),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Gtext(values[6], 1.5,color: Colors.black,),
                  Gtext(values[7], 1.5,color: Colors.black,),
                  Gtext(values[8], 1.5,color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
