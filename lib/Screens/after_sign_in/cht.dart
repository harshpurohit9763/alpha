import 'package:alpha/Ui/colors.dart';
import 'package:alpha/Widgets/txt_field.dart';
import 'package:alpha/utils/SearchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../widgets/group_tile.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? userMap;

  ChatScreen({
    super.key,
    this.userMap,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Map<String, dynamic>? userMap;

  final TextEditingController _addChat = TextEditingController();

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SearchPage()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadchat();
  }

  bool isLoading = false;
  List chatList = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void loadchat() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("friends")
        .where("participants", arrayContainsAny: [_auth.currentUser!.uid])
        .get()
        .then((value) {
          final chats = value.docs
              .map((doc) => {
                    "id": doc.id,
                    "data": doc.data(),
                  })
              .toList();

          setState(() {
            chatList = chats;
          });
        });
    setState(() {
      isLoading = false;
      print('this is data of chat list  $chatList');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _navigateToNextScreen(context);
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text(
          "Alpha",
          style: Text1,
        ),
      ),
      body: isLoading
          ? Center(
              child: Text('Searching'),
            )
          : chatList == null || chatList.isEmpty
              ? Center(
                  child: Text('no chatsfound'),
                )
              : ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GroupTile(chatData: chatList[index]["data"]);
                  },
                ),
    );
  }
}
