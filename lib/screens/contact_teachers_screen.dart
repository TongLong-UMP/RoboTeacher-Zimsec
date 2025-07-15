import 'package:flutter/material.dart';

class ContactTeachersScreen extends StatelessWidget {
  const ContactTeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teachers = [
      {'name': 'Mrs. Sarah Johnson', 'email': 'sarah@school.co.zw'},
      {'name': 'Mr. Moyo', 'email': 'moyo@school.co.zw'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Teachers')),
      body: ListView.builder(
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final t = teachers[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(t['name'] ?? ''),
            subtitle: Text('Email: ${t['email'] ?? ''}'),
            trailing: IconButton(
              icon: const Icon(Icons.email),
              onPressed: () {
                // TODO: Implement email launch
              },
            ),
          );
        },
      ),
    );
  }
}
