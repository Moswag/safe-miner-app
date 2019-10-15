import 'dart:async';
import 'dart:convert';

import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/db_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/breakage.dart';
import 'package:android_minor/repo/employee_repo.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/alert_dialog.dart';
import 'package:android_minor/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddBreakage extends StatefulWidget {
  AddBreakage({this.companyId, this.employeeId});
  String companyId;
  String employeeId;
  @override
  State createState() => _AddBreakageState();
}

class _AddBreakageState extends State<AddBreakage> {
  bool _autoValidate = false;
  bool _loadingVisible = false;
  String tool;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //List<String> _currencises = ControllerService.LoadDataToLocalString();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController fineAmountController = new TextEditingController();

  Future _addData({Breakage breakage}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        EmployeeRepo.addBreakage(breakage).then((onValue) {
          if (onValue) {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Breakage Report Successfully submited',
                RouteConstants.EMPLOYEE_VIEW_BREAKAGES);
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to add breakage report',
                RouteConstants.ADMIN_COMPANY_TOOLS);
          }
        });
      } catch (e) {
        print("Adding safety rule Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
                title: "Adding safety rule Error",
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

    final toolField = StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(DBConstants.DB_TOOL).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CupertinoActivityIndicator(),
            );

          return Container(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                      child: Text(
                        "Tool",
                      ),
                    )),
                new Expanded(
                  flex: 4,
                  child: DropdownButton(
                    value: tool,
                    isDense: true,
                    onChanged: (valueSelectedByUser) {
                      _onShopDropItemSelected(valueSelectedByUser);
                    },
                    hint: Text('Choose Tool'),
                    items: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return DropdownMenuItem<String>(
                          value:
                              document.data['id'] + '/' + document.data['name'],
                          child: Text(document.data['name']));
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        });

    final eventField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: descriptionController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.library_books,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'What happened',
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
              Breakage breakage = new Breakage();
              breakage.tool_id = tool.split('/')[0];
              breakage.tool = tool.split('/')[1];
              breakage.event = descriptionController.text;
              breakage.status = AppConstants.BREAKAGE_PENDING;
              breakage.date = DateTime.now().toString();
              breakage.company_id = widget.companyId;
              breakage.employee_id = widget.employeeId;

              var loc = utf8.encode(widget.companyId +
                  breakage.date +
                  breakage.event); // data being hashed
              breakage.id = sha1.convert(loc).toString();

              _addData(breakage: breakage);
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
                  toolField,
                  SizedBox(height: 24.0),
                  eventField,
                  SizedBox(height: 24.0),
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
            title: Text('Report Breakage'),
          ),
          body: LoadingScreen(child: form, inAsyncCall: _loadingVisible),
        ));
  }

  void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      this.tool = newValueSelected;
    });
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
