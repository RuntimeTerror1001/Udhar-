import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhar_app/Components/calendar-widget.dart';
import 'package:udhar_app/Notifiers/auth_notifier.dart';
import 'package:udhar_app/Screens/eventForm_screen.dart';
import 'package:udhar_app/Screens/transaction_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:udhar_app/API/auth_api.dart';

class CalScreen extends StatefulWidget {
  @override
  _CalScreenState createState() => _CalScreenState();
}

class _CalScreenState extends State<CalScreen> {
  int selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print('Building Calendar Screen');
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
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
      body: Container(
        child: CalendarWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Icon(Icons.add),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventForm()));
        },
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
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => CalScreen()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TransactionScreen()));
          }
        },
        letIndexChange: (index) => true,
        animationCurve: Curves.easeInBack,
        animationDuration: Duration(milliseconds: 300),
      ),
    );
  }
}
