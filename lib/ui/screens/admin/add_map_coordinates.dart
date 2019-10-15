import 'dart:async';
import 'dart:convert';

import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/location.dart';
import 'package:android_minor/repo/admin_repo.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/alert_dialog.dart';
import 'package:android_minor/util/auth.dart';
import 'package:crypto/crypto.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddLocation extends StatefulWidget {
  AddLocation({this.companyId});
  String companyId;
  @override
  State createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  bool _autoValidate = false;
  bool _loadingVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //List<String> _currencises = ControllerService.LoadDataToLocalString();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController side1LongController = new TextEditingController();
  TextEditingController side1LatController = new TextEditingController();
  TextEditingController side2LongController = new TextEditingController();
  TextEditingController side2LatController = new TextEditingController();
  TextEditingController side3LongController = new TextEditingController();
  TextEditingController side3LatController = new TextEditingController();
  TextEditingController side4LongController = new TextEditingController();
  TextEditingController side4LatController = new TextEditingController();

  Future _addData({Location location}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        var loc = utf8.encode(widget.companyId); // data being hashed
        location.id = sha1.convert(loc).toString();
        location.company_id = widget.companyId;
        location.status = 1;

        CompanyAdminRepo.addMap(location).then((onValue) {
          if (onValue) {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Company Location Successfully added',
                RouteConstants.ADMIN_COMPANY_LOCATION);
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to add location',
                RouteConstants.ADMIN_COMPANY_LOCATION);
          }
        });
      } catch (e) {
        print("Adding location Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
                title: "Adding location Error",
                message: exception,
                duration: Duration(seconds: 5))
            .show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    //define form fields;
    final header = Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AppConstants.BACKGROUND_IMAGE),
            fit: BoxFit.cover),
        color: Colors.blue,
      ),
    );

    final side1LongField = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: side1LongController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Side 1 Longitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final side1LatField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: side1LatController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.confirmation_number,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Side 1 Latitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final side2LongField = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: side2LongController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Side 2 Longitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final side2LatField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: side2LatController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.confirmation_number,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Side 2 Latitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final side3LongField = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: side3LongController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Side 3 Longitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final side3LatField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: side3LatController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.confirmation_number,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Side 3 Latitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final side4LongField = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: side4LongController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Side 4 Longitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final side4LatField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: side4LatController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.confirmation_number,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Side 4 Latitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final submitButton = Expanded(
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(
            'Save',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            setState(() {
              debugPrint("Save clicked");
              Location location = new Location();
              location.side1_longitude = side1LongController.text;
              location.side1_latitude = side1LatController.text;
              location.side2_longitude = side2LongController.text;
              location.side2_latitude = side2LatController.text;
              location.side3_longitude = side3LongController.text;
              location.side3_latitude = side3LatController.text;
              location.side4_longitude = side4LongController.text;
              location.side4_latitude = side4LatController.text;
              location.date = DateTime.now().toString();
              _addData(location: location);
            });
          }),
    );

    final cancelButton = Expanded(
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Colors.red,
          textColor: Colors.white,
          child: Text(
            'Cancel',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            setState(() {
              debugPrint("Cancel button clicked");
              Navigator.pop(context);
            });
          }),
    );

    Form form = new Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  header,
                  SizedBox(height: 48.0),
                  side1LongField,
                  SizedBox(height: 24.0),
                  side1LatField,
                  SizedBox(height: 24.0),
                  side2LongField,
                  SizedBox(height: 24.0),
                  side2LatField,
                  SizedBox(height: 24.0),
                  side3LongField,
                  SizedBox(height: 24.0),
                  side3LatField,
                  SizedBox(height: 24.0),
                  side4LongField,
                  SizedBox(height: 24.0),
                  side4LatField,
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        submitButton,
                        Container(
                          width: 5.0,
                        ), //for adding space between buttons
                        cancelButton
                      ],
                    ),
                  ),
                ],
              ),
            )));

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: new AppBar(
            elevation: 0.1,
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            title: Text('Add Mine Map Cordinates'),
          ),
          body: LoadingScreen(child: form, inAsyncCall: _loadingVisible),
        ));
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
