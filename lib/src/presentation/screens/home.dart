import 'package:firebase_chat/src/presentation/screens/chat_list.dart';
import 'package:firebase_chat/src/presentation/screens/google_map.dart';
import 'package:firebase_chat/src/presentation/screens/profile.dart';
import 'package:firebase_chat/src/presentation/screens/search.dart';
import 'package:flutter/material.dart';

import '../../core/constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController pageController = PageController();
  int pageIndex = 0;
  DateTime preBackPress = DateTime.now();

  Future<bool> exit() async {
    final Duration timeGap = DateTime.now().difference(preBackPress);
    final bool cantExit = timeGap >= Duration(seconds: 1);
    preBackPress = DateTime.now();

    if (cantExit) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Press back button again to Exit'),
        duration: Duration(seconds: 1),
      ));
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return WillPopScope(
      onWillPop: exit,
      child: Scaffold(
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ChatList(),
            Search(),
            GMap(),
            Profile(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 55,
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_rounded),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
            currentIndex: pageIndex,
            backgroundColor: surface,
            selectedItemColor: primaryContainer,
            unselectedItemColor: onSurface,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            iconSize: iconSize,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              if (index == pageIndex) return;

              pageController.jumpToPage(index);
              setState(() {
                pageIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
