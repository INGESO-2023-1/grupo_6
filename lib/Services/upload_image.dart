import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<Object> uploadImage(File image) async {
  final String nameFile = image.path.split("/").last;

  final Reference ref = storage.ref().child("images").child(nameFile);
  final UploadTask uploadTask = ref.putFile(image);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  final String url = await snapshot.ref.getDownloadURL();

  if (snapshot.state == TaskState.success) {
    return url;
  }
  return false;
}
