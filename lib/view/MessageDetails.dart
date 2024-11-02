import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:wasl/component/Color.dart';
import 'package:wasl/component/general_URL.dart';
import 'package:wasl/model/MessagesModel.dart';
import 'package:wasl/view/SendReplay.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MessageDetailsPage extends StatefulWidget {
  final NotesModel message;

  const MessageDetailsPage({super.key, required this.message});

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _markMessageAsRead();  // استدعاء الدالة عند تحميل الصفحة
  }

  // تهيئة إعدادات الإشعارات
  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (response) {
      _openDownloadedFile(response.payload);
    });
  }

  // دالة لتعليم الرسالة كمقروءة
  Future<void> _markMessageAsRead() async {
    try {
      Dio dio = Dio();
      await dio.post(
        '$serverUrl/messages/mark/read',
        data: {'message_id': widget.message.id},
      );
      print("تم");
    } catch (e) {
      print('فشل تعليم الرسالة كمقروءة: $e');
    }
  }

  // دالة لتحميل الملف
  Future<void> downloadFile(String url, BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جاري تحميل الملف...')));

      // الحصول على المسار المؤقت للتخزين
      var tempDir = await getTemporaryDirectory();
      String fullPath = "${tempDir.path}/${url.split('/').last}";

      // تحميل الملف باستخدام Dio
      Dio dio = Dio();
      await dio.download(url, fullPath);

      // إظهار إشعار عند اكتمال التنزيل
      await _showDownloadNotification(fullPath);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تحميل الملف بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل تحميل الملف: $e')));
    }
  }

  // دالة لإظهار إشعار عند اكتمال التنزيل
  Future<void> _showDownloadNotification(String filePath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_channel',
      'التنزيلات',
      channelDescription: 'إشعارات تنزيل الملفات',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // معرف الإشعار
      'تم التنزيل',
      'تم تحميل الملف بنجاح. اضغط لفتحه.',
      platformChannelSpecifics,
      payload: filePath, // تمرير مسار الملف كـ payload
    );
  }

  // دالة لفتح الملف عند الضغط على الإشعار
  void _openDownloadedFile(String? filePath) {
    if (filePath != null) {
      File file = File(filePath);
      if (file.existsSync()) {
        // فتح الملف باستخدام تطبيقات النظام
        OpenFile.open(filePath);
      }
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
              Container(
                alignment: Alignment.center,
                child: Image.asset('assets/message2.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadowColor: Colors.green.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 8),
                                Text(
                                  '${widget.message.sender.firstname} ${widget.message.sender.lastname}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${widget.message.createdAt.hour}:${widget.message.createdAt.minute} ${widget.message.createdAt.hour < 12 ? 'AM' : 'PM'}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.message.title,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.message.descriptions,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 20),
                        if (widget.message.attach != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "المرفقات",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () async {
                                  await downloadFile(widget.message.attach!.path, context);
                                },
                                child: Row(
                                  children: [
                                    Image.asset('assets/file.png'),
                                    SizedBox(width: 5),
                                    Text(
                                      widget.message.attach!.name,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 20),
                       SizedBox(height: 20),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // تحقق مما إذا كان الرد غير فارغ
    if (widget.message.replay != null && widget.message.replay!.isNotEmpty) 
      Text(
        widget.message.replay!, // عرض الرد هنا
        style: TextStyle(fontSize: 16, color: Colors.green), // يمكنك تعديل التنسيق كما تشاء
      )
    else 
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SendReplyPage(messageId: widget.message.id.toString())),
          );
        },
        style: ElevatedButton.styleFrom(backgroundColor: globalcolor),
        child: Text('إرسال رد', style: TextStyle(color: Colors.white)),
      ),
  ],
),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                height: 40,
                width: double.infinity,
                color: globalcolor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
