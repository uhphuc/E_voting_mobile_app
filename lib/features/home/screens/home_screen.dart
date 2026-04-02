import 'package:flutter/material.dart';
import 'package:project/features/auth/controllers/auth_provider.dart';
import 'package:project/features/home/screens/room_detail_screen.dart';
import 'package:project/features/home/services/home_service.dart';
import 'package:project/models/room_model.dart';
import 'package:project/services/socket_service.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future<List<RoomModel>> roomsFuture;

  @override
  void initState() {
    super.initState();
    roomsFuture = fetchRooms();

  }


  Future<List<RoomModel>> fetchRooms() async {

    final user = Provider.of<AuthProvider>(context, listen: false).user;

    if (user == null) return [];
    SocketService.initSocket(user.id);



    if (user.role == "manager") {
      return await HomeService.getRoomByManagerId(managerId: user.id);
    } else {
      return await HomeService.getRoomByMemberId(memberId: user.id);
    }
  }


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(

      appBar: AppBar(
        title: Text("Home - ${user?.name} "),
      ),

      body: FutureBuilder<List<RoomModel>>(
        future: roomsFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No rooms available"),
            );
          }

          final rooms = snapshot.data!;

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {

              final room = rooms[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                child: ListTile(

                  title: Text(room.name),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(room.description),
                      const SizedBox(height: 4),
                      Text("Code: ${room.roomCode}"),
                    ],
                  ),

                  trailing: room.isActive
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.cancel, color: Colors.red),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomDetailScreen(room: room),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}