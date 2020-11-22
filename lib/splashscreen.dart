import 'package:cat_vs_dog/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        'Dog and Cat',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.teal,
        ),
      ),
      image: Image.asset(
          'assets/cat1.png'
      ),
      backgroundColor: Colors.white,
      photoSize: 50,
      loaderColor: Colors.teal,
    );
  }
}
