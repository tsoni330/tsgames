import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../appColor.dart';
import '../size_config.dart';

class Ltext extends StatelessWidget {

  String text;
  double size;
  Color color;
  bool bold;

  Ltext(this.text,this.size,{this.color=ColorSystem.kprimary,this.bold=false});
  @override
  Widget build(BuildContext context) {
    return bold==false?Text(
      text,
      style: GoogleFonts.marcellus(fontSize: size*SizeConfig.textMultiplier,color: color,letterSpacing: 1),
    ):Text(
      text,
      style: GoogleFonts.marcellus(fontSize: size*SizeConfig.textMultiplier,color: color,fontWeight: FontWeight.bold,letterSpacing: 1),
    );
  }
}