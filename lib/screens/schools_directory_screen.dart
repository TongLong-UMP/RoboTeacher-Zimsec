import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../widgets/advertising_banner_widget.dart';

class SchoolsDirectoryScreen extends StatefulWidget {
  const SchoolsDirectoryScreen({super.key});

  @override
  State<SchoolsDirectoryScreen> createState() => _SchoolsDirectoryScreenState();
}

class _SchoolsDirectoryScreenState extends State<SchoolsDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedProvince;
  String? _selectedType;
  String? _selectedOwnership;
  List<Map<String, String>> _schools = [];
  List<Map<String, String>> _filteredSchools = [];

  final List<Map<String, String>> _allSchools = [
    {
      'name': 'St. Ignatius College',
      'province': 'Harare',
      'district': 'Chishawasha',
      'type': 'Secondary',
      'ownership': 'Church',
      'emis': '123456',
      'head': 'Mr. T. Chikanya',
      'email': 'info@stignatius.ac.zw',
      'phone': '+263 242 860321',
      'address': 'Chishawasha, Harare',
      'website': 'www.stignatius.ac.zw',
      'accreditation': 'Registered',
      'boarding': 'Boarding',
      'gender': 'Boys',
      'enrollment': '900',
      'notes': 'Top A-Level results, National Quiz Champions',
    },
    {
      'name': 'Queen Elizabeth School',
      'province': 'Harare',
      'district': 'Harare',
      'type': 'Secondary',
      'ownership': 'Govt',
      'emis': '654321',
      'head': 'Mrs. S. Moyo',
      'email': 'admin@queenelizabeth.ac.zw',
      'phone': '+263 242 792345',
      'address': 'Leopold Takawira St, Harare',
      'website': 'www.queenelizabeth.ac.zw',
      'accreditation': 'Registered',
      'boarding': 'Day',
      'gender': 'Girls',
      'enrollment': '1200',
      'notes': 'Best Girls School 2024',
    },
    {
      'name': 'Goromonzi High',
      'province': 'Mashonaland East',
      'district': 'Goromonzi',
      'type': 'Secondary',
      'ownership': 'Govt',
      'emis': '789012',
      'head': 'Mr. B. Ncube',
      'email': 'contact@goromonzi.ac.zw',
      'phone': '+263 272 212345',
      'address': 'Goromonzi, Mashonaland East',
      'website': 'www.goromonzi.ac.zw',
      'accreditation': 'Registered',
      'boarding': 'Boarding',
      'gender': 'Co-ed',
      'enrollment': '1500',
      'notes': 'Sports Champions, Science Fair Winners',
    },
  ];

  @override
  void initState() {
    super.initState();
    _schools = List<Map<String, String>>.from(_allSchools);
    _filteredSchools = _schools;
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSchools = _schools.where((school) {
        bool matchesSearch = query.isEmpty ||
            school.values.any((v) => v.toLowerCase().contains(query));
        bool matchesProvince = _selectedProvince == null ||
            school['province'] == _selectedProvince;
        bool matchesType =
            _selectedType == null || school['type'] == _selectedType;
        bool matchesOwnership = _selectedOwnership == null ||
            school['ownership'] == _selectedOwnership;
        return matchesSearch &&
            matchesProvince &&
            matchesType &&
            matchesOwnership;
      }).toList();
    });
  }

  Future<void> _importCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
      if (result != null && result.files.single.bytes != null) {
        final csvString = String.fromCharCodes(result.files.single.bytes!);
        List<List<dynamic>> csvTable =
            const CsvToListConverter().convert(csvString, eol: '\n');
        if (csvTable.isNotEmpty) {
          final headers = csvTable.first
              .map((h) => h.toString().trim().toLowerCase())
              .toList();
          final List<Map<String, String>> importedSchools = [];
          for (int i = 1; i < csvTable.length; i++) {
            final row = csvTable[i];
            if (row.length != headers.length) continue;
            final Map<String, String> school = {};
            for (int j = 0; j < headers.length; j++) {
              school[headers[j]] = row[j].toString();
            }
            importedSchools.add(school);
          }
          setState(() {
            _schools = importedSchools;
            _applyFilters();
          });
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Import Error'),
          content: Text('Failed to import CSV: \n$e'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provinceOptions = _schools.map((s) => s['province']).toSet().toList();
    final typeOptions = _schools.map((s) => s['type']).toSet().toList();
    final ownershipOptions =
        _schools.map((s) => s['ownership']).toSet().toList();

    return ListView(
      children: [
        const AdvertisingBannerWidget(
          adText: 'Advertise your school here! Contact us for details.',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search schools...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: _selectedProvince,
                hint: const Text('Province'),
                items: [null, ...provinceOptions]
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p ?? 'All'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedProvince = val;
                    _applyFilters();
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedType,
                hint: const Text('Type'),
                items: [null, ...typeOptions]
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t ?? 'All'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedType = val;
                    _applyFilters();
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedOwnership,
                hint: const Text('Ownership'),
                items: [null, ...ownershipOptions]
                    .map((o) => DropdownMenuItem(
                          value: o,
                          child: Text(o ?? 'All'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedOwnership = val;
                    _applyFilters();
                  });
                },
              ),
              ElevatedButton.icon(
                onPressed: _importCSV,
                icon: const Icon(Icons.upload_file),
                label: const Text('Import CSV'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('School Name')),
                DataColumn(label: Text('Province')),
                DataColumn(label: Text('District')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Ownership')),
                DataColumn(label: Text('EMIS #')),
                DataColumn(label: Text('Head/Principal')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Address')),
                DataColumn(label: Text('Website')),
                DataColumn(label: Text('Accreditation')),
                DataColumn(label: Text('Boarding/Day')),
                DataColumn(label: Text('Gender')),
                DataColumn(label: Text('Enrollment')),
                DataColumn(label: Text('Achievements/Notes')),
              ],
              rows: _filteredSchools
                  .map((s) => DataRow(cells: [
                        DataCell(Text(s['name'] ?? '')),
                        DataCell(Text(s['province'] ?? '')),
                        DataCell(Text(s['district'] ?? '')),
                        DataCell(Text(s['type'] ?? '')),
                        DataCell(Text(s['ownership'] ?? '')),
                        DataCell(Text(s['emis'] ?? '')),
                        DataCell(Text(s['head'] ?? '')),
                        DataCell(Text(s['email'] ?? '')),
                        DataCell(Text(s['phone'] ?? '')),
                        DataCell(Text(s['address'] ?? '')),
                        DataCell(Text(s['website'] ?? '')),
                        DataCell(Text(s['accreditation'] ?? '')),
                        DataCell(Text(s['boarding'] ?? '')),
                        DataCell(Text(s['gender'] ?? '')),
                        DataCell(Text(s['enrollment'] ?? '')),
                        DataCell(Text(s['notes'] ?? '')),
                      ]))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
