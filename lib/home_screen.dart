import 'package:edcom/model/deck.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_card.dart';
import 'flashcard.dart';
import 'flashcardview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Flashcard>? _cards;
  int _currentIndex = 0;
  double _initial = 0.0;

  void resetFlip() {
    if (flipKey.currentState?.isFront ?? true) {
      flipKey.currentState?.toggleCardWithoutAnimation();
    }
  }

  void nextCard() {
    if (!flipKey.currentState!.isFront) {
      flipKey.currentState!.toggleCardWithoutAnimation();
    }
    // resetFlip();
    setState(() {
      _currentIndex = (_currentIndex + 1) % _cards!.length;
      _initial = (_currentIndex / _cards!.length);
    });
  }

  void prevCard() {
    if (!flipKey.currentState!.isFront) {
      flipKey.currentState!.toggleCardWithoutAnimation();
    }
    // resetFlip();
    setState(() {
      _currentIndex =
          _currentIndex - 1 >= 0 ? _currentIndex - 1 : _cards!.length - 1;
      _initial = (_currentIndex / _cards!.length);
    });
  }

  // void updateToNext() {
  //   setState(() {
  //     _initial = _initial + 0.1;
  //     if (_initial > 1.0) {
  //       _initial = 0.1;
  //     }
  //   });
  // }

  // void updateToPrev() {
  //   setState(() {
  //     _initial = _initial - 0.1;
  //     if (_initial < 0.1) {
  //       _initial = 1.0;
  //     }
  //   });
  // }

  GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();
  FlipCardController flipController = FlipCardController();
  @override
  void initState() {
    super.initState();
    _fetchFlashcards();
  }

  Future<void> _fetchFlashcards() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('Cards').get();
    List<Flashcard> cards = [];
    for (var doc in querySnapshot.docs) {
      cards.add(Flashcard(question: doc['question'], answer: doc['answer']));
    }

    if (cards.isEmpty) {
      cards.add(Flashcard(
          question: 'Flashcards would display here',
          answer: 'Flashcards would display here'));
    }

    setState(() {
      _cards = cards;
    });
  }

  Future<void> _onCardAdded() async {
    await _fetchFlashcards();
  }

  @override
  Widget build(BuildContext context) {
    // If _cards is null, display a progress indicator while we fetch the data from the database.
    if (_cards == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    String value = (_initial * _cards!.length + 1).toStringAsFixed(0);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddCardScreen(
                      onCardAdded: _onCardAdded,
                    )),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Deck()),
              );
            },
            icon: const Icon(Icons.book_rounded),
          ),
        ],
        title: const Text('Quiz Flashcards'),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Card $value of ${_cards!.length} ",
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: SizedBox(
                    height: 300,
                    width: 350,
                    child: FlipCard(
                      key: flipKey,
                      flipOnTouch: true,
                      controller: flipController,
                      direction: FlipDirection.HORIZONTAL,
                      speed: 650,
                      back: FlashCardView(
                        text: _cards![_currentIndex].answer,
                      ),
                      front: FlashCardView(
                        text: _cards![_currentIndex].question,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Tap to reveal answer'),
                const SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor: Colors.lightBlueAccent),
                      onPressed: () {
                        prevCard();
                        // updateToPrev();
                      },
                      child:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      // icon: const Icon(Icons.arrow_forward_ios),
                      // label: const Text('Next'),
                    ),
                    const SizedBox(
                      width: 150,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor: Colors.lightBlueAccent),
                      onPressed: () {
                        nextCard();
                        // updateToNext();
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      // icon: const Icon(Icons.arrow_forward_ios),
                      // label: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
