
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasl/auth/login.dart';
import 'package:wasl/component/general_URL.dart';
import 'dart:convert';

import 'package:wasl/view/HomePage.dart';



// ignore: camel_case_types
class Authentiction_Control {
  login(context, String email, String password,) async {
    var myUrl = Uri.parse("$serverUrl/login");
    print(email+password);
    print(myUrl);
    final response = await http.post(myUrl, body: {
      "email": "$email",
      "password": "$password",
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode==200) {
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                 HomePage()), (Route<dynamic> route) => false);
                              
       var body = jsonDecode(response.body)['user'];
      //  print("ss");
      //  print(orders);
         _save(json.decode(response.body)['user']['id'].toString());

    } else if(response.statusCode==404){
     return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'السيرفر لا يستجيب',
        desc: 'تأكد من السيرفر',
        btnOkOnPress: () {},
      )..show();
    }
    
    else if(response.statusCode==401){
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'الحساب غير موجود',
        desc: 'تأكد من صحة البيانات',
        btnOkOnPress: () {},
      )..show();
    }else{
       return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'انترنت',
        desc: 'تاكد من الاتصال بالانترنت',
        btnOkOnPress: () {},
      )..show();
    }
  }

  _save(String token)async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
     prefs.setString(key, value);
    print("saved");
  



  }

  Future sendEmail(String email, context) async {
    var myUrl = Uri.parse("$serverUrl/users/forget-password/send-code");
    final response = await http.post(myUrl, body: {
      "email": email,
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title:  "حصل خطا",
        // btnOkOnPress: () {},
      ).show();
    }
  }

  Future sendcodeverffcaion(String email, String code, context) async {
    var myUrl = Uri.parse("$serverUrl/users/forget-password/verify-code");
    final response = await http.post(myUrl, body: {
      "email": email,
      "token": code,
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title:"الكود غير صحيح",
        // btnOkOnPress: () {},
      ).show();
    }
  }

  Future cahngePassword(
      String password, String email, String code, context) async {
    var myUrl = Uri.parse("$serverUrl/users/reset-password");
    final response = await http.post(myUrl,
        body: {"new_password": password, "token": code, "email": email});
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: "تمت العملية بنجاح" ,
        // btnOkOnPress: () {},
      ).show();
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return LoginPage();
        }));
      });
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "حدث خطأ ما" ,
        // btnOkOnPress: () {},
      ).show();
    }
  }

}
