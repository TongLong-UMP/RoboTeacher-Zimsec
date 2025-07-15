import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('School Analytics')),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('School Analytics Overview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 24),
            Text('Total Students: 250'),
            Text('Total Teachers: 18'),
            Text('Total Parents: 180'),
            SizedBox(height: 24),
            Text('Recent Activity:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title:
                  Text('100% of students completed last week\'s assignments'),
            ),
            ListTile(
              leading: Icon(Icons.trending_up, color: Colors.blue),
              title: Text('Attendance up 5% this term'),
            ),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.orange),
              title: Text('2 students flagged for extra support'),
            ),
          ],
        ),
      ),
    );
  }
}
