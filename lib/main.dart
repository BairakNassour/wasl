
import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wasl/auth/login.dart';
import 'package:wasl/auth/splach.dart';
import 'package:wasl/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform, // إعدادات Firebase حسب النظام الأساسي
  // );
  runApp(const Test());
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}
class _TestState extends State<Test> {
  
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
     home: SplashScreen(),
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
//v2