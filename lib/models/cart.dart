import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';
import 'product.dart';
import 'product.dart';

class Cart extends ChangeNotifier {
  List<Product> _products = [];

  /// List of items in the cart.
  List<Product> get products => _products;

  /// The current total price of all items.
  double get totalPrice =>
      _products.fold(0, (total, current) => total + current.price * current.numOfItems);

  /// Adds [product] to cart. This is the only way to modify the cart from outside.
  void add(Product product) {
    _products.add(product);
    _showToast("added to");
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void update(Product product,String operator){
    try{
       int i = _products.indexOf(product);
    product.numOfItems = operator == "increment" ? ++product.numOfItems : --product.numOfItems;
    _products[i] = product;

    } on RangeError{
      print("Out of range");
    } on NullThrownError{
      print("Null pointer");
    }

 notifyListeners();
  }

  void remove(Product product) {
    _products.remove(product);
    _showToast("removed from");
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: "Product successfully $msg cart",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        backgroundColor: kPrimaryColor,
        fontSize: 16.0);
  }

}
