import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detection/components/product_card.dart';
import 'package:skin_detection/constants.dart';
import 'package:skin_detection/models/product.dart';
import 'package:skin_detection/screens/home/components/section_title.dart';
import 'package:skin_detection/service/firestore_service.dart';

import '../../size_config.dart';

class SkinDetails extends StatefulWidget {
  final String title;
  final String skinType;

  SkinDetails({Key key, this.title, this.skinType}) : super(key: key);

  _SkinDetailsState createState() => _SkinDetailsState();
}

class _SkinDetailsState extends State<SkinDetails> {
  FirestoreService get firestoreService => GetIt.I<FirestoreService>();
  List<Product> demoProducts = [];
  var _list = [];
  List<String> _dryList = [
    "lactic acid",
    "hyaluronic acid",
    "aloe vera",
    "ceramides",
    "goat milk"
  ];
  List<String> _oilyList = [
    "rennol",
    "salicylic acia",
    "aloe vera",
    "niacinamide",
    "clay",
    "grape seed oil"
  ];
  List<String> _normalList = [
    "vitamin C",
    "fatty acids",
    "aloe vera",
    "ceramides",
    "goat milk"
  ];
  List<String> _combinationList = ["hyaluronic acid", "honey", "aloe vera"];

  @override
  void initState() {
    super.initState();
  }

  List<String> getList(String skinType) {
    switch (skinType) {
      case "dry":
        return _dryList;
      case "oily":
        return _oilyList;
      case "normal":
        return _normalList;

      case "combination":
        return _combinationList;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: widget.title),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Container(
          margin: EdgeInsets.only(left: 40, right: 20),
          height: getProportionateScreenHeight(135),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: getProportionateScreenWidth(50),
            childAspectRatio: 3,
            children: getList(widget.skinType).map((value) {
              return Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(8),
                child: Text("${"\u2022"} ${value}"),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
