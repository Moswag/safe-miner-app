import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

class Walkthrough {
  String imagePath;
  String title;
  String description;
  Widget extraWidget;

  Walkthrough(
      {this.imagePath, this.title, this.description, this.extraWidget}) {
    if (extraWidget == null) {
      extraWidget = new Container();
    }
  }
}
