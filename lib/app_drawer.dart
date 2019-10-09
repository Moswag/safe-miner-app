import 'package:flutter/material.dart';

import 'contants/app_constants.dart';
import 'models/user.dart';

class MinerDrawer extends StatelessWidget {
  final User user;

  MinerDrawer({this.user});

  @override
  Widget build(BuildContext context) {
    void showAlertDialog() {
      AlertDialog alertDialog = AlertDialog(
          title: Text('Status'),
          content: Text('Are you sure you want to logout from Safe Miner App'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    new FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Ok',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        // _signOut(); //signout
                      },
                    ),
                    Container(
                      width: 5.0,
                    ),
                    new FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Theme.of(context).primaryColorDark,
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
            accountName: Text(user.firstName),
            accountEmail: Text(user.email),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new AssetImage(AppConstants.APP_LOGO),
            ),
          ),
          new ListTile(
            leading: Icon(Icons.map),
            title: new Text('View Map'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/detection");
            },
          ),
          new ListTile(
            leading: Icon(Icons.face),
            title: new Text('Detection'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/detection");
            },
          ),
          new ListTile(
            leading: Icon(Icons.terrain),
            title: new Text('Survey'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/detection");
            },
          ),
          new ListTile(
            leading: Icon(Icons.description),
            title: new Text('Manual'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/detection");
            },
          ),
          new ListTile(
            leading: Icon(Icons.error_outline),
            title: new Text('Safety Rules'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.of(context).pushNamed("/detection");
            },
          ),
          new ListTile(
            leading: Icon(Icons.map),
            title: new Text('Report Breakages'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/detection");
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
