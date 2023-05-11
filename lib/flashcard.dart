import 'package:cloud_firestore/cloud_firestore.dart';

class Flashcard {
  Flashcard({required this.answer, required this.question});

  factory Flashcard.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final question = data['question'] as String;
    final answer = data['answer'] as String;
    return Flashcard(question: question, answer: answer);
  }

  final String answer;
  final String question;
}
