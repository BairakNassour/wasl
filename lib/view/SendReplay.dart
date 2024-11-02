import 'package:flutter/material.dart';
import 'package:wasl/component/Color.dart';
import 'package:dio/dio.dart';
import 'package:wasl/component/general_URL.dart';
import 'package:wasl/view/HomePage.dart';

class SendReplyPage extends StatefulWidget {
  final String messageId; // إضافة معرف الرسالة
  const SendReplyPage({super.key, required this.messageId});

  @override
  _SendReplyPageState createState() => _SendReplyPageState();
}

class _SendReplyPageState extends State<SendReplyPage> {
  final TextEditingController _replyController = TextEditingController(); // للتحكم في حقل الرد
  bool isLoading = false; // متغير للتحكم في حالة التحميل

  Future<void> sendReply() async {
    String reply = _replyController.text;

    if (reply.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال محتوى الرد')),
      );
      return;
    }

    setState(() {
      isLoading = true; // بدء التحميل
    });

    try {
      // إعداد Dio
      Dio dio = Dio();

      // إرسال الطلب
      Response response = await dio.post(
        '$serverUrl/messages/replay/send',
        data: {
          'message_id': widget.messageId, // إرسال معرف الرسالة
          'replay': reply, // إرسال محتوى الرد
        },
      );

      // تحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إرسال الرد بنجاح')),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في إرسال الرد')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // انتهاء التحميل
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // الجزء العلوي مع الخلفية
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/background.png',
                        fit: BoxFit.fill,
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
                  ],
                ),

                // صورة الرسالة
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Image.asset('assets/message.png'),
                ),

                // الخط الأخضر مع النص "إرسال رد"
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: globalcolor,
                      margin: EdgeInsets.symmetric(vertical: 8),
                    ),
                    Center(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "إرسال رد",
                          style: TextStyle(
                            color: globalcolor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // محتوى الرسالة
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: Colors.green.shade900,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // حقل محتوى الرد
                          Text(
                            'محتوى الرد',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextField(
                            controller: _replyController, // تعيين المتحكم
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: globalcolor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: globalcolor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // زر إرسال
                          Center(
                            child: ElevatedButton(
                              onPressed: isLoading // تعطيل الزر أثناء التحميل
                                  ? null
                                  : sendReply, // استدعاء دالة الإرسال
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'إرسال',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: globalcolor,
                                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Spacer to push the green bar to the bottom
                Spacer(),

                // الجزء السفلي الأخضر
                Container(
                  height: 40,
                  width: double.infinity,
                  color: globalcolor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
