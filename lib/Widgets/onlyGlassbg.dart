import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBG extends StatelessWidget {

  Widget child;
  GlassBG(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ClipRect(
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: new Container(
           //   padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: child
          ),
        ),
      ),
    );
  }
}
