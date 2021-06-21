import 'package:flutter/material.dart';
import 'package:skin_detection/components/rounded_icon_btn.dart';
import 'package:skin_detection/models/cart.dart';
import 'package:skin_detection/models/product.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ColorDots extends StatelessWidget {
  const ColorDots({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;


  @override
  Widget build(BuildContext context) {
    // Now this is fixed and only for demo
    int selectedColor = 3;
    List<Color> colors = [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ];

    var cart = context.watch<Cart>();
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        children: [
          ...List.generate(
            colors.length,
            (index) => ColorDot(
              color: colors[index],
              isSelected: index == selectedColor,
            ),
          ),
          Spacer(),
          RoundedIconBtn(
            icon: Icons.remove,
            press: () {
              if (product.numOfItems > 1) {
                cart.update(product,"decrement");
              }

            },
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
          Text(
            product.numOfItems.toString(),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
          RoundedIconBtn(
            icon: Icons.add,
            showShadow: true,
            press: () {
              cart.update(product,"increment");
            },
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    Key key,
    @required this.color,
    this.isSelected = false,
  }) : super(key: key);

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2),
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            Border.all(color: isSelected ? kPrimaryColor : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
