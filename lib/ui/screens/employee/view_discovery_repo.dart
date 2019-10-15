import 'dart:math';

import 'package:android_minor/constants/db_constants.dart';
import 'package:android_minor/models/survey.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_survey.dart';
import 'employee_drawer.dart';

class ViewSurveys extends StatefulWidget {
  @override
  _ViewPostsState createState() => new _ViewPostsState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.1; //for the card size

class _ViewPostsState extends State<ViewSurveys> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EmployeeDrawer(),
      appBar: new AppBar(
        title: new Text('Cloud Repository'),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      //bottomNavigationBar: makeBottom,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!

          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext contex) => AddSurvey()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection(DBConstants.DB_SURVEY)
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
        ],
      ),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  final Survey post;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.post);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        var delta = 0;
        bool isOnRight = delta > 0;

        var start = padding +
            max(
                primaryCardLeft -
                    horizontalInset * -delta * (isOnRight ? 15 : 1),
                0.0);

        var cardItem = Positioned.directional(
          top: padding + verticalInset * max(-delta, 0.0),
          bottom: padding + verticalInset * max(-delta, 0.0),
          start: start,
          textDirection: TextDirection.rtl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3.0, 6.0),
                    blurRadius: 10.0)
              ]),
              child: AspectRatio(
                aspectRatio: cardAspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(post.imageUrl, fit: BoxFit.cover),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(post.description,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    fontFamily: "SF-Pro-Text-Regular")),
                          ),
                          Text(post.dateCreated,
                              style: TextStyle(
                                  color: Colors.blue, fontSize: 15.0)),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        cardList.add(cardItem);

        return Stack(
          children: cardList,
        );
      }),
    );
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
          Survey post = new Survey();
          post.id = document[positon].data['id'].toString();
          post.title = document[positon].data['title'].toString();
          post.description = document[positon].data['description'].toString();
          post.imageUrl = document[positon].data['imageUrl'].toString();
          post.dateCreated = document[positon].data['dateCreated'].toString();

          return Wrap(children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(post.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46.0,
                        fontFamily: "Calibre-Semibold",
                        letterSpacing: 1.0,
                      )),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                CardScrollWidget(post),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.list,
                size: 12.0,
                color: Colors.white,
              ),
              onPressed: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (builder) =>
//                                  SportDetailScreen(sport: sport)));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.comment,
                size: 12.0,
                color: Colors.white,
              ),
              onPressed: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (builder) =>
//                                  SportDetailScreen(sport: sport)));
              },
            )
          ]);
        },
      );
    }

    return getNoteListView();
  }
}
