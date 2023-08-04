import 'package:flutter/material.dart';

class EditDeleteButtons extends StatelessWidget {
  final Function() onPressedEdit;
  final Function() onPressedDelete;

  const EditDeleteButtons({
    super.key,
    required this.onPressedEdit,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(
              Icons.edit_note_rounded,
              size: 30,
            ),
            color: Colors.white,
            onPressed: () => onPressedEdit()),
        IconButton(
            icon: const Icon(
              Icons.close_rounded,
              size: 30,
            ),
            color: Colors.white,
            onPressed: () => onPressedDelete()),
      ],
    );
  }
}
