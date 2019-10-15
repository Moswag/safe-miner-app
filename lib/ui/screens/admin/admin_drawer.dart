import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/state.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/state_widget.dart';
import 'package:flutter/material.dart';

import '../sign_in_screen.dart';

class AdminDrawer extends StatelessWidget {
  AdminDrawer({this.auth, this.onSignedOut});

  final Auth auth;
  final VoidCallback onSignedOut;

  StateModel appState;
  bool _loadingVisible = false;

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      final email = appState?.firebaseUserAuth?.email ?? '';
      final name = appState?.user?.name ?? '';

      void _signOut() async {
        try {
          await Auth.signOut();
          Navigator.of(context).pop();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new SignInScreen()));
        } catch (e) {
          print(e);
        }
      }

      void showAlertDialog() {
        AlertDialog alertDialog = AlertDialog(
            title: Text('Status'),
            content:
                Text('Are you sure you want to logout from Safe Miner App'),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      new FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.blue,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Ok',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          _signOut(); //signout
                        },
                      ),
                      Container(
                        width: 5.0,
                      ),
                      new FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.red,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ))
            ]);

        showDialog(context: context, builder: (_) => alertDialog);
      }

      return new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage(AppConstants.DRAWER_LOGO),
              ),
            ),
            new ListTile(
              leading: Icon(Icons.map),
              title: new Text('Admin'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteConstants.ADMIN_VIEW_ADMINS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.face),
              title: new Text('Employees'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteConstants.ADMIN_VIEW_EMPLOYEES);
              },
            ),
            new ListTile(
              leading: Icon(Icons.terrain),
              title: new Text('Location'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteConstants.ADMIN_COMPANY_LOCATION);
              },
            ),
            new ListTile(
              leading: Icon(Icons.title),
              title: new Text('Tools'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamed(RouteConstants.ADMIN_COMPANY_TOOLS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.library_books),
              title: new Text('Conversion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamed(RouteConstants.ADMIN_VIEW_CONVERSIONS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.error_outline),
              title: new Text('Safety Rules'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamed(RouteConstants.ADMIN_VIEW_SAFETY_RULES);
              },
            ),
            new ListTile(
              leading: Icon(Icons.description),
              title: new Text('Company Rules'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamed(RouteConstants.ADMIN_VIEW_COMPANY_RULES);
              },
            ),
            new ListTile(
              leading: Icon(Icons.map),
              title: new Text('Breakages'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteConstants.ADMIN_VIEW_BREAKAGES);
              },
            ),
            new ListTile(
              leading: Icon(Icons.all_out),
              title: new Text('Logout'),
              onTap: () {
                //Navigator.pop(context);
                showAlertDialog(); // _signOut();
              },
            )
          ],
        ),
      );
    }
  }
}
