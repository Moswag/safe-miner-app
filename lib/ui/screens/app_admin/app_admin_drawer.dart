import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/state.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/state_widget.dart';
import 'package:flutter/material.dart';

import '../sign_in_screen.dart';

class AppAdminDrawer extends StatelessWidget {
  AppAdminDrawer({this.auth, this.onSignedOut});

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
              leading: Icon(Icons.person),
              title: new Text('App Admin'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteConstants.APP_ADMIN_VIEW_ADMINS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.store),
              title: new Text('Companies'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteConstants.APP_ADMIN_VIEW_COMPANIES);
              },
            ),
            new ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: new Text('Company Admin'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteConstants.APP_ADMIN_VIEW_COMPANY_ADMINS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.change_history),
              title: new Text('Conversion'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(RouteConstants.APP_ADMIN_VIEW_CONVERSIONS);
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
