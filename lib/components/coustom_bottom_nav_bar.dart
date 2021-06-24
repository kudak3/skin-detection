import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detection/models/api_response.dart';
import 'package:skin_detection/models/user_details.dart';
import 'package:skin_detection/screens/camera/camera_page.dart';
import 'package:skin_detection/screens/camera/camera_preview_scanner.dart';
import 'package:skin_detection/screens/home/home_screen.dart';
import 'package:skin_detection/screens/profile/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_detection/service/firestore_service.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  _CustomBottomNavBar createState() {
    return _CustomBottomNavBar();
  }
}

class _CustomBottomNavBar extends State<CustomBottomNavBar> {
  FirestoreService get firestoreService => GetIt.I<FirestoreService>();
  UserDetails userDetails;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: MenuState.home == widget.selectedMenu
                      ? kTertiaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                  icon: Icon(
                    MenuState.camera == widget.selectedMenu
                        ? Icons.camera_alt
                        : Icons.camera_alt_outlined,
                    color: MenuState.camera == widget.selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CameraPage.routeName);
                  }
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: MenuState.profile == widget.selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
            ],
          )),
    );
  }

  getUserDetails() async {
    APIResponse response = await firestoreService.getUserDetails();

    if (!response.error) {
      userDetails = response.data;
      loading = false;
      setState(() {});
    } else {
      loading = false;
      setState(() {});
      showToast(response.errorMessage);
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

  Future _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ALERT'),
          content: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                        "This user already has scanned results."),
                    Text(
                        "Press continue  to scan again or Cancel to view existing results.")
                  ],
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
            TextButton(
              child: Text(' Yes'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }
}
