import 'package:chattify/pages/ChatRoom.dart';
import 'package:chattify/theme/gcolors.dart';
import 'package:chattify/services/get_users.dart';
import 'package:chattify/widgets/group_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:chattify/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> userList = [];
  List<dynamic> filteredUserList = [];
  List<int> groups = [1, 2, 3];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService service = AuthService();

  @override
  void initState() {
    super.initState();
    service.updateActiveStatus('Online');
    getUsersList();
  }

  void getUsersList() async {
    List<dynamic> users = await getUsers();
    setState(() {
      userList = users;
      filteredUserList = users;
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

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      service.updateActiveStatus("Online");
    } else {
      // offline
      service.updateActiveStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  getBody() {
    if (filteredUserList.isEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            getHeader(),
            const SizedBox(height: 300),
            const Center(
              child: Text(
                "Let's start chatting",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(children: [
          getHeader(),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Expanded(
                    child: Text("Groups",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600)),
                  ),
                  Text("See all",
                      style: TextStyle(
                          fontSize: 15,
                          color: GlobalColors.textColor1,
                          fontWeight: FontWeight.w400)),
                  Icon(Icons.arrow_right, color: GlobalColors.textColor1)
                ],
              )),
          getGroups(),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Chats",
              style: TextStyle(
                  fontSize: 21,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
          ),
          getRecents(),
        ]),
      );
    }
  }

  getHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 15, 15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _firebaseAuth.currentUser?.displayName ?? "N/A",
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Let's reach your friends!",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              ClipOval(
                child: Image.asset(
                  "assets/images/profile.jpg",
                  width: 40,
                  height: 40,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  getGroups() {
    return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 0),
        child: GroupSlider(cant: groups.length));
  }

  getRecents() {
    initializeDateFormatting();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredUserList.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 1);
      },
      itemBuilder: (context, index) {
        final usuario = filteredUserList[index] as Map<String, dynamic>;
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('chatroom')
              .doc(chatRoomId(
                _firebaseAuth.currentUser!.displayName!,
                usuario['name'],
              ))
              .collection('chats')
              .orderBy("time", descending: true)
              .limit(1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              Map<String, dynamic> lastMessage =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;

              Timestamp? timestamp = lastMessage['time'];

              // Verifica si el campo "time" es null
              if (timestamp != null) {
                DateTime dateTime = timestamp.toDate();
                String formattedTime = DateFormat('HH:mm').format(dateTime);
                return GestureDetector(
                  onTap: () {
                    String roomId = chatRoomId(
                      _firebaseAuth.currentUser!.displayName!,
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
                          offset: const Offset(1, 1),
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
                                    children: [
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
                                      Text(
                                        formattedTime,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    lastMessage['message'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: GlobalColors.textColor,
                                    ),
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
              }
              return Container();
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
