import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to RoboTeacher!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _SectionButton(
                      label: 'Reading',
                      icon: Icons.menu_book,
                      routePath: '/reading'),
                  _SectionButton(
                      label: 'Curriculum',
                      icon: Icons.school,
                      routePath: '/curriculum'),
                  _SectionButton(
                      label: 'Planner',
                      icon: Icons.event,
                      routePath: '/planner'),
                  _SectionButton(
                      label: 'Learning Desk',
                      icon: Icons.desktop_windows,
                      routePath: '/learning-desk'),
                  _SectionButton(
                      label: 'Profile',
                      icon: Icons.person,
                      routePath: '/profile'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String routePath;
  const _SectionButton(
      {required this.label,
      required this.icon,
      required this.routePath,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: () => context.go(routePath),
    );
  }
}
