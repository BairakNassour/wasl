import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasl/component/Color.dart';
import 'package:wasl/controller/NotificationController.dart';
import 'package:wasl/model/NotificationModel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> notifications = [];
  final NotificationController notificationController = NotificationController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      List<NotificationModel>? fetchedNotifications = await notificationController.fetchNotifications();
      setState(() {
        notifications = fetchedNotifications!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في جلب الإشعارات: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // الجزء العلوي
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
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
      
          
      
            // عنوان "الإشعارات"
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
                      "الإشعارات",
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
      
            // قائمة الإشعارات
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: globalcolor))
                  : notifications.isNotEmpty
                      ? ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Card(
                              elevation: 4,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              shadowColor: Colors.green.shade900,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(notification.senderImage ?? ''),
                                ),
                                title: Text(notification.title ?? 'بدون عنوان'),
                                subtitle: Text(notification.text),
                                trailing: Text(
                                          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(notification.createdAt)),
                                        ),
       
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'لا توجد إشعارات',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
            ),
      
            // الجزء السفلي الأخضر
            Container(
              height: 40,
              width: double.infinity,
              color: globalcolor,
            ),
          ],
        ),
      ),
    );
  }
}
