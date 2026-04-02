import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/models/announcement_model.dart';
import 'package:project/services/socket_service.dart';
import 'package:provider/provider.dart';
import '../../auth/controllers/auth_provider.dart';
import '../services/announcement_service.dart';
import 'dart:async';

class AnnouncementScreen extends StatefulWidget{
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreen();
}
class _AnnouncementScreen extends State<AnnouncementScreen> {

  late List<AnnouncementModel> announlist  = [];
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    fetchAnnouncement();
    initSocket();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {});
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    SocketService.socket.off("notification");
  }
  void initSocket() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) return;

    SocketService.socket.on("notification", (data) {
      print("Socket Data: $data");
      final mapData = jsonDecode(jsonEncode(data));
      final newItem = AnnouncementModel.fromJson(mapData);

      setState(() {
        announlist.insert(0, newItem);
      });
    });
  }
  Future<void> fetchAnnouncement() async {

    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) return;

    final data = await AnnouncementService.getAnnouncementForUser(userId: user.id);
    setState(() {
      announlist = data;
    });
  }
  String formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${diff.inDays} days ago";
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: announlist.isEmpty
          ? const Center(child: Text("No Notification Found"))
          : ListView.separated(
        itemCount: announlist.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final item = announlist[index];

          final isRead = item.isRead;

          return ListTile(
            onTap: () {
              // TODO: handle click
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.notifications,
                color: Colors.blue,
              ),
            ),
            title: Text(
              item.title,
              style: TextStyle(
                fontWeight:
                isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.message),
                const SizedBox(height: 4),
                Text(
                  formatTime(item.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: isRead
                ? null
                : Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}