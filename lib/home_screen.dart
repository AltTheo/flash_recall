import 'package:edcom/auth/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bottom_nav.dart';
import 'flashcard.dart';
import 'flashcardview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Flashcard>? _cards;
  int _currentIndex = 0;
  double _initial = 0.0;

  void resetFlip() {
    if (flipKey.currentState?.isFront ?? true) {
      flipKey.currentState?.toggleCardWithoutAnimation();
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (await googleSignIn.isSignedIn() && mounted) {
                  googleSignIn.signOut();
                  Navigator.of(context).pop(
                    MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            const BottomNavBar()),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            const WelcomeScreen()),
                  );
                }
                if (user != null && mounted) {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(
                    MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            const BottomNavBar()),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            const WelcomeScreen()),
                  );
                }
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();
  FlipCardController flipController = FlipCardController();
  Stream<QuerySnapshot> _cardsStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    _cardsStream = FirebaseFirestore.instance.collection('Cards').snapshots();
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: InkWell(
              onTap: () {
                _showLogoutDialog();
              },
              child: ClipOval(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CircleAvatar(
                  radius: 20,
                  child: Image.network(
                    user!.photoURL == null
                        ? 'https://static.vecteezy.com/system/resources/thumbnails/004/511/281/small/default-avatar-photo-placeholder-profile-picture-vector.jpg'
                        : '${user?.photoURL}',
                    height: 95,
                  ),
                ),
              ),
            ),
          ),
        ],
        title: const Text('Flashcards'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _cardsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          List<Flashcard> cards = [];
          for (var doc in snapshot.data!.docs) {
            cards.add(
                Flashcard(question: doc['question'], answer: doc['answer']));
          }

          if (cards.isEmpty) {
            cards.add(Flashcard(
                question: 'Flashcards would display here',
                answer: 'Flashcards would display here'));
          }

          void nextCard() {
            if (!flipKey.currentState!.isFront) {
              flipKey.currentState!.toggleCardWithoutAnimation();
            }
            // resetFlip();
            setState(() {
              _currentIndex = (_currentIndex + 1) % cards.length;
              _initial = (_currentIndex / cards.length);
            });
          }

          void prevCard() {
            if (!flipKey.currentState!.isFront) {
              flipKey.currentState!.toggleCardWithoutAnimation();
            }
            // resetFlip();
            setState(() {
              _currentIndex =
                  _currentIndex - 1 >= 0 ? _currentIndex - 1 : cards.length - 1;
              _initial = (_currentIndex / cards.length);
            });
          }

          String value = (_initial * cards.length + 1).toStringAsFixed(0);
          String value1 = (_currentIndex + 1).toString();
          String total = cards.length.toString();
          double progress = (_currentIndex + 1) / cards.length;

          return Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Card $value of $total",
                        style: const TextStyle(fontSize: 25)),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          speed: 750,
                          back: FlashCardView(
                            text: cards[_currentIndex].answer,
                          ),
                          front: FlashCardView(
                            text: cards[_currentIndex].question,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Tap to reveal answer'),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              minimumSize: const Size(90, 60),
                              elevation: 8,
                              backgroundColor: Colors.lightBlueAccent),
                          onPressed: () {
                            prevCard();
                            // updateToPrev();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 35,
                          ),
                        ),
                        const SizedBox(
                          width: 120,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              minimumSize: const Size(90, 60), //////// HERE
                              elevation: 8,
                              backgroundColor: Colors.lightBlueAccent),
                          onPressed: () {
                            nextCard();
                            // updateToNext();
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
