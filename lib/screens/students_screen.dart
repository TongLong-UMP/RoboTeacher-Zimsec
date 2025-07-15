import 'package:flutter/material.dart';

class StudentsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> students;
  const StudentsScreen({super.key, this.students = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assigned Students')),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final s = students[index];
          return ListTile(
            leading: const Icon(Icons.school),
            title: Text(s['name'] ?? ''),
            subtitle: Text('Grade: ${s['grade'] ?? ''}'),
          );
        },
      ),
    );
  }
}
