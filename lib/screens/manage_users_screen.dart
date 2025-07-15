import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/database_service.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);
    // For demo, use a fixed schoolId
    const schoolId = 'SCHOOL123';
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const Text('Teachers',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: databaseService.getTeachers(schoolId),
            builder: (context, snapshot) {
              final teachers = snapshot.data ?? [];
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              return Column(
                children: teachers
                    .map((t) => ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(t['name'] ?? ''),
                          subtitle: Text(
                              'Subjects: ${(t['subjects'] as List).join(', ')}'),
                        ))
                    .toList(),
              );
            },
          ),
          const Divider(),
          const Text('Students',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: databaseService.getStudents(schoolId),
            builder: (context, snapshot) {
              final students = snapshot.data ?? [];
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              return Column(
                children: students
                    .map((s) => ListTile(
                          leading: const Icon(Icons.school),
                          title: Text(s['name'] ?? ''),
                          subtitle: Text('Grade: ${s['grade'] ?? ''}'),
                        ))
                    .toList(),
              );
            },
          ),
          const Divider(),
          const Text('Parents',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: databaseService.getParents(schoolId),
            builder: (context, snapshot) {
              final parents = snapshot.data ?? [];
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              return Column(
                children: parents
                    .map((p) => ListTile(
                          leading: const Icon(Icons.family_restroom),
                          title: Text(p['name'] ?? ''),
                          subtitle: Text(
                              'Children: ${(p['children'] as List).join(', ')}'),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
