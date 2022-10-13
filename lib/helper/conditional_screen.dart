import 'package:alpha/Screens/after_sign_in/MainScreen.dart';
import 'package:alpha/Screens/before_sign_in/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Conditional extends StatefulWidget {
  const Conditional({super.key});

  @override
  State<Conditional> createState() => _ConditionalState();
}

class _ConditionalState extends State<Conditional> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return MainScreen();
          } else {
            return SignUpScreen();
          }
        },
      ),
    );
  }
}
