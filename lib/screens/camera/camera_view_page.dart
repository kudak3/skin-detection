import 'dart:io';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key key, this.path}) : super(key: key);
  final String path;

  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  ImageProvider image;

  PaletteGenerator paletteGenerator;
   PaletteColor selectedColor;

  @override
  void initState() {
//
//     image = AssetImage(widget.path);
//     _updatePaletteGenerator();
  }

  // Future<void> _updatePaletteGenerator() async {
  //   paletteGenerator = await PaletteGenerator.fromImageProvider(
  //     image,
  //       size: Size(200, 100),
  //     maximumColorCount: 5,
  //   );
  //   setState(() {
  //     selectedColor = paletteGenerator.dominantColor;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(widget.path),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
