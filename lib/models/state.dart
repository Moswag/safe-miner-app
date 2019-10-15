import 'package:android_minor/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'settings.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
  });
}
