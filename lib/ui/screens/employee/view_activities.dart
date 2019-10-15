import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/db_constants.dart';
import 'package:android_minor/models/activity.dart';
import 'package:android_minor/models/state.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../sign_in_screen.dart';
import 'add_activity.dart';
import 'employee_drawer.dart';

class ViewManuals extends StatefulWidget {
  ViewManuals({this.user, this.auth});

  final FirebaseUser user;

  final Auth auth;

  StateModel appState;

  @override
  State createState() => _ViewManualsState();
}

class _ViewManualsState extends State<ViewManuals> {
  @override
  Widget build(BuildContext context) {
    widget.appState = StateWidget.of(context).state;
    if (!widget.appState.isLoading &&
        (widget.appState.firebaseUserAuth == null ||
            widget.appState.user == null ||
            widget.appState.settings == null)) {
      return SignInScreen();
    } else {
      final email = widget.appState?.firebaseUserAuth?.email ?? '';
      final employeeId = widget.appState?.user?.employeeNumb ?? '';
      final companyId = widget.appState?.user?.companyId ?? '';

      return Scaffold(
          drawer: EmployeeDrawer(),
          appBar: new AppBar(
            title: new Text('View Manuals'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddActivity(
                            employeeId: employeeId,
                          )));
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
          ),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(DBConstants.DB_ACTIVITY)
                      .where('employee_id', isEqualTo: employeeId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return new Container(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ));
                    return new TaskList(
                      document: snapshot.data.documents,
                    );
                  },
                ),
              ),
              Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppConstants.BACKGROUND_IMAGE),
                        fit: BoxFit.cover),
                    boxShadow: [
                      new BoxShadow(color: Colors.black, blurRadius: 8.0)
                    ],
                    color: Colors.black),
              ),
            ],
          ));
    }
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    ListView getNoteListView() {
      return ListView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int positon) {
          Activity activity = new Activity();
          activity.employee_id =
              document[positon].data['employee_id'].toString();
          activity.title = document[positon].data['title'].toString();
          activity.description =
              document[positon].data['description'].toString();
          activity.date = document[positon].data['date'].toString();

          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.error_outline)),
                  title: Text("Title: " + activity.title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "Description: " +
                          activity.description +
                          '\nDate: ' +
                          activity.date,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  trailing: GestureDetector(
                    //to make the icon clickable and respond
                    child: Icon(Icons.delete, color: Colors.white, size: 25.0),
                    onTap: () {},
                  ),
                  onTap: () {
                    debugPrint("ListTile Tapped");
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (BuildContext context) => new ProccesBreakage(
//                          breakage: breakage,
//                          index: document[positon].reference,
//                        )));
                  },
                ),
              ));
        },
      );
    }

    return getNoteListView();
  }
}
