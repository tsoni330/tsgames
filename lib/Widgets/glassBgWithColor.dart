import 'package:flutter/material.dart';
import 'dart:ui';

class GlassBGWtihColor extends StatelessWidget {

  Widget child;
  Color color;
  GlassBGWtihColor(this.child,this.color);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: new ClipRect(
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: new Container(
            //   padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: child
          ),
        ),
      ),
    );
  }
}