import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color primaryColor = Colors.purple;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background1.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  primaryColor.withOpacity(0.3), BlendMode.lighten)),
        ),
        child: Center(
          child: Container(
            child: Image.asset('assets/images/vertical_white.png'),
          ),
        ),
      ),
    );
  }
}
