import 'package:flutter/material.dart';
import 'package:project/features/auth/controllers/auth_provider.dart';
import 'package:project/features/manage/services/room_service.dart';
import 'package:provider/provider.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> createRoom() async {

    final user = Provider.of<AuthProvider>(context, listen: false).user;

    bool success = await RoomService.createRoom(
        name: nameController.text,
        description: descriptionController.text,
        managerId: user?.id);

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room created successfully")),
      );

      nameController.clear();
      descriptionController.clear();

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create room")),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Manager Room"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(

            children: [

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Room Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter room name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    if (_formKey.currentState!.validate()) {
                      createRoom();
                    }

                  },
                  child: const Text("Create Room"),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}