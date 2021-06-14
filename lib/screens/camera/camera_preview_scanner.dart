import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:skin_detection/components/coustom_bottom_nav_bar.dart';
import 'package:skin_detection/enums.dart';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';

import '../../constants.dart';
import 'camera_screen.dart';
import 'camera_view_page.dart';
import 'detector_painters.dart';
import 'scanner_utils.dart';

class CameraPreviewScanner extends StatefulWidget {
  const CameraPreviewScanner({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  double transform = 0;
  bool flash = false;
  dynamic _scanResults;
  CameraController _camera;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;

  final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _camera.initialize();


    await _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _getDetectionMethod(),
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          if (!mounted) return;
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Future<dynamic> Function(FirebaseVisionImage image) _getDetectionMethod() {
    return _faceDetector.processImage;
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    if (_scanResults is! List<Face>) return noResultsText;
    painter = FaceDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 30,
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera),
                _buildResults(),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    color: Colors.black,
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                icon: Icon(
                                  flash ? Icons.flash_on : Icons.flash_off,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  setState(() {
                                    flash = !flash;
                                  });
                                  flash
                                      ? _camera.setFlashMode(FlashMode.torch)
                                      : _camera.setFlashMode(FlashMode.off);
                                }),
                            GestureDetector(
                              onTap: () {
                                takePhoto(context);
                              },
                              child: Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                            IconButton(
                                icon: Transform.rotate(
                                  angle: transform,
                                  child: Icon(
                                    Icons.flip_camera_ios,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    transform = transform + pi;
                                  });
                                  _toggleCameraDirection();
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Hold for Video, tap for photo",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _camera.stopImageStream();
    await _camera.dispose();

    setState(() {
      _camera = null;
    });

    await _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan your face to get skin tone'),
      ),
      body: _buildImage(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.camera),
    );
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      _faceDetector.close();
    });

    super.dispose();
  }

  void takePhoto(BuildContext context) async {
    CircularProgressIndicator();

    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => CameraScreen()));
  }
}
