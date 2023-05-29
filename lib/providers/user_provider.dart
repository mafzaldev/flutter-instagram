import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/services/fire_store.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final FireStoreService _fireStore = FireStoreService();
  User get user => _user!;

  Future<void> refreshUser() async {
    User newUser = await _fireStore.getUserDetails();
    _user = newUser;
    notifyListeners();
  }
}
