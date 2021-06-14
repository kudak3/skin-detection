import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detection/components/custom_surfix_icon.dart';
import 'package:skin_detection/components/form_error.dart';
import 'package:skin_detection/helper/keyboard.dart';
import 'package:skin_detection/models/api_response.dart';
import 'package:skin_detection/screens/forgot_password/forgot_password_screen.dart';
import 'package:skin_detection/screens/home/home_screen.dart';
import 'package:skin_detection/screens/login_success/login_success_screen.dart';
import 'package:skin_detection/service/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email;
  String password;
  bool remember = false;
  final List<String> errors = [];

   AuthenticationService get authenticationService =>
      GetIt.I<AuthenticationService>();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator()),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: [
                buildEmailFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildPasswordFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                Row(
                  children: [
                    Checkbox(
                      value: remember,
                      activeColor: kPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          remember = value;
                        });
                      },
                    ),
                    Text("Remember me"),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, ForgotPasswordScreen.routeName),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                  text: "Continue",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // if all are valid then go to success screen
                      KeyboardUtil.hideKeyboard(context);
                     _signIn();
                    }
                  },
                ),
              ],
            ),
          );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }


  _signIn() async {
    // setState(() {
    //   _isLoading = true;
    // });
    //
    // APIResponse result =
    //     await authenticationService.signInWithEmail(email, password);
    //
    // setState(() {
    //   _isLoading = false;
    // });
    //
    // if (!result.error) {
    //   await showToast("Login successful");
     Navigator.pushNamed(context,  HomeScreen.routeName,

      );
    // } else {
    //   showToast(result.errorMessage);
    // }
  }

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        textColor: Colors.green,
        fontSize: 16.0);
  }
}
