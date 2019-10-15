import 'package:flutter/material.dart';


class NoRightsPage extends StatefulWidget {

  @override
  State createState() => _NoRightsPageState();
}

class _NoRightsPageState extends State<NoRightsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Rights Page'),
        centerTitle: true,
      ),
      body: Text('No rights associated with this account', style: TextStyle(fontSize: 20.0),),

    );
  }
}