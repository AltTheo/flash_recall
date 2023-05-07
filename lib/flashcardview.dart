import 'package:flutter/material.dart';

class FlashCardView extends StatelessWidget {
  final String text;
  const FlashCardView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 25),
          ),
        ));
  }
}
