import 'dart:io';
import 'package:chattify/services/auth.dart';
import 'package:chattify/services/select_image.dart';
import 'package:chattify/services/upload_image.dart';
import 'package:chattify/theme/gcolors.dart';
import 'package:chattify/widgets/setting_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

import 'login.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  File? imagen_to_upload;
  AuthService service = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                imageProfile(),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  _firebaseAuth.currentUser?.displayName ?? "N/A",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _firebaseAuth.currentUser?.email ?? "N/A",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SettingItem(
              title: "Appearance",
              leadingIcon: Icons.dark_mode_outlined,
              leadingIconColor: Colors.lightBlue,
              onTap: () {}),
          const SizedBox(height: 10),
          SettingItem(
              title: "Notification",
              leadingIcon: Icons.notifications_outlined,
              leadingIconColor: Colors.red,
              onTap: () {}),
          const SizedBox(height: 10),
          SettingItem(
              title: "Privacy",
              leadingIcon: Icons.privacy_tip_outlined,
              leadingIconColor: Colors.green,
              onTap: () {}),
          const SizedBox(height: 10),
          SettingItem(
            title: "Log Out",
            leadingIcon: Icons.logout_outlined,
            leadingIconColor: Colors.grey.shade400,
            onTap: () {
              showConfirmLogout();
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: imagen_to_upload != null
                ? Image.file(
                    imagen_to_upload!,
                    height: 120,
                    width: 120,
                  )
                : Image.asset(
                    "assets/images/profile.jpg",
                    width: 120,
                    height: 120,
                  ),
          ),
          Positioned(
              bottom: 10,
              right: 20,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: GlobalColors.textColor1,
                  size: 24,
                ),
              )),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                label: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final imagen = await getImage();
                  setState(() {
                    imagen_to_upload = File(imagen!.path);
                  });

                  if (imagen_to_upload == null) {
                    return;
                  }
                  final uploaded = await uploadImage(imagen_to_upload!);
                  _firestore
                      .collection("users")
                      .doc(_firebaseAuth.currentUser!.uid)
                      .update({"image": uploaded});
                },
                icon: const Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                label: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
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
