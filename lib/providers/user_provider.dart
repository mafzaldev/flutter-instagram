import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart' as model_user;
import 'package:flutter_instagram/services/fire_auth.dart';
import 'package:flutter_instagram/services/fire_store.dart';

class UserProvider with ChangeNotifier {
  model_user.User? _user;
  final FireStoreService _fireStore = FireStoreService();
  model_user.User get user => _user!;

  Future<void> refreshUser() async {
    model_user.User newUser = await _fireStore.getUserDetails();
    _user = newUser;
    notifyListeners();
  }

  Future<void> logout() async {
    await FireAuthService().signOut();
    _user = null;

    notifyListeners();
  }
}
