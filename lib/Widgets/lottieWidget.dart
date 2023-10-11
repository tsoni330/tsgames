import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tusharsonigames/size_config.dart';

class LottieAnimation extends StatelessWidget {

  double size;
  String uri;

  LottieAnimation(this.size,this.uri);

  @override
  Widget build(BuildContext context) {
    return  Lottie.asset(uri,
          width: size * SizeConfig.heightMultiplier,
          height: size * SizeConfig.heightMultiplier,
      fit: BoxFit.scaleDown
      );

  }
}
