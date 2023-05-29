import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_instagram/models/user.dart' as user_model;
import 'package:flutter_instagram/models/post.dart';

import 'package:flutter_instagram/services/fire_storage.dart';
import 'package:uuid/uuid.dart';

class FireStoreService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<user_model.User> getUserDetails() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot userSnapshot =
        await _firestore.collection("users").doc(currentUser.uid).get();
    return user_model.User.fromSnap(userSnapshot);
  }

  Future<String> uploadPost(
    String caption,
    Uint8List image,
    String uid,
    String username,
    String profImage,
  ) async {
    String result = "";
    try {
      String photoUrl =
          await FireStorageService().uploadImage("posts", image, true);
      String postId = const Uuid().v1();
      Post post = Post(
          uid: uid,
          postId: postId,
          postUrl: photoUrl,
          username: username,
          caption: caption,
          likes: [],
          datePublished: DateTime.now(),
          profImage: profImage);
      _firestore.collection("posts").doc(postId).set(post.toJson());
      result = "success";
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
