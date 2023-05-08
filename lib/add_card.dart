import 'package:edcom/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCardScreen extends StatefulWidget {
  final Function onCardAdded;
  const AddCardScreen({Key? key, required this.onCardAdded}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void saveCard() async {
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();

    if (question.isEmpty || answer.isEmpty) return;
    await firestore.collection('Cards').add({
      'question': question,
      'answer': answer,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Card')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 28),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _questionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                labelText: 'Question',
              ),
              maxLines: 4,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              controller: _answerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                labelText: 'Answer',
              ),
              maxLines: 4,
            ),
            const SizedBox(
              height: 18,
            ),
            SingleChildScrollView(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 8, backgroundColor: Colors.lightBlueAccent),
                  onPressed: () {
                    saveCard();
                  },
                  child: const Text(
                    'Save card',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
