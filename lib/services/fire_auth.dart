import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instagram/services/fire_storage.dart';
import 'package:flutter_instagram/utils/utils.dart';

class FireAuth {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List profileImage,
  }) async {
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          profileImage != null) {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);

        String profileImageURL = await FireStorage()
            .uploadImage("profile_images", profileImage, false);

        _firestore.collection("users").doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "username": username,
          "email": email,
          "bio": bio,
          "photoURL": profileImageURL,
          "followers": [],
          "following": [],
        });

        Utils.showToast("User registered successfully", false);
      }
    } catch (e) {
      Utils.showToast(e.toString(), true);
    }
  }
}
