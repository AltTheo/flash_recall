import 'package:edcom/add_card.dart';
import 'package:edcom/home_screen.dart';
import 'package:edcom/model/deck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<StatefulWidget> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    AddCardScreen(onCardAdded: () {}),
    const Deck(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          // appBar: AppBar(
          //     title: Text('Bottom NavBar'), backgroundColor: Colors.purple),
          body: IndexedStack(
            index: selectedIndex,
            children: widgetOptions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.lightBlue,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.square_stack_3d_up_fill),
                  icon: Icon(CupertinoIcons.square_stack_3d_up),
                  label: 'Cards'),
              BottomNavigationBarItem(
                  activeIcon:
                      Icon(CupertinoIcons.rectangle_stack_fill_badge_plus),
                  icon: Icon(CupertinoIcons.rectangle_stack_badge_plus),
                  label: 'Add flashcard'),
              BottomNavigationBarItem(
                  activeIcon: Icon(CupertinoIcons.square_stack_fill),
                  icon: Icon(CupertinoIcons.square_stack),
                  label: 'View deck'),
            ],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          )),
    );
  }
}
