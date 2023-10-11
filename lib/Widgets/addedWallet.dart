import 'package:flutter/material.dart';
import 'package:tusharsonigames/IconDart/wallet_icon_icons.dart';
import 'package:tusharsonigames/Widgets/Gtext.dart';

import '../appColor.dart';
import '../size_config.dart';

class WalletDetails extends StatelessWidget {
  int? added, withdraw;
  double? ref_earn;

  WalletDetails(this.added, this.withdraw, this.ref_earn);

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      elevation: 5,
      color: Colors.transparent,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(5),
      ),
      child: Container(
        width: double.infinity,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(5)
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF83a4d4),
              Color(0xFF83a4d4)

            ],
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Gtext(
                  'Added\nMoney',
                  1.3,
                  color: Colors.white,

                ),
                SizedBox(height: 10,),
                Gtext(
                  '  \u20b9' + added.toString() + '  ',
                  2.5,
                  color: Colors.black,
                )
              ],
            ),
            Column(
              children: [
                Gtext(
                  'Winning\nMoney',
                  1.3,
                  color: Colors.white,
                ),
                SizedBox(height: 10,),
                Gtext(
                  '  \u20b9' + withdraw.toString() + '  ',
                  2.5,
                  color: Colors.black,
                )
              ],
            ),
            Column(
              children: [
                Gtext(
                  'Earning\nMoney',
                  1.3,
                  color: Colors.white,
                ),
                SizedBox(height: 10,),
                Gtext(
                  '  \u20b9' + ref_earn.toString() + '  ',
                  2.5,
                  color: Colors.black,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
