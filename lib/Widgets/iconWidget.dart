import 'package:flutter/material.dart';
import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/size_config.dart';


class CustomIconWidget extends StatelessWidget {

  IconData iconData;
  double size;
  Color? color;
  CustomIconWidget(this.iconData,{this.size = 30, this.color= ColorSystem.kprimary});
  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: size*SizeConfig.heightMultiplier,
      color: color,
    );
  }
}

