import 'dart:convert';

import 'package:project/models/announcement_model.dart';

import '../../../core/constants/api_client.dart';

class AnnouncementService {
  static Future<List<AnnouncementModel>> getAnnouncementForUser({required int? userId}) async {
    final response = await ApiClient.get("/announcements/$userId");
    if (response.statusCode == 201 || response.statusCode == 200){
      final data = jsonDecode(response.body);
      List users = data['announcements'];

      return users.map((e) => AnnouncementModel.fromJson(e)).toList();
    }
    return [];
  }
}