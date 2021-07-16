import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:udhar_app/Screens/cal_screen.dart';
import 'package:udhar_app/Screens/transaction_screen.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final screens = [CalScreen(), TransactionScreen()];

  @override
  Widget build(BuildContext context) {
    // return BottomNavyBar(
    //   containerHeight: 70,
    //   backgroundColor: Colors.black,
    //   onItemSelected: (index) => setState(() => this.selectedIndex = index),
    //   items: [
    //     BottomNavyBarItem(
    //       icon: Icon(Icons.calendar_today),
    //       title: Text('Calendar'),
    //       activeColor: Colors.white,
    //     ),
    //     BottomNavyBarItem(
    //       icon: Icon(Icons.list),
    //       title: Text('Transactions'),
    //       activeColor: Colors.white,
    //     ),
    //   ],
    // );
    return CurvedNavigationBar(
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
    );
  }
}
