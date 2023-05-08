import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

import 'flashcard.dart';
import 'flashcardview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Flashcard> _cards = [
    Flashcard(question: 'What year was the pandemic', answer: '2020'),
    Flashcard(
        question: 'Who is your favourite lecturer', answer: 'Haythem Nakkas'),
    Flashcard(question: 'What is your favourite module', answer: 'EDCOM'),
    Flashcard(question: 'Who is the prime minister', answer: 'oreehh'),
    Flashcard(
        question: 'Who is the best footballer', answer: 'Cristiano Ronaldo'),
    Flashcard(question: 'What is the capital of Nigeria', answer: 'Abuja'),
    Flashcard(
        question: 'Who is the president of the United states',
        answer: 'Joe Biden'),
    Flashcard(
        question: 'What is a good research tool',
        answer: 'EBSCO discovery service'),
    Flashcard(
        question:
            'What is the best programming language for mobile development',
        answer: 'Flutter'),
  ];

  int currentIndex = 0;
  double _initial = 1;

  void resetFLip() {
    flipKey.currentState?.toggleCard();
  }

  void nextCard() {
    // resetFLip();
    setState(() {
      currentIndex = (currentIndex + 1) % _cards.length;
      // resetFLip();
    });
    // Reset flip direction to show front of card
  }

  void prevCard() {
    setState(() {
      currentIndex =
          currentIndex - 1 >= 0 ? currentIndex - 1 : _cards.length - 1;
      // resetFLip();
    });
    // Reset flip direction to show front of card
  }

  void updateToNext() {
    setState(() {
      _initial = _initial + 0.1;
      if (_initial > 1.0) {
        _initial = 0.1;
      }
    });
  }

  void updateToPrev() {
    setState(() {
      _initial = _initial - 0.1;
      if (_initial < 0.1) {
        _initial = 1.0;
      }
    });
  }

  GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();
  FlipCardController flipController = FlipCardController();
  @override
  Widget build(BuildContext context) {
    String value = (_initial * 10).toStringAsFixed(0);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
        backgroundColor: Colors.lightBlue,
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
                Text("Question $value of 10 Completed",
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation(Colors.lightBlue),
                    minHeight: 5,
                    value: _initial,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: SizedBox(
                    height: 300,
                    width: 350,
                    child: FlipCard(
                      autoFlipDuration: const Duration(seconds: 1),
                      key: flipKey,
                      flipOnTouch: true,
                      controller: flipController,
                      direction: FlipDirection.HORIZONTAL,
                      speed: 250,
                      back: FlashCardView(
                        text: _cards[currentIndex].answer,
                      ),
                      front: FlashCardView(
                        text: _cards[currentIndex].question,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Tap to reveal answer'),
                const SizedBox(
                  height: 80.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 8, backgroundColor: Colors.blue),
                      onPressed: () {
                        prevCard();
                        updateToPrev();
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
                          elevation: 8, backgroundColor: Colors.blue),
                      onPressed: () {
                        nextCard();
                        updateToNext();
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
