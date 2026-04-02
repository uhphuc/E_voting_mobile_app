import 'dart:convert';
import '../../../core/constants/api_client.dart';


class RoomService {

  static Future<bool> createRoom({
    required String name,
    required String description,
    required int? managerId,
  }) async {

    final response = await ApiClient.post(
      "/rooms",
      {
        "name": name,
        "description": description,
        "managerId": managerId,
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  static Future<bool> joinRoom({
    required String roomCode,
    required int? userId,
  }) async {

    final response = await ApiClient.post(
      "/rooms/join",
      {
        "roomCode": roomCode,
        "userId": userId,
      },
    );

    if (response.statusCode == 201) {


      return true;
    }

    return false;
  }

}