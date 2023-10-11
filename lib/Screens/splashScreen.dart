import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/IconDart/main_icon_icons.dart';
import 'package:tusharsonigames/Screens/homeScreen.dart';
import 'package:tusharsonigames/Screens/introScreen.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/iconWidget.dart';
import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  String? userid;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String versionCode;
  late SharedPreferences prefs;

  mysnack(String msg){
    final waiting = SnackBar(
      content: Gtext(msg,2,color: Colors.white,),
      duration: Duration(milliseconds: 2500),
      elevation: 5,
      backgroundColor: Colors.red,
    );
    return waiting;
  }

  /*getUserid() async{
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if(userid!=null){
      Get.off(()=> HomeScreen());
    }else{
      Get.off(()=> IntroScreen());
    }

  }*/

  saveVersionCode() async{
    prefs = await SharedPreferences.getInstance();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      versionCode = packageInfo.version;
      prefs.setString('versionCode', versionCode).then((value) {
        if(value==true){
          userid = prefs.getString('userid');
          if(userid!=null){
            Get.off(()=> HomeScreen());
          }else{
            Get.off(()=> IntroScreen());
          }
        }
      });
    });
  }


  @override
  void initState() {

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.linear);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 500), () {
          saveVersionCode();
        });
      }
    });

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        body: SafeArea(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFC9D6FF),
                      Color(0xFFE2E2E2)
                    ]
                )
            ),
            child: Center(
              child: FadeTransition(
                opacity: animation,
                child: Container(
                  child: CustomIconWidget(MainIcon.mainicon, size: 20),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
