import 'package:alpha/Screens/after_sign_in/cht.dart';
import 'package:alpha/Ui/colors.dart';
import 'package:alpha/Widgets/chatScreen.dart';
import 'package:alpha/helper/authentication.dart';
import 'package:alpha/utils/SearchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/conditional_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        children: [ChatScreen()],
      ),
    );
  }
}
