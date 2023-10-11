import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../appColor.dart';
import '../size_config.dart';

class Gtext extends StatelessWidget {

  String? text;
  double size;
  Color? color;
  bool bold;

  Gtext(this.text,this.size,{this.color=ColorSystem.kprimary,this.bold=false});
  @override
  Widget build(BuildContext context) {
    return bold==false?Text(
      text!,
      style: GoogleFonts.libreBaskerville(fontSize: size*SizeConfig.textMultiplier,color: color,letterSpacing: 0.5),
    ):Text(
      text!,
      style: GoogleFonts.libreBaskerville(fontSize: size*SizeConfig.textMultiplier,color: color,fontWeight: FontWeight.bold,letterSpacing: 0.5),
    );
  }
}