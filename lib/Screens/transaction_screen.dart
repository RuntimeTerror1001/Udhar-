import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:udhar_app/API/auth_api.dart';
import 'package:udhar_app/API/trans_api.dart';
import 'package:udhar_app/Models/transaction.dart';
import 'package:udhar_app/Notifiers/auth_notifier.dart';
import 'package:udhar_app/Notifiers/transaction_notifier.dart';
import 'package:udhar_app/Screens/trans_form.dart';
import 'package:udhar_app/Screens/transaction_details.dart';
import 'package:velocity_x/velocity_x.dart';

import 'cal_screen.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int selectedIndex = 1;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    TransactionNotifier transactionNotifier =
        Provider.of<TransactionNotifier>(context, listen: false);
    getTransactions(transactionNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TransactionNotifier transNotifier =
        Provider.of<TransactionNotifier>(context);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: 'UDHAR'.text.make(),
          actions: [
            IconButton(
                onPressed: () {
                  signout(authNotifier);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransForm(
                          isUpdating: false,
                        )));
          },
          child: Center(child: Icon(Icons.add, color: Colors.black)),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: Colors.black26,
          color: Colors.black,
          index: selectedIndex,
          items: <Widget>[
            Icon(
              Icons.calendar_today,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.list_outlined,
              size: 25,
              color: Colors.white,
            ),
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            if (selectedIndex == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CalScreen()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TransactionScreen()));
            }
          },
          letIndexChange: (index) => true,
          animationCurve: Curves.easeInBack,
          animationDuration: Duration(milliseconds: 300),
        ),
        body: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            Trans trans = transNotifier.transList[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.transparent,
                shadowColor: Colors.white60,
                child: ListTile(
                  title: Text('${trans.name}',
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Theme.of(context).accentColor)),
                  subtitle: Text('Rs. ${trans.amt}',
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.white54)),
                  onTap: () {
                    transNotifier.currTrans = trans;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionDetails()));
                  },
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.transparent);
          },
          itemCount: transNotifier.transList.length,
        ),
      ),
    );
  }
}
