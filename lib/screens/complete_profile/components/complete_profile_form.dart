import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detection/components/custom_surfix_icon.dart';
import 'package:skin_detection/components/default_button.dart';
import 'package:skin_detection/components/form_error.dart';
import 'package:skin_detection/models/api_response.dart';
import 'package:skin_detection/models/user_details.dart';
import 'package:skin_detection/screens/home/home_screen.dart';
import 'package:skin_detection/screens/otp/otp_screen.dart';
import 'package:skin_detection/service/authentication_service.dart';
import 'package:skin_detection/service/firestore_service.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({
    Key key,
    @required this.uid,
  }) : super(key: key);
  final String uid;

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final List<String> errors = [];
  String firstName;
  String lastName;
  String phoneNumber;
  String address;

  AuthenticationService get authenticationService =>
      GetIt.I<AuthenticationService>();

  FirestoreService get firestoreService => GetIt.I<FirestoreService>();

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
                buildFirstNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildLastNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildPhoneNumberFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildAddressFormField(),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(40)),
                DefaultButton(
                  text: "continue",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      registerUser() ;
                    }
                  },
                ),
              ],
            ),
          );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your phone address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  registerUser() async {
    setState(() {
      _isLoading = true;
    });
    print("================");
    print('$firstName $lastName $phoneNumber $address');

    APIResponse result = await firestoreService.createUser(UserDetails.optional(
        uid: widget.uid,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address));

    setState(() {
      _isLoading = false;
    });

    if (!result.error) {
      await showToast("User profile successfully created");

      Navigator.pushNamed(
        context,
        HomeScreen.routeName,
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
        textColor: Colors.green,
        fontSize: 16.0);
  }
}
