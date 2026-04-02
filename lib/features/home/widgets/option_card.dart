import 'package:flutter/material.dart';
import 'package:project/models/key_model.dart';
import 'package:project/features/home/services/room_detail_service.dart';
import 'package:project/services/paillier_service.dart';
import 'package:provider/provider.dart';
import '../../../models/option_model.dart';
import '../../auth/controllers/auth_provider.dart';

class OptionCard extends StatefulWidget {
  final OptionModel option;
  final int? roomId;
  final KeyModel publicKey;

  const OptionCard({
    super.key,
    required this.option,
    required this.roomId,
    required this.publicKey,
  });

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {

  bool isVoting = false;
  bool isVoted = false;

  Future<void> handleVote() async {

    setState(() {
      isVoting = true;
    });

    try {

      final cipher = PaillierService.encryptVote(widget.publicKey, true);

      await RoomDetailService.sendVote(
        roomId: widget.roomId,
        optionId: widget.option.id,
        encryptedVote: cipher,
      );

      setState(() {
        isVoted = true;
      });

    } catch (e) {
      print("Vote error: $e");
    }

    setState(() {
      isVoting = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuthProvider>(context, listen: false).user;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              widget.option.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              widget.option.description,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  "Votes: ${widget.option.sum}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (user?.role == "voter")
                  ElevatedButton(
                    onPressed: (isVoted || isVoting)
                        ? null
                        : handleVote,
                    child: isVoting
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : Text(isVoted ? "Voted" : "Vote"),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}