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
  final FocusNode questionfocusNode = FocusNode();
  final FocusNode answerfocusNode = FocusNode();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  snackbar(String data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data),
        dismissDirection: DismissDirection.startToEnd,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void saveCard() async {
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();

    if (question.isEmpty || answer.isEmpty) return;

    questionfocusNode.unfocus();
    answerfocusNode.unfocus();
    _answerController.text = '';
    _questionController.text = '';
    await firestore.collection('Cards').add({
      'question': question,
      'answer': answer,
      'timestamp': FieldValue.serverTimestamp(),
    });
    snackbar('Flashcard added successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Card')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 28),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                focusNode: questionfocusNode,
                onFieldSubmitted: (value) {
                  fieldFocusChange(context, questionfocusNode, answerfocusNode);
                },
                textInputAction: TextInputAction.next,
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
                focusNode: answerfocusNode,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                controller: _answerController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: 'Answer',
                ),
                maxLines: 4,
              ),
              const SizedBox(
                height: 38,
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
      ),
    );
  }
}
