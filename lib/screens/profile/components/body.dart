import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detection/constants.dart';
import 'package:skin_detection/models/api_response.dart';
import 'package:skin_detection/screens/sign_in/sign_in_screen.dart';
import 'package:skin_detection/service/authentication_service.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  AuthenticationService get authenticationService =>
      GetIt.I<AuthenticationService>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: [
          Column(
            children: [
              ProfilePic(),
              SizedBox(height: 20),
              ProfileMenu(
                text: "My Account",
                icon: "assets/icons/User Icon.svg",
                press: () => {},
              ),


              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/Log out.svg",
                press: () {
                  _signOut();
                },
              ),
            ],
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  _signOut() async {
    setState(() {
      _isLoading = true;
    });

    APIResponse result = await authenticationService.logout();

    setState(() {
      _isLoading = false;
    });

    if (!result.error) {
      await showToast("Logged out successfully");

      Navigator.pushNamed(
        context,
        SignInScreen.routeName,
      );
    } else {
      showToast(result.errorMessage);
    }
  }

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        textColor: kPrimaryColor,
        fontSize: 16.0);
  }
}
