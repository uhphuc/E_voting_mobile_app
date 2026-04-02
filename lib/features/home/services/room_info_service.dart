import 'dart:convert';
import '../../../core/constants/api_client.dart';
import '../../../models/user_model.dart';

class RoomInfoService {
  static Future<List<UserModel?>> getPendingMembers({required int? roomId}) async {
    final response = await ApiClient.get("/rooms/pending/$roomId");
    if (response.statusCode == 201 || response.statusCode == 200){
      final data = jsonDecode(response.body);
      List users = data['pendingMembers'];

      return users.map((e) => UserModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<UserModel?>> getApprovedMembers({required int? roomId}) async {
    final response = await ApiClient.get("/rooms/approved/$roomId");
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      List users = data['approvedMembers'];
      return users.map((e) => UserModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<bool> approveVoter({
    required int? userId,
    required int? roomId,
    required bool approved
  }) async {

    final response = await ApiClient.put(
      "/rooms/approve",
      {
        "roomId": roomId,
        "userId": userId,
        "approved": approved
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }
  static Future<bool> checkApproved({required int roomId, required int userId}) async {
    print("Hit API Call");
    final res = await ApiClient.get("/rooms/checkApproved/$roomId/$userId");

    if (res.statusCode == 200 || res.statusCode == 201){
      final data = jsonDecode(res.body);
      print(data['isApproved']);
      return data['isApproved'];
    }
    return false;
  }
}