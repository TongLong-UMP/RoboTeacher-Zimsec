import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/database_service.dart';

// Example mapping of subject names to ZIMSEC syllabus URLs (update as needed)
const Map<String, String> zimsecSyllabusLinks = {
  'Mathematics':
      'https://www.zimsec.co.zw/wp-content/uploads/2019/10/Mathematics-Syllabus.pdf',
  'English':
      'https://www.zimsec.co.zw/wp-content/uploads/2019/10/English-Syllabus.pdf',
  'Science':
      'https://www.zimsec.co.zw/wp-content/uploads/2019/10/Science-Syllabus.pdf',
  // Add more subjects and their URLs here
};

class CurriculumScreen extends StatelessWidget {
  const CurriculumScreen({super.key});

  void _openSyllabusLink(BuildContext context, String? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No syllabus link available for this subject.')),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open syllabus link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Curriculum Portal')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:
            databaseService.getCurriculumContent('Grade 5'), // Example grade
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data == null || data.isEmpty) {
              return const Center(child: Text('No curriculum data available.'));
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                try {
                  final subject = data[index];
                  final subjectName = subject['name'] ?? 'Unknown';
                  final syllabusUrl = zimsecSyllabusLinks[subjectName];
                  if (subject['name'] == null ||
                      subject['description'] == null) {
                    return const ListTile(
                      title: Text('Unknown Subject'),
                      subtitle: Text('Data missing or corrupted.'),
                    );
                  }
                  return ListTile(
                    title: Text(subjectName),
                    subtitle: Text(subject['description'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.picture_as_pdf,
                          color: Colors.deepOrange),
                      tooltip: 'Open ZIMSEC Syllabus',
                      onPressed: () => _openSyllabusLink(context, syllabusUrl),
                    ),
                    onTap: () => _openSyllabusLink(context, syllabusUrl),
                  );
                } catch (e) {
                  return ListTile(
                    title: const Text('Error rendering subject'),
                    subtitle: Text(e.toString()),
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: \\${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
