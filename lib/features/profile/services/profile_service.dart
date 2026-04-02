import 'dart:convert';
import '../../../core/constants/api_client.dart';
import '../../../models/user_info_model.dart';

class ProfileService {
  static Future<UserInfoModel?> getUserProfile({
    required int id,
    required String token,
  }) async {
    try {
      final response = await ApiClient.get(
        "/users/$id",
        token: token,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return UserInfoModel.fromJson(data["user"]);
      } else {
        print("API ERROR: ${response.body}");
        return null;
      }
    } catch (e) {
      print("SERVICE ERROR: $e");
      return null;
    }
  }
}