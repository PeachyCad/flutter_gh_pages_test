import 'package:flutter/material.dart';

class TextFragment extends StatelessWidget {
  final String text;
  final bool isOverflowClip;

  const TextFragment({
    super.key,
    required this.text,
    required this.isOverflowClip,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, color: Colors.white),
      overflow: isOverflowClip ? TextOverflow.clip : TextOverflow.ellipsis,
    );
  }
}
