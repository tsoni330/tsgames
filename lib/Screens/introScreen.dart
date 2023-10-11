import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/loginScreen.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/glassContainer.dart';
import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/dialogs/game_closed_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../size_config.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {


  @override
  void initState() {
   // saveVersionCode();
    super.initState();
  }

  _launchURL() async {
    const url =
        'https://www.termsandconditionsgenerator.com/live.php?token=d2rlicVTyYag43Ypz7WXXwanOxT4DjKS';

    try{
      if (!await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      )) {
        throw 'Error';
      }
    }catch(e){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) {
            return GameClosedDialog('images/error.json', 'Cannot launch url right now, try later', 15);
          });
    }

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC9D6FF),
                  Color(0xFFE2E2E2)
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gtext(
                          'Welcome !',
                          3,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Gtext(
                          'Some important notes for you, Read carefully !',
                          1.8,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
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
                                  Color(0xFFFBD3E9),
                                  Color(0xFFddd6f3),

                                ],
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Gtext(
                              'TS Games takes great care to comply with all central and state legislation in India to ensure that our users are fully protected. Every quiz on our platform is carefully'
                              ' designed to comply with applicable statutes and '
                              'regulations in India.',
                              1.5,
                              color: Colors.black,
                              bold: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
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
                                  Color(0xFFFBD3E9),
                                  Color(0xFFddd6f3),

                                ],
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Gtext(
                              'This game involves an element of financial risk and may be addictive. Please play responsibly at your own risk.',
                              1.5,
                              color: Colors.black,
                              bold: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Gtext(
                          'Terms & Conditions',
                          2,
                          color: Colors.black,
                          bold: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
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
                                  Color(0xFFFBD3E9),
                                  Color(0xFFddd6f3),

                                ],
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                _launchURL();
                              },
                              child: Gtext(
                                "Read our Terms & Conditions. Tap 'Agree and Continue' to accept it",
                                1.5,
                                color: Colors.blue,
                                bold: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.off(()=>LoginScreen());
                  },
                  child: Gtext(
                    'Agree and Continue',
                    2,
                    color: Colors.black,
                    bold: true,
                  ),
                  style: ElevatedButton.styleFrom(primary:  Color(0xFFFBD3E9)),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
