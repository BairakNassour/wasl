
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:wasl/auth/newpassword.dart';
import 'package:wasl/component/Color.dart';
import 'package:wasl/controller/authentication_controller.dart';

class OTPVerficationPage extends StatefulWidget {
  final String email;

  const OTPVerficationPage({super.key, required this.email});

  @override
  State<OTPVerficationPage> createState() => _OTPVerficationPageState();
}

Authentiction_Control _authentiction_control = Authentiction_Control();

class _OTPVerficationPageState extends State<OTPVerficationPage> {
  @override
  void initState() {
    super.initState();
    // عرض مربع الحوار تلقائيًا عند تحميل الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCodeArrivalDialog();
    });
  }

  // دالة لعرض مربع الحوار
  void _showCodeArrivalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("معلومات الكود"),
          content: Text("ستتلقى الكود في غضون 5 دقائق كحد أقصى."),
          actions: [
            TextButton(
              child: Text("موافق"),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الـ Dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: 150,
                width: double.infinity,
                child: Image.asset(
                  'assets/background.png', // صورة الخلفية العلوية
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: globalcolor, // اللون الأخضر السفلي
                ),
              ),
            ),
            Positioned(
                    top: 40,
                    right: 16,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: width,
                  height: height,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height / 8),
                       
                        const SizedBox(height: 20),
                        Text(
                          "أدخل الكود",
                          style: TextStyle(
                              color: globalcolor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "لقد أرسلنا الكود إلى بريدك الإلكتروني",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        const SizedBox(height: 20),
                        OtpTextField(
                          numberOfFields: 4,
                          enabledBorderColor: globalcolor2,
                          borderColor: globalcolor2,
                          showFieldAsBox: false,
                          disabledBorderColor: globalcolor2,
                          onCodeChanged: (String code) {},
                          onSubmit: (String verificationCode) {
                            _authentiction_control
                                .sendcodeverffcaion(
                                    widget.email, verificationCode, context)
                                .then((onValue) {
                              if (onValue) {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return NewPassword(
                                    email: widget.email,
                                    code: verificationCode,
                                  );
                                }));
                              }
                            });
                          }, // end onSubmit
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
