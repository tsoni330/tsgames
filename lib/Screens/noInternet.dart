import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tusharsonigames/Widgets/lottieWidget.dart';
import 'package:tusharsonigames/size_config.dart';


class noInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieAnimation(30,'images/nointernet.json'),
            Text('No Internet',style: GoogleFonts.gotu(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 2.5*SizeConfig.textMultiplier
            ),)
          ],
        ),
      ),
    );
  }
}
