import 'package:edcom/bottom_nav.dart';
import 'package:edcom/home_screen.dart';
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
          if(!snapshot.hasData)  {
            return const Scaffold(
              body: Center(child: Text('the flashcards are listed here')),
            );
          }

          final data = snapshot.requireData;
          final flashcards =
              data.docs.map((doc) => Flashcard.fromSnapshot(doc)).toList();

          return ListView.builder(
            itemCount: flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = flashcards[index];
              return InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const BottomNavBar() // passing the Flashcard object to the Home widget
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
                                  final data = await _flashcardsRef.get();
                                  if (data.docs.isNotEmpty) {
                                    if (index == 0) {
                                      await _flashcardsRef
                                          .doc(data.docs[index].id)
                                          .delete();
                                    } else {
                                      debugPrint('Index out of bounds: $index');
                                    }
                                  } else {
                                    debugPrint('No documents found');
                                  }
                                },
                                child: const Text(
                                  'delete',
                                ),
                              ),
                            ];
                          },
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
