import 'package:android_minor/ui/screens/welcome_screen.dart';
import 'package:android_minor/util/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../root_page.dart';

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Container(
            color: Colors.white,
          );
        } else {
          if (snapshot.hasData) {
            return RootPage(
              auth: Auth(),
            );
          } else {
            return WelcomeScreen();
          }
        }
      },
    );
  }
}
