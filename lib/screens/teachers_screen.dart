import 'package:flutter/material.dart';

class TeachersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> teachers;
  const TeachersScreen({super.key, this.teachers = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assigned Teachers')),
      body: ListView.builder(
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final t = teachers[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(t['name'] ?? ''),
            subtitle: Text('Email: ${t['email'] ?? ''}'),
          );
        },
      ),
    );
  }
}
