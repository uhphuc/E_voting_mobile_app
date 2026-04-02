import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/core/constants/api_constants.dart';
import 'package:project/core/storage/token_storage.dart';
import 'package:project/features/auth/controllers/auth_provider.dart';
import 'package:project/models/user_info_model.dart';
import 'package:project/models/user_model.dart';
import 'package:provider/provider.dart';

class AuthService {

  static const String apiUrl = "${ApiConstants.baseUrl}/auth";
  static Future<UserInfoModel?> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String gender,
    required String role,
    required DateTime birthDate,
    required String address
  }) async {
    final res = await http.post(
      Uri.parse("$apiUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name,
        "phone": phone,
        "gender": gender,
        "role": role,
        "birthDate": "${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
        "address": address
      }),
    );
    print(res.statusCode);
    final error = jsonDecode(res.body);
    print(error["error"]);

    if (res.statusCode == 200){
      final data = jsonDecode(res.body);
      print(data);
      return UserInfoModel.fromJson(data);
    }
    return null;
  }
  static Future<UserModel?> login(String email, String password) async {

    final response = await http.post(
      Uri.parse("$apiUrl/login"),
      headers: { "Content-Type" : "application/json",},
      body: jsonEncode({
        "email": email,
        "password": password,
      })
    );
    final data = jsonDecode(response.body);
    if(data["success"]){
      await TokenStorage.saveToken(data["token"]);
      return UserModel.fromJson(data["user"]);
    }
    return null;
  }
  static Future<UserModel?> getMe() async{
    final token = await TokenStorage.getToken();
    if(token == null) return null;
    final response = await http.get(
      Uri.parse("$apiUrl/getme"),
      headers: {"Authorization": "Bearer $token"}
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data["user"]);
    }
    return null;
  }
  static Future<void> logOut() async {
    await TokenStorage.clearToken();
  }
}