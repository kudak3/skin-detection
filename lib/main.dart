import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:skin_detection/screens/camera/camera_screen.dart';

import 'models/cart.dart';
import 'routes.dart';
import 'screens/splash/splash_screen.dart';
import 'service/authentication_service.dart';
import 'service/firestore_service.dart';
import 'theme.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  setupLocator();
  Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(create: (context) => Cart(), child: MyApp()),
  );
}

void setupLocator() {
  GetIt.I.registerLazySingleton(() => FirestoreService());
  GetIt.I.registerLazySingleton(() => AuthenticationService());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BeautyCare Demo',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
