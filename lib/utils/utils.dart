import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/add_post_screen.dart';
import 'package:flutter_instagram/screens/home_feed_screen.dart';
import 'package:flutter_instagram/screens/profile_screen.dart';
import 'package:flutter_instagram/screens/search_Screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF818181),
        textColor: Colors.white,
        fontSize: 13.0);
  }

  static pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: source,
    );

    if (file != null) {
      return await file.readAsBytes();
    }
    showToast("Error occured while picking image!");
  }

  static final homeScreenItems = [
    const HomeFeedScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const Center(
      child: Text("TODO: to be implemented!"),
    ),
    ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
}
