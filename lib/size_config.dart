import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';

import 'Widgets/Gtext.dart';

class SizeConfig{
  static late double _screenWidth;
  static late double _screenHeight;
  static double _blockSizeHorizontal=0;
  static double _blockSizeVertical=0;
  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;


  mysnack(String msg) {
    final waiting = SnackBar(
      content: Gtext(
        msg,
        2,
        color: Colors.white,
      ),
      duration: Duration(milliseconds: 2500),
      elevation: 5,
      backgroundColor: Colors.red,
    );
    return waiting;
  }

  void init(BoxConstraints constraints){
    _screenWidth=constraints.maxWidth;
    _screenHeight=constraints.maxHeight;

    _blockSizeHorizontal=_screenWidth/100;
    _blockSizeVertical=_screenHeight/100;

    textMultiplier=_blockSizeVertical;
    imageSizeMultiplier=_blockSizeHorizontal;
    heightMultiplier=_blockSizeVertical;
  }

  static void shareApp(BuildContext context){
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share('https://play.google.com/store/apps/details?id=com.upkeephouse.upkeephousepartner',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

}