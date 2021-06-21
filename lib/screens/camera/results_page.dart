import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:skin_detection/models/api_response.dart';
import 'package:skin_detection/models/product.dart';
import 'package:skin_detection/models/user_details.dart';
import 'package:skin_detection/screens/camera/image_view.dart';
import 'package:skin_detection/screens/camera/palette_swatch.dart';
import 'package:skin_detection/screens/details/components/top_rounded_container.dart';
import 'package:skin_detection/screens/home/components/popular_product.dart';
import 'package:skin_detection/service/firestore_service.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ResultsPage extends StatefulWidget {
  final File image;

  ResultsPage({Key key, this.image}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ResultsPageState();
  }
}

class ResultsPageState extends State<ResultsPage>
    with SingleTickerProviderStateMixin {
  PaletteColor bgColors;
  UserDetails userDetails;

  FirestoreService get firestoreService => GetIt.I<FirestoreService>();
  List<Product> demoProducts = [];

  @override
  void initState() {
    getProducts();
    initializePalette();

    super.initState();
  }

  initializePalette() async {
    PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
      FileImage(widget.image),
      size: Size(200, 100),
    );
    bgColors =
    palette.dominantColor != null ? palette.dominantColor : Colors.white;
    setState(() {});
    bgColors != null && updateUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: getProportionateScreenWidth(10)),
              ImageView(image: widget.image),
              SizedBox(height: getProportionateScreenWidth(30)),
              PopularProducts(
                title: "Recommended for you",
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: PaletteSwatch(
                              label: 'Skin tone',
                              color:
                              bgColors != null ? bgColors.color : Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text(userDetails.skinType),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ])),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  updateUserDetails() async {
    Random rnd = new Random();
    var lst = ['dry', 'oily', 'normal', 'combination'];
    var type = lst[rnd.nextInt(lst.length)];

    APIResponse response = await firestoreService.updateUserDetails(
        {'skinTone': bgColors.color.value.toRadixString(16), 'skinType': type});

    if (!response.error) {
      showToast("User recommendations saved successfully");
      userDetails = response.data;
      setState(() {});
    } else {
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

  getProducts() async {
    var tmp = await firestoreService.getAllProducts();

    demoProducts = tmp;
    setState(() {});
  }
}
