import 'package:chattify/Screens/Home/Mobile/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:chattify/Utils/global_colors.dart';

import 'pages/chat.dart';
import 'pages/contacts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  final List<Widget> _tabList = [ChatPage(), ContactPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _tabList.elementAt(_pageIndex),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: const Alignment(0.0, 1.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: BottomNavigationBar(
                  selectedItemColor: GlobalColors.textColor1,
                  unselectedItemColor: Colors.grey[500],
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  currentIndex: _pageIndex,
                  backgroundColor: Colors.white,
                  onTap: (int index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.message), label: "Chat"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.contacts), label: "Contacts"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: "Profile"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
