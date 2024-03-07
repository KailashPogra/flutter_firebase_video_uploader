import 'dart:io';
import 'package:firebase/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAyjvruqF_nNX-yYgHscRwhJ0fulV-kd1s",
              appId: "1:345988812164:android:17c07b487ff83c59baa1d1",
              messagingSenderId: "345988812164",
              projectId: "fir-d084b",
              storageBucket: "fir-d084b.appspot.com"),
        )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
