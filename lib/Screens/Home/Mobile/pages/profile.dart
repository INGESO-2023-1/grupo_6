import 'dart:io';
import 'package:chattify/Screens/Login/Mobile/login.Mobile.dart';
import 'package:chattify/Services/auth.dart';
import 'package:chattify/Services/select_image.dart';
import 'package:chattify/Services/upload_image.dart';
import 'package:chattify/Utils/setting_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<ProfilePage> {
  File? imagen_to_upload;

  AuthService service = AuthService();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                    ),
                    imageProfile(),
                    Container(
                      width: 30,
                      child: Icon(
                        Icons.edit_road_outlined,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  _firebaseAuth.currentUser?.displayName ?? "Alan Cabezas",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  _firebaseAuth.currentUser?.email ?? "@sangvaleap",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SettingItem(
              title: "Appearance",
              leadingIcon: Icons.dark_mode_outlined,
              leadingIconColor: Colors.lightBlue,
              onTap: () {}),
          SizedBox(height: 10),
          SettingItem(
              title: "Notification",
              leadingIcon: Icons.notifications_outlined,
              leadingIconColor: Colors.red,
              onTap: () {}),
          SizedBox(height: 10),
          SettingItem(
              title: "Privacy",
              leadingIcon: Icons.privacy_tip_outlined,
              leadingIconColor: Colors.green,
              onTap: () {}),
          SizedBox(height: 10),
          SettingItem(
              title: "Change Password",
              leadingIcon: Icons.lock_outline_rounded,
              leadingIconColor: Colors.orange,
              onTap: () {}),
          SizedBox(height: 10),
          SettingItem(
            title: "Log Out",
            leadingIcon: Icons.logout_outlined,
            leadingIconColor: Colors.grey.shade400,
            onTap: () {
              showConfirmLogout();
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  showConfirmLogout() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
            message: Text("Would you like to log out?"),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  service.logOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginViewM()),
                      (route) => false);
                },
                child: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )));
  }

  Widget imageProfile() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage:
              imagen_to_upload == null ? null : FileImage(imagen_to_upload!),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomsheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28,
            ),
          ),
        )
      ],
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Column(
                  children: [
                    Icon(
                      Icons.camera,
                      color: Colors.black,
                      size: 25,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                label: Text(
                  '', //'Label',
                  style: TextStyle(
                    color: Colors.red,
                  ),
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

                  if (uploaded) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Imagen subida correctamente")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Error al subir")));
                  }
                },
                icon: Column(
                  children: [
                    Icon(
                      Icons.photo_library,
                      color: Colors.black,
                      size: 25,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                label: Text(
                  '', //'Label',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
