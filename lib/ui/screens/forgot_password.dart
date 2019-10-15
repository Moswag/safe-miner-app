import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/ui/screens/sign_in_screen.dart';
import 'package:android_minor/ui/widgets/custom_flat_button.dart';
import 'package:android_minor/ui/widgets/loading.dart';
import 'package:android_minor/util/auth.dart';
import 'package:android_minor/util/validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();

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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final forgotPasswordButton = CustomFlatButton(
      title: "FORGOT PASSWORD",
      fontSize: 15,
      fontWeight: FontWeight.w700,
      textColor: Colors.white,
      onPressed: () {
        _forgotPassword(email: _email.text, context: context);
      },
      splashColor: Colors.black12,
      borderColor: Color.fromRGBO(212, 20, 15, 1.0),
      borderWidth: 0,
      color: Color.fromRGBO(212, 20, 15, 1.0),
    );

//    final forgotPasswordButton = Padding(
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: RaisedButton(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(24),
//        ),
//        onPressed: () {
//          _forgotPassword(email: _email.text, context: context);
//        },
//        padding: EdgeInsets.all(12),
//        color: Colors.blue,
//        child: Text('FORGOT PASSWORD', style: TextStyle(color: Colors.white)),
//      ),
//    );

    final signInLabel = FlatButton(
      child: Text(
        'Sign In',
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
                      email,
                      SizedBox(height: 12.0),
                      forgotPasswordButton,
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

  void _forgotPassword({String email, BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState.validate()) {
      try {
        await _changeLoadingVisible();
        await Auth.forgotPasswordEmail(email);
        await _changeLoadingVisible();
        Flushbar(
                title: "Password Reset Email Sent",
                message:
                    'Check your email and follow the instructions to reset your password.',
                duration: Duration(seconds: 20))
            .show(context);
      } catch (e) {
        _changeLoadingVisible();
        print("Forgot Password Error: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
                title: "Forgot Password Error",
                message: exception,
                duration: Duration(seconds: 10))
            .show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
