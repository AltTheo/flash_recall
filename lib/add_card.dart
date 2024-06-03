import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key, required this.onCardAdded}) : super(key: key);

  final Function onCardAdded;

  @override
  AddCardScreenState createState() => AddCardScreenState();
}

class AddCardScreenState extends State<AddCardScreen> {
  final FocusNode answerfocusNode = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FocusNode questionfocusNode = FocusNode();

  final _answerController = TextEditingController();
  final _questionController = TextEditingController();

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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 10,
                child: TextFormField(
                  focusNode: questionfocusNode,
                  onFieldSubmitted: (value) {
                    fieldFocusChange(
                        context, questionfocusNode, answerfocusNode);
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: _questionController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(),
                    focusColor: Colors.lightBlue,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    labelText: 'Question',
                  ),
                  maxLines: 4,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Card(
                color: Colors.white,
                elevation: 10,
                child: TextFormField(
                  onEditingComplete: () {
                    saveCard();
                  },
                  focusNode: answerfocusNode,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: _answerController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(),
                    focusColor: Colors.lightBlue,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    labelText: 'Answer',
                  ),
                  maxLines: 4,
                ),
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
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
