import 'package:edcom/auth/sign_in.dart';
import 'package:edcom/bottom_nav.dart';
import 'package:edcom/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.black,
              selectedItemColor:Colors.lightBlueAccent,
              // backgroundColor: Colors.white54
              ),
          appBarTheme: const AppBarTheme(
              shadowColor: Colors.white54,
              elevation: 1,
              actionsIconTheme: IconThemeData(color: Colors.black),
              color: Colors.white54,
              centerTitle: false,
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
        home: const SignInPage());
  }
}
