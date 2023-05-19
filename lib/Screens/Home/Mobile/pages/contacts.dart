import 'package:chattify/Services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chattify/Utils/global_colors.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<dynamic> userList = [];
  List<dynamic> filteredUserList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      final nombre = user['nombre'] as String;
      return nombre.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUserList = filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      appBar: buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: filterUsers,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUserList.length,
              itemBuilder: (context, index) {
                final usuario = filteredUserList[index] as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      //leading: CircleAvatar(
                      //backgroundImage: NetworkImage(usuario['imageUrl']),
                      //),
                      title: Text(
                        usuario['nombre'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Texto adicional',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
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

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFf5f5f5),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Contacts",
          style: TextStyle(
            color: GlobalColors.textColor,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
