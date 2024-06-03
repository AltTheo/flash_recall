import 'package:edcom/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../flashcard.dart';

class Deck extends StatefulWidget {
  const Deck({Key? key}) : super(key: key);

  @override
  DeckState createState() => DeckState();
}

class DeckState extends State<Deck> {
  late final CollectionReference _flashcardsRef;

  @override
  void initState() {
    super.initState();
    _flashcardsRef = FirebaseFirestore.instance.collection('Cards');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard deck'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _flashcardsRef.snapshots(),
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
              final docId = data.docs[index].id;
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) async {
                  await _flashcardsRef.doc(docId).delete();
                  setState(() {
                    flashcards.removeAt(index);
                  });
                },
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BottomNavBar(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.lightBlueAccent,
                      elevation: 10.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 10.0),
                        child: ListTile(
                          title: Text(
                            flashcard.question,
                            style: const TextStyle(fontSize: 20),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () {},
                                  child: const Text(
                                    'Edit',
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  onTap: () async {
                                    await _flashcardsRef.doc(docId).delete();
                                    setState(() {
                                      flashcards.removeAt(index);
                                    });
                                  },
                                  child: const Text(
                                    'Delete',
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
