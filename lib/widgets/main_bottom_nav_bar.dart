import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const MainBottomNavBar({required this.currentIndex, super.key});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/community');
        break;
      case 2:
        context.go('/reading');
        break;
      case 3:
        context.go('/curriculum');
        break;
      case 4:
        context.go('/planner');
        break;
      case 5:
        context.go('/learning-desk');
        break;
      case 6:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Community'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Reading'),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Curriculum'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Planner'),
        BottomNavigationBarItem(
            icon: Icon(Icons.desktop_windows), label: 'Learning Desk'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
