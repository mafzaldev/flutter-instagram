import 'dart:developer';

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

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> postComment(String postId, String uid, String username,
      String comment, String profilePic) async {
    String result = "";
    try {
      String commentId = const Uuid().v1();
      await _firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .set({
        "commentId": commentId,
        "uid": uid,
        "comment": comment,
        "username": username,
        "profilePic": profilePic,
        "datePublished": DateTime.now(),
      });
      result = "success";
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> deletePost(String postId) async {
    String result = "";
    try {
      await _firestore.collection("posts").doc(postId).delete();
      result = "success";
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot userDetailsSnapshot =
          await _firestore.collection('users').doc(uid).get();
      List following = (userDetailsSnapshot.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
