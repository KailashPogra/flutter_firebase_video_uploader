import 'dart:async';
import 'package:firebase/ui/login.dart';
import 'package:firebase/ui/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashService {
  FirebaseAuth auth = FirebaseAuth.instance;
  isLogin(BuildContext context) {
    if (auth.currentUser != null) {
      // User is already logged in, navigate to the home screen or another screen.
      Timer(Duration(seconds: 3), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UploadImageScreen()));
      });
    } else {
      // User is not logged in, navigate to the login screen.
      Timer(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login()));
      });
    }
  }
}
