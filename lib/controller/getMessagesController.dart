import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasl/component/general_URL.dart';
import 'package:wasl/model/MessagesModel.dart';

class MessageController {
  // دالة لجلب الرسائل
  Future<List<NotesModel>?> fetchMessages() async {
    String myUrl = "$serverUrl/messages/user";
    
    // جلب التوكن
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) {
      print("No token found in preferences.");
      return null;
    }

    // إرسال الطلب لجلب الرسائل مع التوكن كـ user_id في body
  
      http.Response response = await http.post(
        Uri.parse(myUrl),
        body: {
          'user_id': token,  // التوكن يُرسل هنا
        },
      );

      print(response.body);
      print(response.statusCode); // للطباعة فقط

      if (response.statusCode == 200) {
         List body = jsonDecode(response.body)['data'];
        List<NotesModel> orders = body
            .map(
              (dynamic item) => NotesModel.fromJson(item),
            )
            .toList();
       
        print(body);
        return orders.reversed.toList();
      } else {
        print("Failed to load messages: ${response.statusCode}");
        return null;
      }
   
  }
}
