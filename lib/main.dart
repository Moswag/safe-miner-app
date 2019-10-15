import 'package:android_minor/ui/screens/admin/view_admins.dart';
import 'package:android_minor/ui/screens/admin/view_company_rules.dart';
import 'package:android_minor/ui/screens/admin/view_conversions.dart';
import 'package:android_minor/ui/screens/admin/view_map_coordinates.dart';
import 'package:android_minor/ui/screens/admin/view_safety_rules.dart';
import 'package:android_minor/ui/screens/admin/view_tools.dart';
import 'package:android_minor/ui/screens/app_admin/view_companies.dart';
import 'package:android_minor/ui/screens/app_admin/view_company_admin.dart';
import 'package:android_minor/ui/screens/app_admin/view_conversions.dart';
import 'package:android_minor/ui/screens/employee/view_discovery_repo.dart';
import 'package:android_minor/ui/screens/main_screen.dart';
import 'package:android_minor/ui/screens/root_screen.dart';
import 'package:android_minor/ui/screens/sign_in_screen.dart';
import 'package:android_minor/ui/screens/sign_up_screen.dart';
import "package:android_minor/ui/screens/walk_screen.dart";
import 'package:android_minor/util/state_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/route_constants.dart';
import 'home.dart';
import 'ui/screens/admin/view_breakages.dart';
import 'ui/screens/admin/view_employees.dart';
import 'ui/screens/app_admin/view_admins.dart';
import 'ui/screens/employee/map.dart';
import 'ui/screens/employee/view_activities.dart';
import 'ui/screens/employee/view_breakage_account.dart';
import 'ui/screens/employee/view_breakages.dart';
import 'ui/screens/employee/view_company_rules.dart';
import 'ui/screens/employee/view_conversions.dart';
import 'ui/screens/employee/view_safety_rules.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );

  runApp(stateWidget);
//  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
//  SharedPreferences.getInstance().then((prefs) {
//    runApp(MyApp(prefs: prefs));
//  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Miner App',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/walkthrough': (BuildContext context) => new WalkthroughScreen(),
        '/root': (BuildContext context) => new RootScreen(),
        '/signin': (BuildContext context) => new SignInScreen(),
        '/signup': (BuildContext context) => new SignUpScreen(),

        //app admin
        RouteConstants.APP_ADMIN_VIEW_COMPANIES: (BuildContext context) =>
            ViewCompanies(),
        RouteConstants.APP_ADMIN_VIEW_COMPANY_ADMINS: (BuildContext context) =>
            ViewCompanyAdmins(),
        RouteConstants.APP_ADMIN_VIEW_ADMINS: (BuildContext context) =>
            ViewAppAdmins(),
        RouteConstants.APP_ADMIN_VIEW_CONVERSIONS: (BuildContext context) =>
            ViewConversions(),

        //company admin
        RouteConstants.ADMIN_VIEW_EMPLOYEES: (BuildContext context) =>
            ViewEmployees(),
        RouteConstants.ADMIN_VIEW_ADMINS: (BuildContext context) =>
            ViewAdminsInCompany(),
        RouteConstants.ADMIN_COMPANY_LOCATION: (BuildContext context) =>
            ViewLocations(),
        RouteConstants.ADMIN_VIEW_CONVERSIONS: (BuildContext context) =>
            ViewCompanyConversions(),
        RouteConstants.ADMIN_VIEW_SAFETY_RULES: (BuildContext context) =>
            ViewSafetyRules(),
        RouteConstants.ADMIN_VIEW_COMPANY_RULES: (BuildContext context) =>
            ViewCompanyRules(),
        RouteConstants.ADMIN_COMPANY_TOOLS: (BuildContext context) =>
            ViewCompanyTools(),
        RouteConstants.ADMIN_VIEW_BREAKAGES: (BuildContext context) =>
            ViewBreakages(),

        //employee
        '/main': (BuildContext context) => new MainScreen(),
        '/detection': (BuildContext context) => new HomePage(cameras),

        RouteConstants.EMPLOYEE_VIEW_CONVERSIONS: (BuildContext context) =>
            EmployeeViewCompanyConversions(),
        RouteConstants.EMPLOYEE_VIEW_SAFETY_RULES: (BuildContext context) =>
            EmployeeViewSafetyRules(),
        RouteConstants.EMPLOYEE_VIEW_COMPANY_RULES: (BuildContext context) =>
            EmployeeViewCompanyRules(),
        RouteConstants.EMPLOYEE_VIEW_BREAKAGES: (BuildContext context) =>
            ViewMyBreakages(),
        RouteConstants.EMPLOYEE_VIEW_BREAKAGES_ACCOUNT:
            (BuildContext context) => ViewMyBreakageAccount(),
        RouteConstants.EMPLOYEE_VIEW_MANUALS: (BuildContext context) =>
            ViewManuals(),
        RouteConstants.EMPLOYEE_VIEW_SURVEYS: (BuildContext context) =>
            ViewSurveys(),

        RouteConstants.EMPLOYEE_VIEW_MAP: (BuildContext context) =>
            MapsSample(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
    // bool seen = (prefs.getBool('seen') ?? false);
    if (true) {
      return new RootScreen();
    } else {
      return new WalkthroughScreen(prefs: prefs);
    }
  }
}
