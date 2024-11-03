import 'package:flutter/material.dart';
import 'package:wasl/component/Color.dart';
import 'package:wasl/controller/authentication_controller.dart';

class NewPassword extends StatefulWidget {
  final String email;
  final String code;

  const NewPassword({super.key, required this.email, required this.code});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

Authentiction_Control _authentiction_control = Authentiction_Control();
bool _isHiddenPassword = true; // بدء إخفاء كلمة المرور
TextEditingController passwordController = TextEditingController();
TextEditingController retypePasswordController = TextEditingController();

class _NewPasswordState extends State<NewPassword> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

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
                  'assets/background.png',
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
                  color: globalcolor,
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          'كلمة مرور جديدة',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B726A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'يرجى إدخال كلمة المرور الجديدة',
                            style: TextStyle(fontSize: 14, color: Color(0xFF3B726A)),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isHiddenPassword,
                          decoration: InputDecoration(
                            hintText: 'يرجى إدخال كلمة المرور الجديدة',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isHiddenPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isHiddenPassword = !_isHiddenPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            } else if (value.length < 6) {
                              return "يجب أن تكون كلمة المرور 6 أحرف على الأقل";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'إعادة كتابة كلمة المرور',
                            style: TextStyle(fontSize: 14, color: Color(0xFF3B726A)),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: retypePasswordController,
                          obscureText: _isHiddenPassword,
                          decoration: InputDecoration(
                            hintText: 'يرجى إعادة كتابة كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            } else if (value != passwordController.text) {
                              return "كلمة المرور غير متطابقة";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formState.currentState!.validate()) {
                                _authentiction_control.cahngePassword(
                                  passwordController.text,
                                  widget.email,
                                  widget.code,
                                  context,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: globalcolor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'تقديم',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
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
