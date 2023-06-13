import 'package:chattify/pages/ChatRoom.dart';
import 'package:chattify/services/get_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with WidgetsBindingObserver {
  List<dynamic> userList = [];
  List<dynamic> filteredUserList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    getUsersList();
  }

  void getUsersList() async {
    List<dynamic> users = await getUsers();
    setState(() {
      userList = users;
      filteredUserList = users;
      filteredUserList.sort((a, b) => a["name"].compareTo(b["name"]));
    });
  }

  void filterUsers(String query) {
    List<dynamic> filteredUsers = userList.where((user) {
      final nombre = user['name'] as String;
      return nombre.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUserList = filteredUsers;
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1.toLowerCase().codeUnitAt(0) > user2.toLowerCase().codeUnitAt(0)) {
      return "$user1$user2";
    }
    return "$user2$user1";
  }

  void setStatus(String status) async {
    await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 15, 5),
            decoration: const BoxDecoration(),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Contacts",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              controller: searchController,
              onChanged: filterUsers,
              cursorColor: Colors.grey,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUserList.length,
              itemBuilder: (context, index) {
                final usuario = filteredUserList[index] as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    String roomId = chatRoomId(
                      _auth.currentUser!.displayName!,
                      usuario['name'],
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            chatroom(chatRoomId: roomId, userMap: usuario),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/images/profile.jpg",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          usuario["name"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 10,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 3),
                                      //Container date
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
