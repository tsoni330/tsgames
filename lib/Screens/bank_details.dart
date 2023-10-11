import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';
import 'package:tusharsonigames/Widgets/loadingWidget.dart';
import 'package:tusharsonigames/bloc/msg_bloc.dart';
import 'package:tusharsonigames/dialogs/game_closed_dialog.dart';

import '../appColor.dart';
import '../size_config.dart';
import 'package:dio/dio.dart' as dpack;

class BankDetails extends StatefulWidget {
  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  int userLoginCheck = 0;

  TextEditingController? name,acc_no,ifsc;

 // FocusNode? upi_id_node, upi_name_node;
  FocusNode? namenode,accnonode,ifscnode;

  String?  userid, _mySelection='saving',acc_status;

  List<String> type_list = ['saving','current'];

  bool loading = false;
  late SharedPreferences prefs;
  final MsgBloc? bloc = MsgBloc();


  Widget DropDown(List data) {

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //         <--- border radius here
        ),
      ),
      //margin: EdgeInsets.only(left: 5, top: 15, right: 5),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          iconSize: 50,
          iconEnabledColor: ColorSystem.kprimary,
          iconDisabledColor: ColorSystem.kprimary,
          items: data.map((item) {
            return new DropdownMenuItem(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  item.toString(),
                  style: GoogleFonts.gotu(
                      color: ColorSystem.kprimary,
                      fontSize: SizeConfig.textMultiplier * 2.2),
                ),
              ),
              value: item.toString(),
            );
          }).toList(),
          hint: Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              "Select Account Type",
              style: GoogleFonts.gotu(
                  color: ColorSystem.kprimary,
                  fontSize: SizeConfig.textMultiplier * 2.5),
            ),
          ),
          onChanged: (newVal) {
            setState(() {
              _mySelection=newVal.toString();

            });
          },
          value: _mySelection,
        ),
      ),
    );
  }

  getCurrentUser() async {
    prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if (userid != null) {

      getBankDetail(userid);

      /*if (prefs.getString('bank_name') != null) {

        name!.text = prefs.getString('bank_name')!;
        acc_no!.text = prefs.getString('acc_no')!;
        ifsc!.text = prefs.getString('ifsc')!;
        _mySelection = prefs.getString('acc_type')!;
        acc_status = prefs.getString('acc_status');
        setState(() {

        });

      } else {
        getBankDetail(userid);
      }*/

    } else {
      setState(() {
        userLoginCheck = -1;
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();

    namenode= FocusNode();
    accnonode = FocusNode();
    ifscnode = FocusNode();

    name =TextEditingController();
    acc_no =TextEditingController();
    ifsc =TextEditingController();

    super.initState();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  getBankDetail(String? userid) async {
    setState(() {
      loading = true;
    });
    String url = 'http://www.aksdute.com/tsgames/get_bank_detail.php';
    dpack.FormData newData = new dpack.FormData.fromMap({'userid': userid});
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (value.data != null) {
          List data = jsonDecode(value.data);
          for (var i in data) {
            name!.text = i['name'].toString();
            acc_no!.text = i['acc_no'].toString();
            ifsc!.text = i['ifsc'].toString();
            _mySelection = i['acc_type'].toString();
            acc_status = i['acc_status'].toString();

          }
          setState(() {
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
            bloc!.blocSink.add('Something wronge, Check Internet Connection');
          });
        }
      }
    });
  }

  add_bankDetaile() async {
    setState(() {
      bloc!.blocSink.add(null);
      loading = true;
    });
    String url = 'http://www.aksdute.com/tsgames/add_bank_detail.php';
    dpack.FormData newData = new dpack.FormData.fromMap({

      'userid': userid,
      'name':name!.text,
      'acc_no':acc_no!.text,
      'ifsc':ifsc!.text,
      'type':_mySelection!

    });
    await new dpack.Dio().post(url, data: newData).then((value) {
      if (value.statusCode == 200) {
        if (jsonDecode(value.data).toString() == 'true') {
          /*setState(() {

            prefs.setString('bank_name', name!.text);
            prefs.setString('acc_no', acc_no!.text);
            prefs.setString('ifsc', ifsc!.text);
            prefs.setString('acc_type', _mySelection!);
            prefs.setString('acc_status', 'Pending');
            loading = false;

          });*/

          setState(() {
            loading = false;
            acc_status= 'Pending';
          });

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return GameClosedDialog(
                    'images/successful.json', 'Your details is saved', 15);
              });

        } else {
          setState(() {
            bloc!.blocSink.add('Something wronge, Check Internet Connection');
            loading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {

    namenode!.dispose();
    accnonode!.dispose();
    ifscnode!.dispose();
    name!.dispose();
    acc_no!.dispose();
    ifsc!.dispose();
    bloc!.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return Scaffold(
        appBar: AppBar(
          title: Gtext(
            'Bank Details',
            2,
            color: Colors.black,
            bold: true,
          ),
          iconTheme: IconThemeData(color: ColorSystem.kprimary),
          backgroundColor: Color(0xFFC9D6FF),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              size: 3.5 * SizeConfig.heightMultiplier,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC9D6FF),
                  Color(0xFFE2E2E2)
                ],
              ),
            ),
            child: Card(
              borderOnForeground: true,
              elevation: 5,
              color: Colors.white,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        Gtext(
                          'Note:- Fill your account information correctly because your winning amount will be transfer to this account within 24-36 hours / अपने खाता की जानकारी सही ढंग से भरे और बार बार ना बदले क्योकि आपके खाता को अपडेट होने में 24 से 36 घंटे लगते है |',
                          1.3,
                          color: Colors.black45,
                          bold: true,
                        ),
                        SizedBox(height: 10,),

                        loading==false?
                        acc_status!=null?
                        acc_status=='Pending'?
                        Column(
                          children: [
                            Gtext(
                              '-- Pending --',
                              3,
                              color: Colors.red,
                              bold: true,
                            ),
                            SizedBox(height: 5,),
                            Gtext(
                              'Your Account status is pending/अभी आपका बैंक स्टेटस Pending है आप पैसे तब तक ट्रांसफर नहीं होंगे ',
                              1.3,
                              color: Colors.red,
                              bold: true,
                            ),
                          ],
                        ):
                        Column(
                          children: [
                            Gtext(
                              '-- Update --',
                              3,
                              color: Colors.green,
                              bold: true,
                            ),
                            SizedBox(height: 5,),
                            Gtext(
                              'Your Account status is update/आपका अकाउंट अपडेट हो चुका है ',
                              1.3,
                              color: Colors.green,
                              bold: true,
                            ),
                          ],
                        ):SizedBox():
                        SizedBox(),


                        TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Account Holder Name *",
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.text,
                            controller: name,
                            focusNode: namenode,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, namenode!, accnonode!);
                            }),
                        SizedBox(
                          height: 3 * SizeConfig.heightMultiplier,
                        ),

                        TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Account Number *",
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.phone,
                            controller: acc_no,
                            focusNode: accnonode,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, accnonode!, ifscnode!);
                            }),

                        SizedBox(
                          height: 3 * SizeConfig.heightMultiplier,
                        ),

                        TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Ifsc Code *",
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.text,
                            controller: ifsc,
                            focusNode: ifscnode,
                            autofocus: false,
                            textInputAction: TextInputAction.done
                            ),

                        SizedBox(
                          height: 3 * SizeConfig.heightMultiplier,
                        ),

                        DropDown(type_list),

                        SizedBox(
                          height: 3 * SizeConfig.heightMultiplier,
                        ),
                        StreamBuilder(
                            stream: bloc!.blocStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Gtext(
                                  snapshot.data.toString(),
                                  1.5,
                                  color: Colors.red,
                                  bold: true,
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                        SizedBox(
                          height: 2 * SizeConfig.heightMultiplier,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              if (name!.text.length != 0) {
                                if (acc_no!.text.length != 0) {

                                  if(ifsc!.text.length!=0){

                                    add_bankDetaile();

                                  }else{
                                    bloc!.blocSink.add('Please enter your Ifsc Code ');
                                  }
                                } else {
                                  bloc!.blocSink.add('Please enter your Account No. ');
                                }
                              } else {
                                bloc!.blocSink.add('Please enter you Name');
                              }
                            },
                            child: Gtext(
                              "Save Information",
                              2.5,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: ColorSystem.klight),
                          ),
                        ),
                        SizedBox(
                          height: 1 * SizeConfig.heightMultiplier,
                        ),
                      ],
                    ),
                  ),
                  loading == true
                      ? LoadingWidget("Updating your data...")
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
