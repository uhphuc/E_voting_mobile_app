import 'dart:convert';
import '../../../core/constants/api_client.dart';
import '../../../models/room_model.dart';

class HomeService {
  static Future<List<RoomModel>> getRoomByManagerId({required int? managerId}) async {
    final response = await ApiClient.get(
      "/rooms/manager/$managerId"
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      List rooms = data["room"];
      return rooms.map((e) => RoomModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<RoomModel>> getRoomByMemberId({required int? memberId}) async {
    final response = await ApiClient.get(
        "/rooms/members/$memberId"
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      List rooms = data["rooms"];
      return rooms.map((e) => RoomModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<RoomModel?> getRoomById({required int? roomId}) async {

    try {
      final response = await ApiClient.get("/rooms/$roomId");

      final data = jsonDecode(response.body);

      return RoomModel.fromJson(data["room"][0]);
    } catch (e) {
      print("API INNER ERROR: $e");
      return null;
    }
  }

}