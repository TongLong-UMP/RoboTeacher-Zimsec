import 'package:flutter/material.dart';

import '../widgets/advertising_banner_widget.dart';

class RoboRankingsScreen extends StatefulWidget {
  const RoboRankingsScreen({super.key});

  @override
  State<RoboRankingsScreen> createState() => _RoboRankingsScreenState();
}

class _RoboRankingsScreenState extends State<RoboRankingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoboRankings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.deepOrange,
          tabs: const [
            Tab(text: 'School Accolades'),
            Tab(text: 'Student Accolades'),
            Tab(text: 'Schools Rankings'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _SchoolAccoladesTab(),
                _StudentAccoladesTab(),
                _SchoolsRankingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SchoolAccoladesTab extends StatelessWidget {
  const _SchoolAccoladesTab();

  @override
  Widget build(BuildContext context) {
    final accolades = [
      {
        'school': 'St. Ignatius College',
        'award': 'Best A-Level Results',
        'year': '2025'
      },
      {
        'school': 'Prince Edward',
        'award': 'National Sports Champions',
        'year': '2025'
      },
      {
        'school': 'Chisipite Senior',
        'award': 'Top Girls School',
        'year': '2025'
      },
    ];
    return ListView(
      children: [
        const AdvertisingBannerWidget(
          adText: 'Promote your school achievement here! Contact us.',
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('School Accolades (National)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...accolades.map((a) => Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.emoji_events, color: Colors.amber),
                      title: Text(a['school']!),
                      subtitle: Text('${a['award']} (${a['year']})'),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _StudentAccoladesTab extends StatelessWidget {
  const _StudentAccoladesTab();

  @override
  Widget build(BuildContext context) {
    final accolades = [
      {
        'student': 'Tinashe M.',
        'school': 'St. Faith’s',
        'award': 'Best in Mathematics',
        'year': '2025'
      },
      {
        'student': 'Rudo C.',
        'school': 'Queen Elizabeth',
        'award': 'National Essay Winner',
        'year': '2025'
      },
      {
        'student': 'Brian S.',
        'school': 'Prince Edward',
        'award': 'Top Athlete',
        'year': '2025'
      },
    ];
    return ListView(
      children: [
        const AdvertisingBannerWidget(
          adText: 'Celebrate your students! Advertise here.',
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Student Accolades (Private to School)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...accolades.map((a) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.star, color: Colors.blueAccent),
                      title: Text(a['student']!),
                      subtitle:
                          Text('${a['award']} - ${a['school']} (${a['year']})'),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _SchoolsRankingsTab extends StatelessWidget {
  const _SchoolsRankingsTab();

  @override
  Widget build(BuildContext context) {
    final rankings = [
      {'rank': 1, 'school': 'St. Ignatius College', 'points': 98},
      {'rank': 2, 'school': 'Prince Edward', 'points': 95},
      {'rank': 3, 'school': 'Chisipite Senior', 'points': 93},
      {'rank': 4, 'school': 'Goromonzi High', 'points': 90},
      {'rank': 5, 'school': 'Queen Elizabeth', 'points': 88},
    ];
    return ListView(
      children: [
        const AdvertisingBannerWidget(
          adText: 'Sponsor the RoboRankings! Get national exposure.',
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Schools Robo Rankings (2025)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Rank')),
                  DataColumn(label: Text('School')),
                  DataColumn(label: Text('Points')),
                ],
                rows: rankings
                    .map((r) => DataRow(cells: [
                          DataCell(Text(r['rank'].toString())),
                          DataCell(Text(r['school'] as String)),
                          DataCell(Text(r['points'].toString())),
                        ]))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
