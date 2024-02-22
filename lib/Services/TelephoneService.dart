import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phone/Model/Telephone.dart';
import 'package:phone/Services/AuthService.dart';

class TelephoneService {
  //static const String baseUrl = 'http://10.176.131.96';
  static const String baseUrl = 'http://172.20.10.2';
  //changement d'IP V4 WIFI ICI

  Future<List<Telephone>> getAllTelephones() async {
    final response = await http.get(Uri.parse('$baseUrl/ApiTelephone/getAll'));

    if (response.statusCode == 200) {
      var datas = jsonDecode(response.body);
      List<Telephone> telephones = [];
      for (var data in datas) {
        telephones.add(Telephone.fromJson(data));
      }
      return telephones;
    } else {
      throw Exception('Failed to load telephones');
    }
  }

  //Requet ADD
  Future<int> addTelephone(Map<String, dynamic> telephoneData) async {
    String? token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ApiTelephone/add'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(telephoneData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['Id'];
    } else {
      throw Exception('Failed to add telephone');
    }
  }

  Future<List<dynamic>> searchTelephones(String keyword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({'keyword': keyword}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search telephones');
    }
  }
}
