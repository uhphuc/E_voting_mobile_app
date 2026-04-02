import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project/features/home/services/room_info_service.dart';
import 'package:project/models/room_model.dart';

class PendingScreen extends StatefulWidget {
  final RoomModel room;
  final int userId;

  const PendingScreen({
    super.key,
    required this.room,
    required this.userId,
  });

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  bool isLoading = true;
  bool isApproved = false;

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    setState(() {
      isLoading = true;
    });

    bool approved = await RoomInfoService.checkApproved(
      roomId: widget.room.id,
      userId: widget.userId,
    );

    if (!mounted) return;

    setState(() {
      isApproved = approved;
      isLoading = false;
    });

    if (approved) {
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacementNamed(
        context,
        "/room-detail",
        arguments: widget.room,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Waiting for Approval"),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : isApproved
            ? const Text(
          "Approved! Redirecting...",
          style: TextStyle(fontSize: 18, color: Colors.green),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
            const SizedBox(height: 20),

            const Text(
              "Request Sent!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "You’ve requested to join",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 6),

            Text(
              widget.room.name ?? "Unknown Room",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Please wait for manager approval.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: checkStatus,
              child: const Text("Check again"),
            ),
          ],
        )
      ),
    );
  }
}