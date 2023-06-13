import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsers() async {
  List users = [];
  CollectionReference collectionReferenceUsers = db.collection('users');
  QuerySnapshot queryUsers = await collectionReferenceUsers.get();

  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  queryUsers.docs.forEach((documento) {
    if (documento.id != currentUserId) {
      users.add(documento.data());
    }
  });

  return users;
}
