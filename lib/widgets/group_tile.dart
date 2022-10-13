import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/chatScreen.dart';

String chatRoomId(String user1, String user2) {
  if (user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
    return "$user2$user1";
  } else {
    return "$user1$user2";
  }
}

class GroupTile extends StatefulWidget {
  final Map chatData;
  GroupTile({super.key, required this.chatData});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  Map? userMap;

  @override
  void initState() {
    super.initState();
    getUserMap();
  }

  getUserMap() async {
    setState(() {
      isLoading = true;
    });

    var receiverUid;
    for (int i = 0; i < 2; i++) {
      if (widget.chatData['participants'][i] != _auth.currentUser!.uid) {
        receiverUid = widget.chatData['participants'][i];
      }
    }
    await _firestore
        .collection("Users")
        .where("uid", isEqualTo: receiverUid)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        print("This is usermap $userMap");
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("It is chat data ${widget.chatData}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreenMain(
                      chatData: widget.chatData,
                      chatRoomId: chatRoomId(widget.chatData['sender'],
                          widget.chatData['reciever']),
                    )));
      },
      child: userMap == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.purple,
                        Colors.deepPurple,
                        Colors.deepPurpleAccent
                      ],
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png'),
                        radius: 45,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userMap!['full-name'],
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(TimeOfDay.now().hour.toString() +
                          ':' +
                          TimeOfDay.now().minute.toString() +
                          " " +
                          TimeOfDay.now().period.name),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
