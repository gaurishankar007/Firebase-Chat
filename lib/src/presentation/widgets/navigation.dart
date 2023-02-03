import 'package:firebase_chat/src/presentation/blocs/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constant.dart';

class HomeNavigationBar extends StatelessWidget {
  final int pageIndex;
  const HomeNavigationBar({
    super.key,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return SizedBox(
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
          BlocProvider.of<HomeBloc>(context)
              .add(NewPageEvent(pageIndex: index));
        },
      ),
    );
  }
}

class HomeLoadingNavigationBar extends StatelessWidget {
  const HomeLoadingNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return SizedBox(
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
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        backgroundColor: surface,
        selectedItemColor: onSurface,
        unselectedItemColor: onSurface,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        iconSize: iconSize,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
