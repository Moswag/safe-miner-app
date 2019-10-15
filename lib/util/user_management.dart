import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/ui/screens/admin/view_admins.dart';
import 'package:android_minor/ui/screens/app_admin/view_companies.dart';
import 'package:android_minor/ui/screens/employee/view_safety_rules.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'no_rights.dart';
import 'state_widget.dart';

class UserManagement {
  authoriseAccess(BuildContext context) async {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.document("users/${user.uid}").get().then((doc) {
        if (doc.exists) {
          print(doc.data['role'] + 'is the role');
          if (doc.data['role'] == AppConstants.USER_APP_ADMIN) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new ViewCompanies()));
          } else if (doc.data['role'] == AppConstants.USER_COMPANY_ADMIN) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new ViewAdminsInCompany()));
          } else if (doc.data['role'] == AppConstants.USER_EMPLOYEE) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    new EmployeeViewSafetyRules()));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => new NoRightsPage()));
          }
        }
      });
    });
  }

  signOut(BuildContext context) {
    StateWidget.of(context).logOutUser();
  }
}
