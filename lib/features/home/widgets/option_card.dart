import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/option_model.dart';
import '../../auth/controllers/auth_provider.dart';

class OptionCard extends StatelessWidget {
  final OptionModel option;
  final bool isSelected;
  final bool hasVoted;
  final VoidCallback onToggle;

  const OptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.hasVoted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(option.name),
        subtitle: Text(option.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${option.sum}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 8),

            if (!hasVoted && user?.role == "voter" )
              Checkbox(
                value: isSelected,
                onChanged: (_) => onToggle(),
              )
            else if (hasVoted && user?.role == "voter" )
              Icon(Icons.check_circle, color: Colors.green,)
          ],
        ),
      )
    );
  }
}