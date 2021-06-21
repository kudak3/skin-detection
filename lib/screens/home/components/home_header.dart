import 'package:flutter/material.dart';
import 'package:skin_detection/models/cart.dart';
import 'package:skin_detection/screens/cart/cart_screen.dart';
import 'package:provider/provider.dart';


import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            numOfitem: cart.products.length,
            press: () => Navigator.pushNamed(context, CartScreen.routeName),
          ),

        ],
      ),
    );
  }
}
