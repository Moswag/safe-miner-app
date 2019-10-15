import 'dart:async';

import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/db_constants.dart';
import 'package:android_minor/models/activity.dart';
import 'package:android_minor/models/breakage.dart';
import 'package:android_minor/models/breakage_account.dart';
import 'package:android_minor/models/company_rules.dart';
import 'package:android_minor/models/location.dart';
import 'package:android_minor/models/safety_rules.dart';
import 'package:android_minor/models/state.dart';
import 'package:android_minor/models/tool.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyAdminRepo {
  static StateModel appState;

  static Future<bool> addMap(Location location) async {
    try {
      Firestore.instance
          .document("${DBConstants.DB_LOCATION}/${location.id}")
          .setData(location.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addSafetyRule(SafetyRule safetyRule) async {
    try {
      Firestore.instance
          .document("${DBConstants.DB_SAFETY_RULES}/${safetyRule.id}")
          .setData(safetyRule.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addActivity(Activity activity) async {
    try {
      Firestore.instance
          .document("${DBConstants.DB_ACTIVITY}/${activity.id}")
          .setData(activity.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addCompanyRule(CompanyRule companyRule) async {
    try {
      Firestore.instance
          .document("${DBConstants.DB_COMPANY_RULES}/${companyRule.id}")
          .setData(companyRule.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addCompanyTool(Tool tool) async {
    try {
      Firestore.instance
          .document("${DBConstants.DB_TOOL}/${tool.id}")
          .setData(tool.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateBreakage(Breakage breakage, final index) async {
    try {
      print("updating todo");
      if (breakage.status == AppConstants.TOOL_NOT_FINED) {
        Firestore.instance.runTransaction((Transaction transaction) async {
          DocumentSnapshot snapshot = await transaction.get(index);
          await transaction.update(snapshot.reference, {
            "status": breakage.status,
            "reason": breakage.reason,
          });
        });
      } else {
        Firestore.instance.runTransaction((Transaction transaction) async {
          DocumentSnapshot snapshot = await transaction.get(index);
          await transaction.update(snapshot.reference, {
            "status": breakage.status,
          });
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static getTool(String toolId) {
    return Firestore.instance
        .collection(DBConstants.DB_TOOL)
        .where('id', isEqualTo: toolId)
        .limit(1)
        .getDocuments();
  }

  static Future<bool> addBreakageAccount(BreakageAccount account) async {
    checkBreakageAccountExists(account.id).then((value) {
      if (!value) {
        try {
          Firestore.instance
              .document("${DBConstants.DB_BREAKAGE_ACCOUNT}/${account.id}")
              .setData(account.toJson());

          return true;
        } catch (e) {
          return false;
        }
      } else {
        getBreakageAccount(account.id).then((QuerySnapshot snapshot) {
          if (snapshot.documents.isNotEmpty) {
            var empAccount = snapshot.documents[0].data;
            BreakageAccount acc = new BreakageAccount();
            acc.account = empAccount['account'] + account.account;
            acc.date = DateTime.now().toString();
            updateBreakageAccount(acc, snapshot.documents[0].reference);
            return true;
          } else {
            return false;
          }
        });
        return true;
      }
    });
    return true;
  }

  static Future<bool> checkBreakageAccountExists(String accountId) async {
    bool exists = false;
    try {
      await Firestore.instance
          .document("${DBConstants.DB_BREAKAGE_ACCOUNT}/$accountId")
          .get()
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static getBreakageAccount(String accountId) {
    return Firestore.instance
        .collection(DBConstants.DB_BREAKAGE_ACCOUNT)
        .where('id', isEqualTo: accountId)
        .limit(1)
        .getDocuments();
  }

  static Future<bool> updateBreakageAccount(
      BreakageAccount acc, final index) async {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(index);
        await transaction.update(
            snapshot.reference, {"account": acc.account, "date": acc.date});
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
