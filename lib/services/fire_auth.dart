// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instagram/models/user.dart' as user_model;
import 'package:flutter_instagram/services/fire_storage.dart';

class FireAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String result = "";

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List profileImage,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photoUrl = await FireStorageService()
          .uploadImage("profile_images", profileImage, false);

      user_model.User user = user_model.User(
          username: username,
          uid: userCredential.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: []);

      _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(user.toJson());

      result = "success";
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        result = "The password provided is too weak";
      } else if (err.code == 'email-already-in-use') {
        result = "The account already exists for that email";
      } else if (err.code == 'invalid-email') {
        result = "The email address is not valid";
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        log("User logged in successfully with email: ${userCredential.user!.email}");
        result = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        result = "No user found for that email";
      } else if (err.code == 'wrong-password') {
        result = "Wrong password provided for that user";
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
