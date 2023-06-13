import 'package:chattify/pages/contacts.dart';
import 'package:chattify/pages/setting.dart';
import 'package:chattify/theme/gcolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return auth.currentUser != null ? goHome() : const LoginPage();
  }

  int activeTab = 0;
  goHome() {
    return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        bottomNavigationBar: getBottomBar(),
        body: getBarPage());
  }

  Widget getBottomBar() {
    return Container(
      alignment: Alignment.center,
      height: 55,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black87.withOpacity(0.1),
                blurRadius: .5,
                spreadRadius: .5,
                offset: const Offset(0, 1))
          ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: BottomNavigationBar(
          selectedItemColor: GlobalColors.textColor1,
          unselectedItemColor: Colors.grey[500],
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: activeTab,
          backgroundColor: Colors.white,
          onTap: (int index) {
            setState(() {
              activeTab = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.contacts), label: "Contacts"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget getBarPage() {
    return IndexedStack(
      index: activeTab,
      children: const <Widget>[HomePage(), ContactPage(), SettingPage()],
    );
  }
}
