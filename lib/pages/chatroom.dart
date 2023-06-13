import 'package:chattify/theme/gcolors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatroom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  chatroom({required this.chatRoomId, required this.userMap});

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
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlobalColors.textColor1,
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection("users").doc(userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/images/profile.jpg",
                          width: 35,
                          height: 35,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userMap["name"]),
                          if (snapshot.data != null)
                            Text(
                              snapshot.data!['status'],
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 15),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatRoomId)
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
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50)),
                      child: TextField(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.grey,
                        controller: _message,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type your message...",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 17),
                            contentPadding: EdgeInsets.only(left: 20)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Ink(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: GlobalColors.textColor1, width: 0),
                          color: GlobalColors.textColor1,
                          borderRadius: BorderRadius.circular(40)),
                      child: IconButton(
                        onPressed: onSendMessage,
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    final bool isCurrentUser = map['sendby'] == _auth.currentUser!.displayName;

    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment:
                isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:
                    isCurrentUser ? GlobalColors.textColor1 : Colors.grey[300],
              ),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: map['message'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isCurrentUser ? Colors.white : Colors.black87,
                  ),
                ),
                const TextSpan(text: "   "),
                TextSpan(
                  text: _formatTimestamp(map['time']),
                  style: TextStyle(
                    fontSize: 13,
                    color: isCurrentUser ? Colors.white : Colors.black87,
                  ),
                ),
              ])),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment:
                isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final DateTime dateTime = timestamp.toDate();
      final String formattedTime =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return formattedTime;
    }
    return '';
  }
}
