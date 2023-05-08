import 'package:flutter/material.dart';

class FlashCardView extends StatelessWidget {
  final String text;
  const FlashCardView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.lightBlueAccent,
        elevation: 40.0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              text,
              style: const TextStyle(fontSize: 25, color: Colors.black),
            ),
          ),
        ));
  }
}
