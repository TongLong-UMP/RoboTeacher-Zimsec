import 'package:flutter/material.dart';

class ChildrenProgressScreen extends StatelessWidget {
  final List<Map<String, dynamic>> children;
  const ChildrenProgressScreen({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Children Progress')),
      body: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          final c = children[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.child_care),
              title: Text(c['name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Grade: ${c['grade'] ?? ''}'),
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(value: 0.7, minHeight: 8),
                  const SizedBox(height: 4),
                  const Text('Progress: 70%'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
