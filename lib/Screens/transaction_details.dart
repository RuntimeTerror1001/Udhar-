import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:udhar_app/API/trans_api.dart';
import 'package:udhar_app/Notifiers/transaction_notifier.dart';
import 'package:udhar_app/Screens/trans_form.dart';
import 'package:udhar_app/Screens/transaction_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils.dart';

class TransactionDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Printing Detail Screen');
    TransactionNotifier transactionNotifier =
        Provider.of<TransactionNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        centerTitle: true,
        title: 'UDHAR'.text.make(),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: VStack(
          [
            ('${transactionNotifier.currTrans.name}')
                .text
                .xl3
                .color(Colors.tealAccent)
                .textStyle(GoogleFonts.raleway())
                .makeCentered(),
            50.heightBox,
            'Total Amt Due :    Rs. ${transactionNotifier.currTrans.amt}'
                .text
                .color(Colors.white)
                .minFontSize(20)
                .make(),
            50.heightBox,
            '${transactionNotifier.currTrans.meth}'
                .text
                .color(transactionNotifier.currTrans.meth == 'Credited'
                    ? Colors.blue
                    : Colors.redAccent)
                .minFontSize(20)
                .make(),
            50.heightBox,
            Row(
              children: [
                'Transaction Date : '
                    .text
                    .white
                    .textStyle(TextStyle(fontSize: 20))
                    .make(),
                5.widthBox,
                (Utils.toDateTime(transactionNotifier.currTrans.date.toDate()))
                    .toString()
                    .text
                    .white
                    .textStyle(TextStyle(fontSize: 18))
                    .make(),
              ],
            ),
            375.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  heroTag: 'heroTag1',
                  onPressed: () {
                    deleteTrans(transactionNotifier.currTrans);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionScreen()));
                  },
                  child: Center(child: Icon(Icons.delete, color: Colors.white)),
                ),
                FloatingActionButton(
                  heroTag: 'heroTag 2',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransForm(isUpdating: true)));
                  },
                  child: Center(child: Icon(Icons.edit)),
                ),
              ],
            ),
          ],
        ).scrollVertical(),
      ),
    );
  }
}
