import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/db_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'employee_drawer.dart';

class EmployeeViewCompanyConversions extends StatefulWidget {
  EmployeeViewCompanyConversions({this.user});

  final FirebaseUser user;

  @override
  State createState() => _ViewCompanyConversionsState();
}

class _ViewCompanyConversionsState
    extends State<EmployeeViewCompanyConversions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: EmployeeDrawer(),
        appBar: new AppBar(
          title: new Text('Conversions'),
          centerTitle: true,
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 160),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection(DBConstants.DB_CONVERSION)
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
          String metal = document[positon].data['metal'].toString();
          String price = document[positon].data['price'].toString();
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
                  title: Text("Metal: " + metal,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text("Price: " + price + '\nDate: ' + date,
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

                      Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text('Conversion Deleted')));
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
