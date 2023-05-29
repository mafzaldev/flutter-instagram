import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FireStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(
      String childName, Uint8List image, bool isPost) async {
    Reference firebaseStorageRef =
        _firebaseStorage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      firebaseStorageRef = firebaseStorageRef.child(id);
    }

    await firebaseStorageRef.putData(image);
    String downloadURL = await firebaseStorageRef.getDownloadURL();
    return downloadURL;
  }
}
