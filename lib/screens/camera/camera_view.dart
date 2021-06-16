import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skin_detection/constants.dart';
import 'package:skin_detection/screens/camera/scanner_screen.dart';

import '../../main.dart';

enum ScreenMode { liveFeed, gallery, scanning }

class CameraView extends StatefulWidget {
  CameraView(
      {Key key,
      this.title,
      this.customPaint,
      this.onImage,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  final CustomPaint customPaint;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController _controller;
  File _image;
  ImagePicker _imagePicker;
  int _cameraIndex = 0;
  bool flash = false;
  double transform = 0;
  String filePath = '';

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == widget.initialDirection) {
        _cameraIndex = i;
      }
    }
    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _switchScreenMode,
              child: Icon(
                _mode == ScreenMode.liveFeed
                    ? Icons.photo_library_outlined
                    : (Platform.isIOS
                        ? Icons.camera_alt_outlined
                        : Icons.camera),
              ),
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.liveFeed) body = _liveFeedBody();
    if (_mode == ScreenMode.gallery) body = _galleryBody();
    if (_mode == ScreenMode.scanning) body = _scanningBody();
    return body;
  }

  Widget _scanningBody() {
    if (_image == null ) {
      if(_controller?.value.isInitialized == false){
        return Container();
      }

    }
    return ScannerScreen(
      image: _image,
    );
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller),
          if (widget.customPaint != null) widget.customPaint,
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
                                ? _controller.setFlashMode(FlashMode.torch)
                                : _controller.setFlashMode(FlashMode.off);
                          }),
                      GestureDetector(
                        onTap: () {
                          takePhoto();
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
                        onPressed: _switchLiveCamera,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Tap to scan",
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

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      _image != null
          ? Container(
              height: 400,
              width: 400,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(_image),
                  if (widget.customPaint != null) widget.customPaint,
                ],
              ),
            )
          : Icon(
              Icons.image,
              size: 200,
            ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: kPrimaryColor),
          child: Text('From Gallery'),
          onPressed: () => _getImage(ImageSource.gallery),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: kPrimaryColor),
          child: Text('Take a picture'),
          onPressed: () => _getImage(ImageSource.camera),
        ),
      ),
      _image != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                child: Text('Process image'),
                onPressed: () {
                  setState(() {
                    _mode = ScreenMode.scanning;
                  });
                },
              ),
            )
          : SizedBox()
    ]);
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await _imagePicker?.getImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  void _switchScreenMode() async {
    if (_mode == ScreenMode.liveFeed) {
      _mode = ScreenMode.gallery;
      await _stopLiveFeed();
    } else {
      _mode = ScreenMode.liveFeed;
      await _startLiveFeed();
    }
    setState(() {});
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.low,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    if (_cameraIndex == 0)
      _cameraIndex = 1;
    else
      _cameraIndex = 0;
    setState(() {
      transform = transform + pi;
    });

    await _stopLiveFeed();
    await _startLiveFeed();
  }

  Future _processPickedFile(PickedFile pickedFile) async {
    setState(() {
      _image = File(pickedFile.path);
    });
    final inputImage = InputImage.fromFilePath(pickedFile.path);
    widget.onImage(inputImage);
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;

    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }

  void takePhoto() async {
    _mode = ScreenMode.scanning;
    _getImage(ImageSource.camera);
    setState(() {});
  }
}
