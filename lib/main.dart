import 'package:alpha/Ui/colors.dart';
import 'package:alpha/helper/conditional_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/before_sign_in/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Alpha());
}

class Alpha extends StatefulWidget {
  const Alpha({super.key});

  @override
  State<Alpha> createState() => _AlphaState();
}

class _AlphaState extends State<Alpha> {
  @override
  Widget build(BuildContext context) {
    var Api = false;
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: Conditional(),
    );
  }
}
