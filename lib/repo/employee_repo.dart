import 'dart:async';

import 'package:android_minor/constants/db_constants.dart';
import 'package:android_minor/models/breakage.dart';
import 'package:android_minor/models/state.dart';
import 'package:android_minor/models/survey.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeRepo {
  static StateModel appState;

  static Future<bool> addBreakage(Breakage breakage) async {
    try {
      Firestore.instance
          .document("${DBConstants.DB_BREAKAGES}/${breakage.id}")
          .setData(breakage.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addSurvey(Survey survey) async {
    try {
      Firestore.instance
          .document("${DBConstants.DB_SURVEY}/${survey.id}")
          .setData(survey.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }
}
