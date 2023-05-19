import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(
  File image,
) async {
  final String fotouser = image.path.split("/").last;

  final Reference ref = storage.ref().child("avatars").child(fotouser);

  final UploadTask uploadTask = ref.putFile(image);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  final String url = await snapshot.ref.getDownloadURL();

  if (snapshot.state == TaskState.success) {
    return true;
  }
  return false;
}
