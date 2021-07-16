import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:udhar_app/Components/navigaton_bar.dart';
import 'package:udhar_app/Notifiers/event_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:udhar_app/Notifiers/transaction_notifier.dart';
import 'Notifiers/auth_notifier.dart';
import 'Screens/login_screen.dart';
import 'package:udhar_app/Screens/cal_screen.dart';

import 'Screens/transaction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthNotifier()),
    ChangeNotifierProvider(create: (context) => TransactionNotifier()),
    ChangeNotifierProvider(create: (context) => EventNotifier()),
  ], child: UdharApp()));
}

class UdharApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
          textTheme:
              GoogleFonts.ralewayTextTheme().apply(bodyColor: Colors.white)),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Consumer<AuthNotifier>(
          builder: (context, notifier, child) {
            // ignore: unnecessary_null_comparison
            return notifier.user != null ? CalScreen() : LoginScreen();
          },
        ),
      ),
    );
  }
}
