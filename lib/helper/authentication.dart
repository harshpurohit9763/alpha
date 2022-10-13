import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String fullName,
      required String phoneNumber,
      Uint8List? image}) async {
    String res = 'An Error Has Occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          fullName.isNotEmpty ||
          phoneNumber.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // print(cred.user!.uid);
        await cred.user!.updateDisplayName(fullName);

        await _firestore.collection('Users').doc(cred.user!.uid).set({
          'email': email,
          'uid': cred.user!.uid,
          'phone-number': phoneNumber,
          'full-name': fullName,
          'status': 'unavalible'
        });
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//login user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter the details properly";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
