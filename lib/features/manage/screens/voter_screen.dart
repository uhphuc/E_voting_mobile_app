import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:project/features/home/services/home_service.dart';
import 'package:project/features/manage/screens/pending_state_screen.dart';
import 'package:provider/provider.dart';
import '../../auth/controllers/auth_provider.dart';
import '../services/room_service.dart';


class VoterScreen extends StatefulWidget {
  const VoterScreen({super.key});

  @override
  State<VoterScreen> createState() => _VoterScreenState();
}

class _VoterScreenState extends State<VoterScreen> {

  final TextEditingController codeController = TextEditingController();

  bool isLoading = false;
  bool isScanning = false;

  bool isProcessing = false;

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (isProcessing) return;

    final barcode = barcodes.barcodes.firstOrNull;
    final String? code = barcode?.rawValue;

    if (code == null) return;

    isProcessing = true;

    try {
      String roomCode = code;
      int roomId = 0;

      if (code.startsWith("{")) {
        final data = jsonDecode(code);
        roomCode = data["roomCode"];
        roomId = data["roomId"];
      }

      final room = await HomeService.getRoomById(roomId: roomId);
      print("ROOM RESPONSE: $room");

      if (room == null) {
        print("room is NULL");
        throw Exception("Room not found");
      }

      final user = Provider.of<AuthProvider>(context, listen: false).user;

      bool success = await RoomService.joinRoom(
        roomCode: roomCode,
        userId: user?.id,
      );

      if (success) {
        if (!mounted) return;
        setState(() {
          isScanning = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PendingScreen(room: room , userId: user!.id,),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid QR Code")),
        );
        isProcessing = false;
      }

    } catch (e) {
      isProcessing = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("QR format error")),
      );
    }
  }

  Future<void> joinRoom() async {

    String code = codeController.text.trim();
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter room code")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success = await RoomService.joinRoom(
      roomCode: code,
      userId: user?.id,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Send Join Request Successfully")),
      );

      // TODO: navigate to home for pending detail
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid room code")),
      );

    }
  }
  Widget _buildScanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),

          // overlay scan box
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),

          // nút tắt camera
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  isScanning = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Room"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            const Center(
              child: Text(
                "Or scan QR code",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isScanning
                  ? _buildScanner()
                  : GestureDetector(
                onTap: () {
                  setState(() {
                    isScanning = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Tap to Scan QR Code",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              "Enter Room Code",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Example: ABC123",
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: isLoading ? null : joinRoom,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Join Room"),
            ),


          ],
        ),
      ),
    );
  }
}