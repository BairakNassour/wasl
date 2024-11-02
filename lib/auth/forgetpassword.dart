import 'package:flutter/material.dart';
import 'package:wasl/auth/otpverfication.dart';
import 'package:wasl/controller/authentication_controller.dart';
import 'package:wasl/component/Color.dart'; // تأكد من وجود هذا الملف
// import 'package:wasl/view/OTPVerificationPage.dart'; // تأكد من وجود هذه الصفحة

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

TextEditingController emailController = TextEditingController();
Authentiction_Control _authenticationControl = Authentiction_Control();

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          'استعادة كلمة المرور',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B726A), // لون النص
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'يرجى إدخال البريد الإلكتروني المرتبط بحسابك.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3B726A), // لون النص الثانوي
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildEmailTextField(), // حقل إدخال البريد الإلكتروني
                        const SizedBox(height: 30),
                        _buildGetCodeButton(), // زر "احصل على الكود"
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

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'يرجى إدخال البريد الإلكتروني',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'يرجى إدخال بريد إلكتروني صالح';
        }
        return null;
      },
    );
  }

  Widget _buildGetCodeButton() {
    return ElevatedButton(
      onPressed: () {
        var formData = formState.currentState;
        if (formData!.validate()) {
          _authenticationControl.sendEmail(emailController.text, context).then((onValue) {
            if (onValue) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return OTPVerficationPage(email: emailController.text); // الصفحة التالية
                  },
                ),
              );
            }
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: globalcolor, // لون الزر
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'احصل على الكود',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
