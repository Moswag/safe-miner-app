import 'dart:async';
import 'dart:convert';

import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/safety_rules.dart';
import 'package:android_minor/repo/admin_repo.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/alert_dialog.dart';
import 'package:android_minor/util/auth.dart';
import 'package:crypto/crypto.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSafetyRule extends StatefulWidget {
  AddSafetyRule({this.companyId});
  String companyId;
  @override
  State createState() => _AddSafetyRuleState();
}

class _AddSafetyRuleState extends State<AddSafetyRule> {
  bool _autoValidate = false;
  bool _loadingVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //List<String> _currencises = ControllerService.LoadDataToLocalString();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ruleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  Future _addData({SafetyRule rule}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        CompanyAdminRepo.addSafetyRule(rule).then((onValue) {
          if (onValue) {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Safety Rule Successfully added',
                RouteConstants.ADMIN_VIEW_SAFETY_RULES);
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to add safety rule',
                RouteConstants.ADMIN_VIEW_SAFETY_RULES);
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

    final ruleField = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: ruleController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Rule',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final descriptionField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: descriptionController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.confirmation_number,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Description',
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
              SafetyRule rule = new SafetyRule();
              rule.rule = ruleController.text;
              rule.description = descriptionController.text;
              rule.company_id = widget.companyId;

              var loc = utf8.encode(
                  widget.companyId + ruleController.text); // data being hashed
              rule.id = sha1.convert(loc).toString();

              rule.date = DateTime.now().toString();

              _addData(rule: rule);
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
                  ruleField,
                  SizedBox(height: 24.0),
                  descriptionField,
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
            title: Text('Add Safety Rule'),
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
