import 'package:chattify/pages/login.dart';
import 'package:chattify/services/auth.dart';
import 'package:chattify/theme/gcolors.dart';
import 'package:chattify/services/get_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<dynamic> userList = [];
  List<dynamic> filteredUserList = [];
  late String _nombreUsuario = "";
  late String _correoUsuario = "";
  late String _contrasenaUsuario = "";

  AuthService service = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController searchController = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();
    getUserData();
    getUsersList();
  }

  void getUserData() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentReference documentRef =
          _firestore.collection('users').doc(userId);
      documentRef.get().then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            _nombreUsuario =
                (snapshot.data() as Map<String, dynamic>)['name'] ?? "";
          });
        }
      });
    } else {
      // El usuario no está autenticado
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String newName = _nombreUsuario;
                String newEmail = _correoUsuario;
                String newPassword = _contrasenaUsuario;

                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text("Create Profile"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          newName = value;
                        },
                        decoration: const InputDecoration(
                          labelText: "Name",
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          newEmail = value;
                        },
                        decoration: const InputDecoration(
                          labelText: "Email",
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          newPassword = value;
                        },
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "Create",
                        style: TextStyle(color: GlobalColors.textColor1),
                      ),
                      onPressed: () async {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: newEmail,
                            password: newPassword,
                          );
                          String userId = userCredential.user!.uid;

                          // Guardar información adicional en la Firebase Database
                          DocumentReference documentRef =
                              _firestore.collection('users').doc(userId);
                          documentRef.set({
                            "name": newName,
                            "email": newEmail,
                            "status": "Unavailable",
                            "uid": _firebaseAuth.currentUser!.uid,
                            "image": "photoUrl",
                          });

                          setState(() {
                            _nombreUsuario = newName;
                            _correoUsuario = newEmail;
                            _contrasenaUsuario = newPassword;
                          });

                          Navigator.of(context).pop();
                        } catch (e) {
                          print("Error al crear el usuario: $e");
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: GlobalColors.textColor1,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 15, 5),
              decoration: const BoxDecoration(),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Text(
                    "Admin Page",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        showConfirmLogout();
                      },
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  )),
                ],
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
              child: Center(
                child: FutureBuilder(
                  future: getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<dynamic> userList = snapshot.data as List<dynamic>;
                      userList.sort((a, b) =>
                          (a["name"] as String).compareTo(b["name"] as String));

                      return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          String name = userList[index]['name'] as String;
                          String email = userList[index]['email'] as String;
                          String uid = userList[index]['uid'] as String;
                          final usuario =
                              filteredUserList[index] as Map<String, dynamic>;
                          return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Delete User",
                                              style: TextStyle(),
                                            ),
                                            const SizedBox(height: 20.0),
                                            const Text(
                                                "Are you sure you want to delete this user?"),
                                            const SizedBox(height: 20.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: GlobalColors
                                                            .textColor1),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: GlobalColors
                                                            .textColor1),
                                                  ),
                                                  onPressed: () async {
                                                    String userId =
                                                        usuario["uid"];
                                                    _firestore
                                                        .collection('users')
                                                        .doc(userId)
                                                        .delete();

                                                    getUsersList();

                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String newName = _nombreUsuario;

                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: const Text("Edit name"),
                                        content: TextField(
                                          onChanged: (value) {
                                            newName = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              "Update",
                                              style: TextStyle(
                                                  color:
                                                      GlobalColors.textColor1),
                                            ),
                                            onPressed: () {
                                              DocumentReference documentRef =
                                                  _firestore
                                                      .collection('users')
                                                      .doc(uid);
                                              documentRef
                                                  .update({"name": newName});
                                              setState(() {
                                                _nombreUsuario = newName;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                email,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: GlobalColors.textColor,
                                                ),
                                              ),
                                            ],
                                          ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ));
  }

  showConfirmLogout() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
            message: const Text("Would you like to log out?"),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  service.logOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Color(0xFFe54140)),
                ),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )));
  }
}
