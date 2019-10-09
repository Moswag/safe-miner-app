import 'package:android_minor/business/auth.dart';
import 'package:android_minor/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../app_drawer.dart';

class MainScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;

  MainScreen({this.firebaseUser});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print(widget.firebaseUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text("Home"),
        centerTitle: true,
      ),
      drawer: MinerDrawer(
        user: new User(firstName: 'Thelma', email: 'thelma@gmail.com'),
      ),
      body: StreamBuilder(
        stream: Auth.getUser(widget.firebaseUser.uid),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(212, 20, 15, 1.0),
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    child: CircleAvatar(
                      backgroundImage: (snapshot.data.profilePictureURL != '')
                          ? NetworkImage(snapshot.data.profilePictureURL)
                          : AssetImage("assets/images/minor.png"),
                    ),
                  ),
                  Text(
                      "Welcome to Safe Miner App where all your work is in one app\n"),
                  Text("Name: ${snapshot.data.firstName}"),
                  Text("Email: ${snapshot.data.email}"),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _logOut() async {
    Auth.signOut();
  }
}
