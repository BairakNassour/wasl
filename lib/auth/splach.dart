import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:wasl/auth/login.dart';
import 'package:wasl/view/HomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    // تأخير لمدة خمس ثوانٍ قبل الانتقال إلى صفحة تسجيل الدخول
    Future.delayed(Duration(seconds: 5), () {
      if (isLoggedIn) {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      } else {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      }
      
    });
  }
 Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // قراءة حالة تسجيل الدخول من SharedPreferences
    bool? loggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      isLoggedIn = loggedIn;
      isLoading = false;
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
