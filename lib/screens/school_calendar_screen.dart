import 'package:flutter/material.dart';

import '../widgets/advertising_banner_widget.dart';

class SchoolCalendarScreen extends StatelessWidget {
  const SchoolCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> terms = [
      {
        'term': 'Term 1',
        'start': 'Tuesday, 14 January 2025',
        'end': 'Thursday, 10 April 2025',
        'holidays': [
          {'name': 'Easter Holiday', 'date': '18-21 April 2025'},
        ],
        'notes': 'Term 1 includes opening day, mid-term break, and closing day.'
      },
      {
        'term': 'Term 2',
        'start': 'Tuesday, 6 May 2025',
        'end': 'Thursday, 7 August 2025',
        'holidays': [
          {'name': 'Heroes Day', 'date': '11 August 2025'},
          {'name': 'Defence Forces Day', 'date': '12 August 2025'},
        ],
        'notes': 'Term 2 includes national holidays and mid-term break.'
      },
      {
        'term': 'Term 3',
        'start': 'Tuesday, 8 September 2025',
        'end': 'Thursday, 3 December 2025',
        'holidays': [
          {'name': 'Christmas', 'date': '25 December 2025'},
        ],
        'notes': 'Term 3 includes closing day and public holidays.'
      },
    ];

    final List<Map<String, String>> importantDates = [
      {
        'title': 'National Exams (ZIMSEC O & A Level)',
        'date': 'October - November 2025'
      },
      {'title': 'Grade 7 Exams', 'date': 'October 2025'},
      {'title': 'School Prize Giving Day', 'date': 'Friday, 28 November 2025'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('School Calendar 2025')),
      body: ListView(
        children: [
          const AdvertisingBannerWidget(
            adText: 'Promote your school events here! Contact us for details.',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('2025 School Terms',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...terms.map((term) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(term['term'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Start: ${term['start']}'),
                            Text('End: ${term['end']}'),
                            if (term['holidays'] != null &&
                                term['holidays'].isNotEmpty) ...[
                              const SizedBox(height: 8),
                              const Text('Holidays:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              ...term['holidays']
                                  .map<Widget>(
                                      (h) => Text('${h['name']}: ${h['date']}'))
                                  .toList(),
                            ],
                            if (term['notes'] != null) ...[
                              const SizedBox(height: 8),
                              Text(term['notes'],
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic)),
                            ]
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
                const Text('Important National Dates',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...importantDates.map((d) => ListTile(
                      leading:
                          const Icon(Icons.event, color: Colors.deepOrange),
                      title: Text(d['title']!),
                      subtitle: Text(d['date']!),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
