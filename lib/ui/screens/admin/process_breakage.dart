import 'dart:async';
import 'dart:convert';

import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/breakage.dart';
import 'package:android_minor/models/breakage_account.dart';
import 'package:android_minor/repo/admin_repo.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/alert_dialog.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProccesBreakage extends StatefulWidget {
  ProccesBreakage({this.breakage, this.index});
  Breakage breakage;
  final index;

  @override
  State createState() => _AddBreakageState();
}

class _AddBreakageState extends State<ProccesBreakage> {
  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool _categoryVisibility = false;

  String nature = '';
  static var _nature = AppConstants.BREAKAGE_NATURE;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nature = _nature[0];
  }

  //List<String> _currencises = ControllerService.LoadDataToLocalString();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController reasonController = new TextEditingController();

  Future _addData({Breakage breakage}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        CompanyAdminRepo.updateBreakage(breakage, widget.index).then((onValue) {
          if (onValue) {
            CompanyAdminRepo.getTool(breakage.tool_id)
                .then((QuerySnapshot snapshot) {
              if (snapshot.documents.isNotEmpty) {
                var tool = snapshot.documents[0].data;
                BreakageAccount acc = new BreakageAccount();
                acc.account = tool['finePrice'];
                acc.employee_id = breakage.employee_id;
                acc.company_id = breakage.company_id;
                acc.status = 'debit';
                acc.date = DateTime.now().toString();

                var loc =
                    utf8.encode(breakage.employee_id); // data being hashed
                acc.id = sha1.convert(loc).toString();

                CompanyAdminRepo.addBreakageAccount(acc).then((onValue) {
                  if (onValue) {
                    AlertDiag.showAlertDialog(
                        context,
                        'Status',
                        'Breakage successfully updated',
                        RouteConstants.ADMIN_VIEW_BREAKAGES);
                  } else {
                    AlertDiag.showAlertDialog(
                        context,
                        'Status',
                        'Failed to update breakage report',
                        RouteConstants.ADMIN_VIEW_BREAKAGES);
                  }
                });
              } else {
                AlertDiag.showAlertDialog(
                    context,
                    'Status',
                    'Failed to update breakage report',
                    RouteConstants.ADMIN_VIEW_BREAKAGES);
              }
            });
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to update breakage report',
                RouteConstants.ADMIN_COMPANY_TOOLS);
          }
        });
      } catch (e) {
        print("Adding safety rule Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
                title: "updating breakage report Error",
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

    final natureField = Container(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Row(children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                child: Text(
                  "Breakage Nature",
                ),
              )),
          new Expanded(
            flex: 4,
            child: DropdownButton(
                items: _nature.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                iconSize: 20,
                value: nature,
                onChanged: (valueSelectedByUser) {
                  _onProjectNatureItemSelected(valueSelectedByUser);
                }),
          )
        ]));

    final reasonField = Visibility(
      visible: _categoryVisibility,
      child: TextFormField(
          autofocus: false,
          keyboardType: TextInputType.text,
          controller: reasonController,
          validator: Validator.validateField,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Icon(
                Icons.list,
                color: Colors.black,
              ), // icon is 48px widget.
            ), // icon is 48px widget.
            hintText: 'Reason',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          )),
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
              widget.breakage.status = nature;
              widget.breakage.reason = reasonController.text;

              _addData(breakage: widget.breakage);
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
                  natureField,
                  SizedBox(height: 24.0),
                  reasonField,
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

  void _onProjectNatureItemSelected(String newValueSelected) {
    setState(() {
      this.nature = newValueSelected;
      if (newValueSelected == AppConstants.TOOL_FINED) {
        this._categoryVisibility = false;
      } else {
        this._categoryVisibility = true;
      }
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
