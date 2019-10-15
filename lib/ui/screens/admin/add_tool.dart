import 'dart:async';
import 'dart:convert';

import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/tool.dart';
import 'package:android_minor/repo/admin_repo.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/alert_dialog.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/validator.dart';
import 'package:crypto/crypto.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCompanyTool extends StatefulWidget {
  AddCompanyTool({this.companyId});
  String companyId;
  @override
  State createState() => _AddCompanyToolState();
}

class _AddCompanyToolState extends State<AddCompanyTool> {
  bool _autoValidate = false;
  bool _loadingVisible = false;

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

  Future _addData({Tool tool}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        CompanyAdminRepo.addCompanyTool(tool).then((onValue) {
          if (onValue) {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Company Tool Successfully added',
                RouteConstants.ADMIN_COMPANY_TOOLS);
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to add company tool',
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

    final nameField = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: nameController,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.nature,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Title',
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
            Icons.library_books,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Description',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final fineField = TextFormField(
      keyboardType: TextInputType.numberWithOptions(),
      autofocus: false,
      controller: fineAmountController,
      //validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.monetization_on,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Fine Amount',
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
              Tool tool = new Tool();
              tool.name = nameController.text;
              tool.description = descriptionController.text;
              tool.finePrice = double.parse(fineAmountController.text);
              tool.company_id = widget.companyId;

              var loc = utf8.encode(
                  widget.companyId + nameController.text); // data being hashed
              tool.id = sha1.convert(loc).toString();

              tool.date = DateTime.now().toString();

              _addData(tool: tool);
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
                  nameField,
                  SizedBox(height: 24.0),
                  descriptionField,
                  SizedBox(height: 24.0),
                  fineField,
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
            title: Text('Add Commpany Tool'),
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
