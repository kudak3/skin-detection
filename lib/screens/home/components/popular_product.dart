import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detection/components/product_card.dart';
import 'package:skin_detection/models/product.dart';
import 'package:skin_detection/service/firestore_service.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<PopularProducts> {
  FirestoreService get firestoreService => GetIt.I<FirestoreService>();
  List<Product> demoProducts = [];

  @override
  void initState() {
     // getProducts();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "All Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                demoProducts.length,
                (index) {
                  return ProductCard(product: demoProducts[index]);
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }

  getProducts() async {
    var tmp = await firestoreService.getAllProducts();
    print(tmp);

    setState(() {
      demoProducts = tmp;
    });
  }
}
