import 'package:flutter/material.dart';

import 'background_container.dart';
import 'main_bottom_nav_bar.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  const MainScaffold(
      {required this.child, required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(child: child),
      bottomNavigationBar: MainBottomNavBar(currentIndex: currentIndex),
    );
  }
}
