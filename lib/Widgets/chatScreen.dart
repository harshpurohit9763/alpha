import 'package:alpha/Widgets/txt_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/SearchPage.dart';

class ChatScreenMain extends StatefulWidget {
  final Map chatData;
  final String chatRoomId;

  ChatScreenMain({
    Key? key,
    required this.chatData,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  State<ChatScreenMain> createState() => _ChatScreenMainState();
}

class _ChatScreenMainState extends State<ChatScreenMain>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    getUserMap();
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    setStatus('Offline');
  }

  void setStatus(String status) async {
    await _firestore.collection('Users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  bool isLoading = false;
  Map? userMap;

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
        isLoading = false;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
//online
      setStatus(
        'Online',
      );
    } else {
//offline
      setStatus('offline');
    }
  }

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      print("This is chat data: ${widget.chatData}");
      await _firestore
          .collection("friends")
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: isLoading
              ? const Text("fetching...")
              : StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('Users')
                      .doc("${userMap?["uid"]}")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != Null) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${userMap?["full-name"]}"),
                            Text(
                              snapshot.data?['status'] == null
                                  ? 'fetching'
                                  : snapshot.data?['status'],
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: height * 0.75,
              width: width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('friends')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: height * 0.08,
                width: width,
                child: Row(
                  children: [
                    Container(
                      height: height * 0.05,
                      width: width * 0.75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all()),
                      child: Center(
                        child: TextFieldInput(
                            textEditingController: _message,
                            textInputType: TextInputType.text,
                            hintText: 'Message'),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Container(
                      child: Center(
                        child: IconButton(
                          onPressed: onSendMessage,
                          icon: Icon(
                            Icons.send,
                            size: 32,
                          ),
                        ),
                      ),
                      height: height * 0.05,
                      width: width * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ));
  }

  Widget messages(Map<String, dynamic> map, BuildContext context) {
    return Container(
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: map['sendby'] == _auth.currentUser!.displayName
              ? LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.purple,
                    Colors.deepPurple,
                    Colors.deepPurpleAccent
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.pink, Colors.pinkAccent, Colors.redAccent],
                ),
          color: Colors.black,
        ),
        child: Text(
          map['message'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
