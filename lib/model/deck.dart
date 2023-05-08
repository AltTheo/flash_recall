import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../flashcard.dart';

class Deck extends StatefulWidget {
  const Deck({Key? key}) : super(key: key);

  @override
  _DeckState createState() => _DeckState();
}

class _DeckState extends State<Deck> {
  late final CollectionReference _flashcardsRef;
  late final Stream<QuerySnapshot> _flashcardsStream;

  @override
  void initState() {
    super.initState();
    _flashcardsRef = FirebaseFirestore.instance.collection('Cards');
    _flashcardsStream = _flashcardsRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard deck'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _flashcardsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.requireData;
          final flashcards =
              data.docs.map((doc) => Flashcard.fromSnapshot(doc)).toList();

          return ListView.builder(
            itemCount: flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = flashcards[index];

              return ListTile(
                title: Text(flashcard.question),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit screen
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
