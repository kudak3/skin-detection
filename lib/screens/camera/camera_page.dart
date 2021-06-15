import 'package:flutter/material.dart';
import 'package:skin_detection/screens/camera/camera_preview_scanner.dart';
import 'package:skin_detection/screens/camera/face_detector_view.dart';

// import 'camera_preview_scanner.dart';
import 'camera_screen.dart';

class CameraPage extends StatelessWidget {
  static String routeName = "/camera";
  const CameraPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FaceDetectorView();
  }
}