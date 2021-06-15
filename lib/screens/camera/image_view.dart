import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skin_detection/models/product.dart';

import '../../size_config.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    Key key,
    @required this.image,
  }) : super(key: key);

  final File image;

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.file(widget.image),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),

      ],
    );
  }

}
