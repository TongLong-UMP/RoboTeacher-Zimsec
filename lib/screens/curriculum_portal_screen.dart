import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CurriculumPortalScreen extends StatefulWidget {
  const CurriculumPortalScreen({super.key});

  @override
  State<CurriculumPortalScreen> createState() => _CurriculumPortalScreenState();
}

class _CurriculumPortalScreenState extends State<CurriculumPortalScreen> {
  late Future<Map<String, List<Map<String, String>>>> _syllabiFuture;

  @override
  void initState() {
    super.initState();
    _syllabiFuture = fetchGroupedSyllabi();
  }

  Future<Map<String, List<Map<String, String>>>> fetchGroupedSyllabi() async {
    const url = 'https://www5.zimsec.co.zw/syllabi/';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load syllabi');
    }
    final document = parser.parse(response.body);
    final Map<String, List<Map<String, String>>> grouped = {
      'Infant Syllabi (ECD – Grade 2)': [],
      'Junior Syllabi (Grade 3 – 7)': [],
      'Ordinary Level Syllabi': [],
      'Advanced Level Syllabi': [],
    };
    String? currentSection;
    for (var node in document.body!.querySelectorAll('h3, h4, a')) {
      if (node.localName == 'h3') {
        final text = node.text.trim();
        if (text.contains('Infant')) {
          currentSection = 'Infant Syllabi (ECD – Grade 2)';
        } else if (text.contains('Junior')) {
          currentSection = 'Junior Syllabi (Grade 3 – 7)';
        } else if (text.contains('Ordinary')) {
          currentSection = 'Ordinary Level Syllabi';
        } else if (text.contains('Advanced')) {
          currentSection = 'Advanced Level Syllabi';
        } else {
          currentSection = null;
        }
      } else if (node.localName == 'a' &&
          node.attributes['href'] != null &&
          node.attributes['href']!.endsWith('.pdf')) {
        if (currentSection != null) {
          grouped[currentSection]!.add({
            'title': node.text.trim(),
            'pdf': node.attributes['href']!.startsWith('http')
                ? node.attributes['href']!
                : 'https://www5.zimsec.co.zw${node.attributes['href']!}',
          });
        }
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Curriculum Portal')),
      body: FutureBuilder<Map<String, List<Map<String, String>>>>(
        future: _syllabiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final grouped = snapshot.data ?? {};
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Official ZIMSEC Syllabi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...grouped.entries.map((entry) => entry.value.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...entry.value.map((item) => ListTile(
                                title: Text(item['title'] ?? ''),
                                trailing: IconButton(
                                  icon: const Icon(Icons.picture_as_pdf,
                                      color: Colors.red),
                                  onPressed: () async {
                                    final url = item['pdf']!;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Could not open PDF.')),
                                      );
                                    }
                                  },
                                ),
                              )),
                          const Divider(),
                        ],
                      ),
                    )),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'For the latest and official syllabi, visit the ZIMSEC Syllabi page.',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Go to ZIMSEC Syllabi Website'),
                  onPressed: () async {
                    const url = 'https://www5.zimsec.co.zw/syllabi/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
