import 'package:flutter/material.dart';
import 'package:project/core/storage/token_storage.dart';
import 'package:project/features/home/screens/room_info_screen.dart';
import 'package:project/features/home/services/room_detail_service.dart';
import 'package:project/features/home/widgets/create_option_form.dart';
import 'package:project/models/key_model.dart';
import 'package:project/models/option_model.dart';
import 'package:project/models/room_model.dart';
import 'package:project/services/crypto_service.dart';
import 'package:provider/provider.dart';

import '../../auth/controllers/auth_provider.dart';
import '../widgets/option_card.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomModel room;

  const RoomDetailScreen({
    super.key,
    required this.room,
  });

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {

  bool isLoading = true;

  List<OptionModel> options = [];
  KeyModel? publicKey;

  @override
  void initState() {
    super.initState();
    initRoom();
  }

  Future<void> initRoom() async {
    try {

      final fetchedOptions = await RoomDetailService.getOptionByRoomId(
        roomId: widget.room.id,
      );

      final key = await CryptoService.getPublicKey();

      if (key == null) {
        throw Exception("Public key not found");
      }

      setState(() {
        options = fetchedOptions;
        publicKey = key;
        isLoading = false;
      });

    } catch (e) {
      print("Room init error: $e");
    }
  }
  Future<void> handleUpdateResults() async {
    try {
      // gọi API backend để trigger update
      await RoomDetailService.getVoteResults(
        roomId: widget.room.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Results updated")),
      );
    } catch (e) {
      print("Update error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuthProvider>(context, listen: false).user;

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.room.name),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          if (user?.role == "manager")
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await handleUpdateResults();
              },
            ),

          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoomInfoScreen(room: widget.room),
                ),
              );
            },
          )
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : options.isEmpty
          ? const Center(child: Text("No options yet"))
          : ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {

          final option = options[index];

          return OptionCard(
            option: option,
            roomId: widget.room.id,
            publicKey: publicKey!,
          );
        },
      ),

      floatingActionButton: user?.role == "manager"
          ? FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => CreateOptionForm(
              roomId: widget.room.id,
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}