import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wasl/auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // تأخير لمدة خمس ثوانٍ قبل الانتقال إلى صفحة تسجيل الدخول
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/WASL.png', // مسار الشعار
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
