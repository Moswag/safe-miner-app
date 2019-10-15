import 'package:android_minor/ui/screens/admin/view_admins.dart';
import 'package:android_minor/ui/screens/app_admin/view_companies.dart';
import 'package:android_minor/ui/screens/sign_in_screen.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/state_widget.dart';
import 'package:flutter/material.dart';

import 'constants/app_constants.dart';
import 'models/state.dart';
import 'ui/screens/employee/view_safety_rules.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  StateModel appState;
  bool _loadingVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }

      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';
      final name = appState?.user?.name ?? '';
      final role = appState?.user?.role ?? '';
      final companyId = appState?.user?.companyId ?? '';

      switch (authStatus) {
        case AuthStatus.notSignedIn:
          return new SignInScreen(
            auth: widget.auth,
            onSignedIn: _signedIn,
          );

        case AuthStatus.signedIn:
          if (role == AppConstants.USER_APP_ADMIN) {
            return ViewCompanies();
          } else if (role == AppConstants.USER_COMPANY_ADMIN) {
            return ViewAdminsInCompany();
          } else if (role == AppConstants.USER_EMPLOYEE) {
            return EmployeeViewSafetyRules();
          } else {
            return CircularProgressIndicator();
          }
      }
    }
  }
}
