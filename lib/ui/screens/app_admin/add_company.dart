import 'dart:async';
import 'dart:convert';

import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/company.dart';
import 'package:android_minor/repo/app_admin_repo.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/alert_dialog.dart';
import 'package:android_minor/util/validator.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddCompany extends StatefulWidget {
  @override
  State createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  bool _autoValidate = false;
  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController companyNameController = new TextEditingController();
  TextEditingController middionController = new TextEditingController();

  Future _addShop({Company company}) async {
    var shop = utf8.encode(company.name + company.mission); // data being hashed
    var company_id = sha1.convert(shop);
    company.date = DateFormat.yMMMd().format(DateTime.now());
    company.id = company_id.toString();
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        AppAdminRepo.addCompany(company).then((onValue) {
          if (onValue) {
            print('Company succesfully  added');
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Company Successfully Added',
                RouteConstants.APP_ADMIN_VIEW_COMPANIES);
          } else {
            print('adding shop failed');
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to add company',
                RouteConstants.APP_ADMIN_VIEW_COMPANIES);
          }
        });
      } catch (e) {}
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //define form fields

    final header = Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AppConstants.BACKGROUND_IMAGE),
            fit: BoxFit.cover),
        color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Companies',
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontFamily: 'Roboto'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Add Company',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Icon(
            Icons.store,
            color: Colors.white,
            size: 30,
          )
        ],
      ),
    );

    final placeNameField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.text,
      controller: companyNameController,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.wb_iridescent,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Company Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final addressField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.text,
      controller: middionController,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.description,
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
          color: Theme.of(context).primaryColorDark,
          textColor: Theme.of(context).primaryColorLight,
          child: Text(
            'Save',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            setState(() {
              debugPrint("Save clicked");
              Company company = new Company();
              company.name = companyNameController.text;
              company.mission = middionController.text;
              _addShop(company: company);
            });
          }),
    );

    final cancelButton = Expanded(
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Theme.of(context).primaryColorDark,
          textColor: Theme.of(context).primaryColorLight,
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
                  placeNameField,
                  SizedBox(height: 24.0),
                  addressField,
                  SizedBox(height: 24.0),
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

    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          title: Text('Add Company'),
          centerTitle: true,
        ),
        body: LoadingScreen(child: form, inAsyncCall: _loadingVisible));
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
