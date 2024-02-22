import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  static const String baseUrl = 'http://172.20.10.2';

  Future<bool> login(String email, String password) async{

    var json = {
      "mail" : email,
      "password" : password
    };


    final response = await http.post(
        Uri.parse('$baseUrl/User/loginjwt'),
        body: jsonEncode(json)
    );

    if (response.statusCode == 200) {
      await setToken(response.body);
      return true;
    } else {
      return false;
    }
  }

  Future ?setToken(String token) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
  }

  static Future<String?> getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('token');
  }
}