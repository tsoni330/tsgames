import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Screens/bank_details.dart';
import 'package:tusharsonigames/Screens/chart.dart';
import 'package:tusharsonigames/Screens/contacus_Screen.dart';
import 'package:tusharsonigames/Screens/faq_Screen.dart';
import 'package:tusharsonigames/Screens/how_to_play.dart';
import 'package:tusharsonigames/Screens/invite_friends.dart';
import 'package:tusharsonigames/Screens/notificatoin_Screen.dart';
import 'package:tusharsonigames/Screens/profile.dart';
import 'package:tusharsonigames/Screens/rules_Screen.dart';
import 'package:tusharsonigames/Screens/splashScreen.dart';
import 'package:tusharsonigames/Screens/transaction1.dart';
import 'package:tusharsonigames/Screens/user_number_history.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/appColor.dart';
import 'package:tusharsonigames/size_config.dart';


class NavigationDrawerWidget extends StatelessWidget {
  String? name,id,versionCode;
  BuildContext context;



  NavigationDrawerWidget(this.name, this.id,this.context,this.versionCode);

  removeAll() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if(prefs.getString('userid')==null){
      Get.offAll(()=>SplashScreen());
    }else{
      print('facing error');
    }

  }

  final padding = EdgeInsets.symmetric(horizontal: 5);
  @override
  Widget build(context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC9D6FF),
              Color(0xFFE2E2E2)
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: padding,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          padding: padding.add(EdgeInsets.symmetric(vertical: 20)),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 6*SizeConfig.imageSizeMultiplier,
                                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                                child: Gtext(name![0],3,color: Colors.white,),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Gtext(
                                     name,2,color: Colors.black,bold: true,
                                    ),
                                    const SizedBox(height: 4),
                                    Gtext(
                                      'Id:- '+id!,1.5,color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        buildMenuItem(
                          text: 'Profile',
                          icon: Icons.person,
                          onClicked: (){
                            Navigator.pop(context);
                            Get.to(()=>Profile());
                          }

                        ),

                        buildMenuItem(
                          text: 'Bank Details',
                          icon: Icons.account_balance,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>BankDetails());
                            }
                        ),

                        buildMenuItem(
                          text: 'Complete Chart',
                          icon: Icons.description,
                          onClicked: (){
                            Navigator.pop(context);
                            Get.to(()=>FullChart());
                          }
                        ),


                        buildMenuItem(
                          text: 'Transactions',
                          icon: Icons.history,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>Transaction1());
                            }

                        ),

                        buildMenuItem(
                          text: 'Your Numbers History',
                          icon: Icons.subject,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>UserNumberHistory());
                            }
                        ),

                        buildMenuItem(
                          text: 'Invite Friends',
                          icon: Icons.attach_money,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>InviteFriends());
                            }
                        ),

                        buildMenuItem(
                          text: 'How to Play',
                          icon: Icons.games,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>HowToPlay());
                            }
                        ),
                        /*buildMenuItem(
                            text: 'Notifications',
                            icon: Icons.notifications,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>Notifications());
                            }
                        ),
*/
                        Divider(color: Colors.black45),

                        buildMenuItem(
                            text: "Rules Book",
                            icon: Icons.book,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>Rules());
                            }
                        ),

                        buildMenuItem(
                          text: "FAQ's",
                          icon: Icons.info,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>Faq());
                            }
                        ),

                        buildMenuItem(
                          text: 'Contact Us',
                          icon: Icons.contact_phone,
                            onClicked: (){
                              Navigator.pop(context);
                              Get.to(()=>ContactUs());
                            }
                        ),
                        GestureDetector(
                          onTap: (){
                            removeAll();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.all(3),
                            child: Row(
                              children: [
                                Icon(Icons.exit_to_app, color: Colors.black,),
                                SizedBox(width: 10,),
                                Gtext('Log Out',1.8,color: Colors.black,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Gtext('App version:- '+versionCode!,1.5,color: Colors.black45,),
            )
          ],
        ),
      ),
    );
  }


  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.black;

    return GestureDetector(
      onTap: onClicked,
      child: Container(
       color: Colors.transparent,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(3),
        child: Row(
          children: [
            Icon(icon, color: color,),
            SizedBox(width: 10,),
            Gtext(text,1.8,color: Colors.black,),
          ],
        ),
      ),
    );
  }

}