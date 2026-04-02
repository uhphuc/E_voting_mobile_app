import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/models/room_model.dart';
import 'package:project/models/user_model.dart';
import 'package:project/features/home/services/room_info_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../auth/controllers/auth_provider.dart';

class RoomInfoScreen extends StatefulWidget {
  final RoomModel room;

  const RoomInfoScreen({
    super.key,
    required this.room,
  });

  @override
  State<RoomInfoScreen> createState() => _RoomInfoScreenState();
}

class _RoomInfoScreenState extends State<RoomInfoScreen> {

  late Future<List<UserModel?>> pendingFuture;
  late Future<List<UserModel?>> approvedFuture;

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  void loadMembers() {
    pendingFuture = RoomInfoService.getPendingMembers(roomId: widget.room.id);
    approvedFuture = RoomInfoService.getApprovedMembers(roomId: widget.room.id);
  }


  void showQrDialog() {
    final inviteData = {
      "roomId": widget.room.id,
      "roomCode": widget.room.roomCode,
      "role": "voter",
    };

    final inviteJson = jsonEncode(inviteData);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Scan to Join Room"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: inviteJson,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Share.share(inviteJson);
              },
              icon: const Icon(Icons.share),
              label: const Text("Share"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> approveUser(int? userId) async {

    bool success = await RoomInfoService.approveVoter(
      userId: userId,
      roomId: widget.room.id,
      approved: true,
    );

    if (success) {
      setState(() {
        loadMembers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Information"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ROOM INFO
            Text(
              widget.room.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("Description: ${widget.room.description}"),

            const SizedBox(height: 10),

            Text("Room Code: ${widget.room.roomCode}"),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                showQrDialog();
              },
              icon: const Icon(Icons.qr_code),
              label: const Text("Generate QR Code"),
            ),

            const SizedBox(height: 30),

            /// PENDING MEMBERS
            if(user?.role == "manager")
              const Text(
                "Pending Members",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
            if(user?.role == "manager")
              FutureBuilder<List<UserModel?>>(
                future: pendingFuture,
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final users = snapshot.data ?? [];

                  if (users.isEmpty) {
                    return const Text("No pending members");
                  }

                  return Column(
                    children: users.map((user) {

                      if (user == null) return const SizedBox();

                      return Card(
                        child: ListTile(
                          title: Text(user.name ?? "No name"),
                          subtitle: Text(user.email ?? ""),
                          trailing: ElevatedButton(
                            onPressed: () {
                              approveUser(user.id);
                            },
                            child: const Text("Approve"),
                          ),
                        ),
                      );

                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

            /// APPROVED MEMBERS
            const Text(
              "Approved Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            FutureBuilder<List<UserModel?>>(
              future: approvedFuture,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data ?? [];

                if (users.isEmpty) {
                  return const Text("No approved members");
                }

                return Column(
                  children: users.map((user) {

                    if (user == null) return const SizedBox();

                    return Card(
                      child: ListTile(
                        title: Text(user.name ?? "No name"),
                        subtitle: Text(user.email ?? ""),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    );

                  }).toList(),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}