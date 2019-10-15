import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/db_constants.dart';
import 'package:android_minor/models/breakage.dart';
import 'package:android_minor/models/state.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../sign_in_screen.dart';
import 'admin_drawer.dart';
import 'process_breakage.dart';

class ViewBreakages extends StatefulWidget {
  ViewBreakages({this.user, this.auth});

  final FirebaseUser user;

  final Auth auth;

  StateModel appState;

  @override
  State createState() => _ViewBreakagesState();
}

class _ViewBreakagesState extends State<ViewBreakages> {
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
          drawer: AdminDrawer(),
          appBar: new AppBar(
            title: new Text('View Breakages'),
            centerTitle: true,
          ),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(DBConstants.DB_BREAKAGES)
                      .where('company_id', isEqualTo: companyId)
                      .where('status', isEqualTo: AppConstants.BREAKAGE_PENDING)
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
          Breakage breakage = new Breakage();
          breakage.employee_id =
              document[positon].data['employee_id'].toString();
          breakage.company_id = document[positon].data['company_id'].toString();
          breakage.id = document[positon].data['id'].toString();
          breakage.tool = document[positon].data['tool'].toString();
          breakage.tool_id = document[positon].data['tool_id'].toString();
          breakage.event = document[positon].data['event'].toString();
          breakage.status = document[positon].data['status'].toString();
          breakage.date = document[positon].data['date'].toString();

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
                  title: Text("Tool: " + breakage.tool,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "Description: " +
                          breakage.event +
                          '\nStatus: ' +
                          breakage.status +
                          '\nDate: ' +
                          breakage.date,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  trailing: GestureDetector(
                    //to make the icon clickable and respond
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 25.0),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ProccesBreakage(
                                breakage: breakage,
                                index: document[positon].reference,
                              )));
                    },
                  ),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => new ProccesBreakage(
                              breakage: breakage,
                              index: document[positon].reference,
                            )));
                  },
                ),
              ));
        },
      );
    }

    return getNoteListView();
  }
}
