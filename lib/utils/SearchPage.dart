import 'package:alpha/Widgets/chatScreen.dart';
import 'package:alpha/Widgets/txt_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController searchPerson = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  String chatRoomId(user1, user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void startChat() async {
    String roomid =
        chatRoomId(_auth.currentUser?.displayName, userMap?['full-name']);
    Map<String, dynamic> data = {
      "participants": [_auth.currentUser!.uid, userMap?['uid']],
      "reciever": userMap?['full-name'],
      'sender': _auth.currentUser!.displayName,
    };

    await _firestore.collection("friends").doc(roomid).set(data);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((_) => ChatScreenMain(chatData: data, chatRoomId: roomid)),
      ),
    );
  }

  onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection("Users")
        .where("phone-number", isEqualTo: searchPerson.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(' this is the value of user map $userMap');
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              width: width * 0.7,
              child: TextFieldInput(
                textEditingController: searchPerson,
                textInputType: TextInputType.text,
                hintText: "Enter phone Number",
              ),
            ),
            IconButton(onPressed: onSearch, icon: Icon(Icons.search)),
          ],
        ),
        const SizedBox(
          height: 100,
        ),
        userMap != null
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.purple[200],
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Text(userMap!["full-name"]),
                  subtitle: Text(userMap!["phone-number"]),
                  trailing: GestureDetector(
                    onTap: startChat,
                    child: Container(
                      height: height * 0.1,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                          color: Colors.purple[300],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all()),
                      child: const Center(
                        child: Text("Add"),
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: Container(
                height: 100,
                width: 100,
              ))
      ]),
    ));
  }
}
