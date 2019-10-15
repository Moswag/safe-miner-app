import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/route_constants.dart';
import 'package:android_minor/models/user.dart';
import 'package:android_minor/ui/screens/sign_in_screen.dart';
import 'package:android_minor/ui/widgets/custom_flat_button.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/alert_dialog.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/state_widget.dart';
import 'package:android_minor/util/validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _phonenumber = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _employeenum = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  //final TextEditingController _access = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Image(
        image: AssetImage(AppConstants.APP_LOGO),
        width: 255,
        height: 130,
      ),
    );

    final fieldName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _name,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'First Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final fieldPhonenumber = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      controller: _phonenumber,
      validator: Validator.validateNumber,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.phone,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Phonenumber',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final fieldEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final fieldEmployeeNum = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: _employeenum,
      //validator: Validator.validateNumber,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.perm_identity,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Employee ID',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final fieldPassword = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _password,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signUpButton = CustomFlatButton(
      title: "Sign Up",
      fontSize: 22,
      fontWeight: FontWeight.w700,
      textColor: Colors.white,
      onPressed: () {
        User user = new User();
        user.name = _name.text;
        user.phonenumber = _phonenumber.text;
        user.email = _email.text;
        user.employeeNumb = _employeenum.text;

        _emailSignUp(user: user, password: _password.text, context: context);
      },
      splashColor: Colors.black12,
      borderColor: Color.fromRGBO(212, 20, 15, 1.0),
      borderWidth: 0,
      color: Color.fromRGBO(212, 20, 15, 1.0),
    );

    final signInLabel = FlatButton(
      child: Text(
        'Have an Account? Sign In.',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => SignInScreen()));
      },
    );

    return Scaffold(
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 48.0),
                      fieldName,
                      SizedBox(height: 24.0),
                      fieldPhonenumber,
                      SizedBox(height: 24.0),
                      fieldEmail,
                      SizedBox(height: 24.0),
                      fieldEmployeeNum,
                      SizedBox(height: 24.0),
                      fieldPassword,
                      SizedBox(height: 20.0),
                      signUpButton,
                      signInLabel
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void _emailSignUp({User user, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
//        await Auth.checkCompanyId(user.employeeNumb).then((onValue) async {
//          if (!(onValue == AppConstants.NOT_EXIST)) {
        await Auth.signUp(user.email, password).then((uID) {
          user.role = AppConstants.USER_EMPLOYEE;
          user.companyId = '1';
          user.isEmployee = true;
          user.userId = uID;

          Auth.addUserSettingsDB(user);
        });
        //now automatically login user too
        await StateWidget.of(context).logInUser(user.email, password);

        AlertDiag.showAlertDialog(context, 'Status', 'User Successfully Added',
            RouteConstants.USER_SIGNIN);
//          } else {
//            Flushbar(
//                    title: "Sign Up Error",
//                    message: "Employee ID do not exist",
//                    duration: Duration(seconds: 5))
//                .show(context);
//          }
//        });

        //redirect to login
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SignInScreen()));
      } catch (e) {
        _changeLoadingVisible();
        // print("Sign Up Error: $e");
        String exception =
//            "No network, please make sure you have internet";
            Auth.getExceptionText(e);
        Flushbar(
                title: "Sign Up Error",
                message: exception,
                duration: Duration(seconds: 5))
            .show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
