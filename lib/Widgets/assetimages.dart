import 'package:flutter/material.dart';

import '../size_config.dart';

class AssImages extends StatelessWidget {
  double width, height;
  Color color;
  String uri;
  BoxFit fit;

  AssImages(this.uri,this.fit,
      {this.width = 10, this.height = 10, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        uri,
        fit: fit,
        width: width * SizeConfig.imageSizeMultiplier,
        height: height * SizeConfig.heightMultiplier
      ),
    );
  }
}
