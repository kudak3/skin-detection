import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_detection/models/cart.dart';
import 'package:skin_detection/screens/cart/cart_screen.dart';
import 'package:skin_detection/screens/home/components/icon_btn_with_counter.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class CustomAppBar extends PreferredSize {


  @override
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenWidth(40),
              width: getProportionateScreenWidth(40),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                color: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/Back ICon.svg",
                  height: 15,
                ),
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfitem: cart.products.length,
                press: () => Navigator.pushNamed(context, CartScreen.routeName),
              ),
            )
          ],
        ),
      ),
    );
  }
}
