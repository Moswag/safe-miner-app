import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/ui/screens/sign_up_screen.dart';
import 'package:android_minor/ui/widgets/custom_flat_button.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/state_widget.dart';
import 'package:android_minor/util/user_management.dart';
import 'package:android_minor/util/validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'forgot_password.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
    //ControllerService.LoadDataToLocal();
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

    final email = TextFormField(
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final password = TextFormField(
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

    final loginButton = CustomFlatButton(
      title: "SIGN IN",
      fontSize: 15,
      fontWeight: FontWeight.w700,
      textColor: Colors.white,
      onPressed: () {
        _emailLogin(
            email: _email.text, password: _password.text, context: context);
      },
      splashColor: Colors.black12,
      borderColor: Color.fromRGBO(212, 20, 15, 1.0),
      borderWidth: 0,
      color: Color.fromRGBO(212, 20, 15, 1.0),
    );

    final registerButton = CustomFlatButton(
      title: "SIGN UP",
      fontSize: 15,
      fontWeight: FontWeight.w700,
      textColor: Colors.white,
      onPressed: () {
        Navigator.of(context).pushNamed("/signup");
      },
      splashColor: Colors.black12,
      borderColor: Color.fromRGBO(212, 20, 15, 1.0),
      borderWidth: 0,
      color: Color.fromRGBO(212, 20, 15, 1.0),
    );

//    final loginButton = Padding(
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: RaisedButton(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(24),
//        ),
//        onPressed: () {
//          _emailLogin(
//              email: _email.text, password: _password.text, context: context);
//        },
//        padding: EdgeInsets.all(12),
//        color: Colors.blue,
//        child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
//      ),
//    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ForgotPasswordScreen()));
      },
    );

    final signUpLabel = FlatButton(
      child: Text(
        'Create an Account',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => SignUpScreen()));
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
                      email,
                      SizedBox(height: 24.0),
                      password,
                      SizedBox(height: 20.0),
                      forgotLabel,
                      SizedBox(height: 20.0),
                      loginButton,
//                      SizedBox(height: 20.0),
//                      registerButton
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

  void _emailLogin(
      {String email, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        print(email + ' ' + password);
        //need await so it has chance to go through error if found.
        await StateWidget.of(context).logInUser(email, password);
        //navigate to the right dashboard
        UserManagement().authoriseAccess(context);
        // await Navigator.pushNamed(context, '/');
      } catch (e) {
        _changeLoadingVisible();
        print("Sign In Error: $e");
        String exception = Auth.getExceptionText(e);
        //String exception = "No network, please make sure you have internet";
        Flushbar(
                title: "Sign In Error",
                message: exception,
                duration: Duration(seconds: 5))
            .show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
