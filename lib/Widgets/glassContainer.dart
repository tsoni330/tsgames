import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';

import '../appColor.dart';


class GlassContainer extends StatelessWidget {

  String text;
  double size;
  Color color;

  GlassContainer(this.text,this.size,{this.color=ColorSystem.kprimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ClipRect(
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: new Container(
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Gtext(
              text, size , color: color, bold: false,
            )
          ),
        ),
      ),
    );
  }
}
