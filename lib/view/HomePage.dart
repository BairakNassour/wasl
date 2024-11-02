import 'package:flutter/material.dart';
import 'package:wasl/auth/login.dart';
import 'package:wasl/component/Color.dart';
import 'package:wasl/view/MessagesPage.dart';
import 'package:wasl/view/Notification.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    // الحصول على FCM Token وإرساله
    _getFCMTokenAndSendToServer();
  }

  Future<void> _getFCMTokenAndSendToServer() async {
    // الحصول على FCM token
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    // احصل على FCM Token
    // fcmToken = await messaging.getToken();

    // الحصول على user_id من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('token');

    // تحقق إذا كانت القيم موجودة
    if (userId != null && fcmToken != null) {
      await _sendFcmTokenToServer(fcmToken!, userId!);
    }
  }

  Future<void> _sendFcmTokenToServer(String fcmToken, String userId) async {
    final url = 'https://wasel.scit.co/public/api/auth/fcm';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fcm_token': fcmToken,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        print(fcmToken);
        print('FCM Token sent successfully');
      } else {
        print('Failed to send FCM Token: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending FCM Token: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            // Positioned(
            //   top: 40,
            //   right: 16,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.of(context).pushAndRemoveUntil(
            //         MaterialPageRoute(builder: (context) => LoginPage()),
            //         (Route<dynamic> route) => false,
            //       );
            //     },
            //     child: Icon(
            //       Icons.arrow_back,
            //       color: Colors.white,
            //       size: 30,
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: globalcolor,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'وصل',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B726A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'نهدف إلى تسهيل وتشجيع عملية التواصل بين فائدة\nالمدرسة والمعلمات عبر نظام مركزي ومنظم',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/homepage.png',
                      height: 200,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return MessagesPage();
                                }));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: globalcolor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'الرسائل',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          height: 47,
                          width: 170,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(
                                color: globalcolor,
                              ),
                            ),
                            child: Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                color: globalcolor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
