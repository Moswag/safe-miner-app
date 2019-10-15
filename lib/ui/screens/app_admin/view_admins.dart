import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/db_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_admin.dart';
import 'app_admin_drawer.dart';

class ViewAppAdmins extends StatefulWidget {
  ViewAppAdmins({this.user});

  final FirebaseUser user;

  @override
  State createState() => _ViewAdminsState();
}

class _ViewAdminsState extends State<ViewAppAdmins> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppAdminDrawer(),
        appBar: new AppBar(
          title: new Text('App Admins'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddAppAdmin()));
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
                    .collection(DBConstants.DB_USERS)
                    .where('role', isEqualTo: AppConstants.USER_APP_ADMIN)
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

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    ListView getNoteListView() {
      TextStyle titleStyle = Theme.of(context).textTheme.subhead;
      return ListView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int positon) {
          String name = document[positon].data['name'].toString();
          String email = document[positon].data['email'].toString();
          String phonenumber = document[positon].data['phonenumber'].toString();

          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.white, child: Icon(Icons.person)),
                  title: Text("Name: " + name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "Email: " + email + '\nPhonenumber: ' + phonenumber,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  trailing: GestureDetector(
                    //to make the icon clickable and respond
                    child: Icon(Icons.delete, color: Colors.white, size: 25.0),
                    onTap: () {
                      Firestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot snapshot =
                            await transaction.get(document[positon].reference);
                        await transaction.delete(snapshot.reference);
                      });

                      Scaffold.of(context).showSnackBar(
                          new SnackBar(content: new Text('Company Deleted')));
                    },
                  ),
                  onTap: () {
                    debugPrint("ListTile Tapped");
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (BuildContext context)=>new EditController(
//                          name:  name,
//                          email: email,
//                          nationalId: nationalId ,
//                          phonenumber: phonenumber,
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
