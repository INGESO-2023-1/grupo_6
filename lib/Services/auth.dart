import 'dart:math';

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

class AuthService {
  String? pushToken;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<String?> getFirebaseMessagingToken() async {
    String? pushToken;
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await firebaseMessaging.getToken().then((value) {
      if (value != null) {
        pushToken = value;
        print(value);
      }
    });
    return pushToken;
  }

  Future signInWithEmailPassword(String email, String password) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      print(result.user);
      return {"status": true, "message": "success", "data": result.user};
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return {"status": false, "message": e.message.toString(), "data": ""};
    }
  }

  Future<void> sendPushNotification(
      String ptoken, String uname, String msg) async {
    try {
      final body = {
        "to": ptoken,
        "notification": {"title": uname, "body": msg}
      };
      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAJ6OYcyg:APA91bFIIfV6fNtP8U6Be5JeCqdAFa_5czoaNWL9coTcyhYgMTuXiny4vtporORLvnUxnl9Z18a2pFPsg66U2Pfu92XaJXWNOF4UBja1TYgqKbrrYakAOafeyGGDzEk0zCZruS6fBgbH'
          },
          body: jsonEncode(body));
      print('Response Status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('In sendPushNotification$e');
    }
  }

  Future registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      String? token = await getFirebaseMessagingToken();
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      User? user = res.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(_firebaseAuth.currentUser!.uid)
            .set({
          "name": name,
          "email": email,
          "status": "Unavailable",
          "uid": _firebaseAuth.currentUser!.uid,
          "image": "photoUrl",
          "password": password,
          "pushToken": token,
        });
      }
      print(res);
      res.user?.updateDisplayName(name);
      return {"status": true, "message": "success", "data": res.user};
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return {"status": false, "message": e.message.toString(), "data": ""};
    }
  }

  Future<void> updateActiveStatus(String isOnline) async {
    String? pushToken = await getFirebaseMessagingToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({'status': isOnline, 'pushToken': pushToken});
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
