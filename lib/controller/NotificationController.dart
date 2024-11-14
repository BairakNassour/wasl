import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasl/component/general_URL.dart';
import 'package:wasl/model/NotificationModel.dart';

class NotificationController {
  // دالة لجلب الإشعارات
  Future<List<NotificationModel>?> fetchNotifications() async {
    String myUrl = "$serverUrl/notifications/user";

    // جلب التوكن
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('token'); // الحصول على user_id من SharedPreferences

    if (userId == null) {
      print("No user_id found in preferences.");
      return null;
    }

    // إرسال الطلب لجلب الإشعارات مع user_id كـ body
    try {
      http.Response response = await http.post(
        Uri.parse(myUrl),
        body: {
          'user_id': userId,  // user_id يُرسل هنا
        },
      );

      print(response.body); // للطباعة فقط

      if (response.statusCode == 200) {
        List body = jsonDecode(response.body)['data'];
        return body.map((dynamic item) => NotificationModel.fromJson(item)).toList().reversed.toList();
      } else {
        print("Failed to load notifications: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error fetching notifications: $error");
      return null;
    }
  }
}
