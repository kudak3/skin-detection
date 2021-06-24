import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:skin_detection/models/api_response.dart';
import 'package:skin_detection/models/cart.dart';
import 'package:skin_detection/models/user_details.dart';
import 'package:skin_detection/service/firestore_service.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatefulWidget {
  @override
  State createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {
  FirestoreService get firestoreService => GetIt.I<FirestoreService>();
  UserDetails userDetails;
  bool loading = true;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            Categories(),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : userDetails?.skinType != null
                    ? PopularProducts(
                        title: "Recommended for you",
                        skinType: userDetails.skinType,
                      )
                    : DiscountBanner(),
            SizedBox(height: getProportionateScreenWidth(30)),
            PopularProducts(
              title: "All products",
            ),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
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
      setState(() {

      });
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
}
