import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skin_detection/components/default_button.dart';
import 'package:skin_detection/models/cart.dart';
import 'package:provider/provider.dart';
import 'package:skin_detection/screens/home/home_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CheckoutCard extends StatelessWidget {
  CheckoutCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: getProportionateScreenWidth(40),
                  width: getProportionateScreenWidth(40),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$" + cart.totalPrice.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () => _asyncInputDialog(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pay for these products using this account'),
          content: Row(
            children: [
              Expanded(
                  child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Account No.', hintText: '0774 xxx xxx'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
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
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
                _asyncPinCodeDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future _asyncPinCodeDialog(BuildContext context) async {
    var cart = Provider.of<Cart>(context, listen: false);
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Security pin'),
          content: Row(
            children: [
              Expanded(
                  child: TextField(
                autofocus: true,
                decoration:
                    InputDecoration(labelText: 'Pin no.', hintText: 'xxxx'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
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
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
                cart.clearCart();
                showToast("Payment Success");
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
            ),
          ],
        );
      },
    );
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
