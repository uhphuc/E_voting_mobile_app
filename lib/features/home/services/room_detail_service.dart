import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:project/models/option_model.dart';

import '../../../core/constants/api_client.dart';
import '../../../services/socket_service.dart';

class RoomDetailService {
  static Future<bool> createOption({
    required String name,
    required String description,
    required int? roomId,
  }) async {

    final response = await ApiClient.post(
      "/options",
      {
        "name": name,
        "description": description,
        "roomId": roomId,
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }
  static Future<List<OptionModel>> getOptionByRoomId({required int? roomId}) async {
    final response = await ApiClient.get(
        "/options/room/$roomId"
    );
    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      List options = data["options"];
      return options.map((e) => OptionModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<bool> sendVote({
    required int? roomId,
    required int? optionId,
    required String encryptedVote
  }) async {
    final response = await ApiClient.post(
      "/votes/",
      {
        "roomId" : roomId,
        "optionId" : optionId,
        "encryptedVote" : encryptedVote
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }
  static void joinRoom(int roomId) {
    SocketService.socket.emit("join_room", roomId);
  }

  static void onVoteResultsUpdated(Function(Map<String, dynamic>) callback) {
    SocketService.socket.on("vote_results_updated", (data) {
      final results = Map<String, dynamic>.from(data["results"]);
      callback(results);
    });
  }

  static Future<Map<String, dynamic>?> getVoteResults({
    required int roomId,
  }) async {
    try {
      final response = await ApiClient.get(
        "/votes/results/$roomId"
      );

      final data = jsonDecode(response.body);

      if (data["success"]) {
        return Map<String, dynamic>.from(data["results"]);
      }
    } catch (e) {
      print("Error getVoteResults: $e");
    }
    return null;
  }

  static void disposeListener() {
    SocketService.socket.off("vote_results_updated");
  }
}