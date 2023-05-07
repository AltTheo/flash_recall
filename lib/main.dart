import 'package:edcom/flashcardview.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
        ),
        themeAnimationCurve: Curves.bounceIn,
        debugShowCheckedModeBanner: false,
        title: 'FLashacard app',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Quiz Flashcards'),
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 450,
                      width: 300,
                      child: FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        speed: 900,
                        back: FlashCardView(
                          text: 'OREEEHHH',
                        ),
                        front: Card(
                            elevation: 8.0,
                            child: Center(
                              child: Text(
                                'Who is a bad boy',
                                style: TextStyle(fontSize: 25),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back_ios),
                            label: const Text('Previous')),
                        const SizedBox(
                          width: 80,
                        ),
                        OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios),
                            label: const Text('Next'))
                      ],
                    )
                  ]),
            )));
  }
}
