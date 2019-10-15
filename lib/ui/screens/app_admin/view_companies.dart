import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/db_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_company.dart';
import 'app_admin_drawer.dart';

class ViewCompanies extends StatefulWidget {
  ViewCompanies({this.user});

  final FirebaseUser user;

  @override
  State createState() => _ViewCompaniesState();
}

class _ViewCompaniesState extends State<ViewCompanies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppAdminDrawer(),
        appBar: new AppBar(
          title: new Text('Companies'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddCompany()));
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
                    .collection(DBConstants.DB_COMPANY)
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
          String mission = document[positon].data['mission'].toString();
          String date = document[positon].data['date'].toString();

          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.white, child: Icon(Icons.store)),
                  title: Text("Name: " + name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text("Mission: " + mission + '\nDate: ' + date,
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
