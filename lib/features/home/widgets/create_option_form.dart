import 'package:flutter/material.dart';
import 'package:project/features/home/services/room_detail_service.dart';

class CreateOptionForm extends StatefulWidget {


  final int roomId;

  const CreateOptionForm({
    super.key,
    required this.roomId,
  });


  @override
  State<CreateOptionForm> createState() => _CreateOptionSheetState();
}

  class _CreateOptionSheetState extends State<CreateOptionForm> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> createOption() async {

    bool response = await RoomDetailService.createOption(
        name: nameController.text,
        description: descriptionController.text,
        roomId: widget.roomId);

    if (response) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 20,
      right: 20,
      top: 20,
    ),

    child: Form(
    key: formKey,

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [

          const Text(
            "Create Option",
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Option Name",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter option name";
              }
              return null;
            },
          ),

          const SizedBox(height: 15),

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
                if (!formKey.currentState!.validate()) return;
                createOption();
              },
              child: const Text("Create Option"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
    );
  }
}