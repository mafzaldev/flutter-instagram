import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/services/fire_auth.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final FireAuth _auth = FireAuth();
  User get user => _user!;

  Future<void> refreshUser() async {
    User newUser = await _auth.getUserDetails();
    _user = newUser;
    notifyListeners();
  }
}
