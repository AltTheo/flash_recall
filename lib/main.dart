import 'package:edcom/bottom_nav.dart';
import 'package:edcom/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              actionsIconTheme: IconThemeData(color: Colors.black),
              color: Colors.lightBlueAccent,
              centerTitle: true,
              titleTextStyle: TextStyle(fontSize: 25, color: Colors.black)),
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        themeAnimationCurve: Curves.bounceIn,
        debugShowCheckedModeBanner: false,
        title: 'Flashcard app',
        home: const BottomNavBar());
  }
}
