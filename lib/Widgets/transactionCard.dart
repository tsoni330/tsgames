import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tusharsonigames/Widgets/iconWidget.dart';
import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/bloc/animation_bloc.dart';

import '../size_config.dart';
import 'Gtext.dart';


class TransactionCard extends StatefulWidget {

  String sno,name,subheading;


  TransactionCard(this.sno, this.name, this.subheading);

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> with TickerProviderStateMixin {



  AnimationBloc bloc = AnimationBloc();
  Color? color;
  late Animation animation;
  late AnimationController controller;


  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    animation =
    ColorTween(begin: Colors.black, end: Colors.white38).animate(controller)
      ..addListener(
            () {
          bloc.blocSink.add(animation.value);
        },
      );

    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Card(
        borderOnForeground: true,
        elevation: 5,
        color: Colors.transparent,
        shadowColor: Colors.black,
        margin: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(5),
        ),
        child: Container(
          decoration:
          new BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF77A1D3),
                Color(0xFF79CBCA),
                Color(0xFFE684AE)

              ],
            ),
            borderRadius:
            BorderRadius.all(Radius.circular(5)),
          ),
          padding: EdgeInsets.all(10),

          child: Column(
            children: [
              Gtext(
                widget.subheading,
                1.5,
                color: Colors.black,
                bold: true,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  Expanded(
                    child: Gtext(
                      widget.name,
                      1.8,
                      color: Colors
                          .black,
                      bold: true,
                    ),
                  ),
                  StreamBuilder(
                      stream: bloc
                          .blocStream,
                      builder:
                          (context,
                          snapshot) {
                        if(snapshot.data!=null){
                          Color c = snapshot.data as Color;
                          return CustomIconWidget(
                            Icons.arrow_forward,
                            size:
                            3,
                            color: c,
                          );
                        }else{
                          return CustomIconWidget(
                            Icons.arrow_forward,
                            size:
                            3.5,
                            color: ColorSystem.kprimary,
                          );
                        }

                      }),
                ],
              ),
            ],
          ),
        ));
  }
}

