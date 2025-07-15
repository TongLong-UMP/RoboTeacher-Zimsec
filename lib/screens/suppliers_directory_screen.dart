// import 'dart:html' as html; // TODO: Commented out for test compatibility. Restore for web builds.

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../widgets/advertising_banner_widget.dart';

class SuppliersDirectoryScreen extends StatefulWidget {
  const SuppliersDirectoryScreen({super.key});

  @override
  State<SuppliersDirectoryScreen> createState() =>
      _SuppliersDirectoryScreenState();
}

class _SuppliersDirectoryScreenState extends State<SuppliersDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _complianceFilters = [];
  List<Map<String, dynamic>> _suppliers = [];
  List<Map<String, dynamic>> _filteredSuppliers = [];

  final List<Map<String, dynamic>> _allSuppliers = [
    {
      'name': 'EduTech Supplies',
      'tax': true,
      'praz': true,
      'afs': true,
      'profile': true,
      'products': 'Textbooks, Tablets',
    },
    {
      'name': 'SmartBoards Africa',
      'tax': false,
      'praz': true,
      'afs': false,
      'profile': true,
      'products': 'Smart Boards, Projectors',
    },
    {
      'name': 'School Uniforms Ltd.',
      'tax': true,
      'praz': false,
      'afs': true,
      'profile': false,
      'products': 'Uniforms, Sportswear',
    },
  ];

  @override
  void initState() {
    super.initState();
    _suppliers = List<Map<String, dynamic>>.from(_allSuppliers);
    _filteredSuppliers = _suppliers;
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
      _filteredSuppliers = _suppliers.where((supplier) {
        bool matchesSearch = query.isEmpty ||
            supplier.values
                .any((v) => v.toString().toLowerCase().contains(query));
        bool matchesCompliance = _complianceFilters.isEmpty ||
            _complianceFilters.every((f) => supplier[f.toLowerCase()] == true);
        return matchesSearch && matchesCompliance;
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
          final List<Map<String, dynamic>> importedSuppliers = [];
          for (int i = 1; i < csvTable.length; i++) {
            final row = csvTable[i];
            if (row.length != headers.length) continue;
            final Map<String, dynamic> supplier = {};
            for (int j = 0; j < headers.length; j++) {
              if (['tax', 'praz', 'afs', 'profile'].contains(headers[j])) {
                supplier[headers[j]] =
                    row[j].toString().toLowerCase() == 'true' ||
                        row[j].toString() == '1' ||
                        row[j].toString().toLowerCase() == 'yes';
              } else {
                supplier[headers[j]] = row[j].toString();
              }
            }
            importedSuppliers.add(supplier);
          }
          setState(() {
            _suppliers = importedSuppliers;
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

  void _exportCSV() {
    // TODO: Commented out web CSV export for test compatibility. Restore for web builds.
    // List<List<dynamic>> rows = [];
    // final headers = ['name', 'tax', 'praz', 'afs', 'profile', 'products'];
    // rows.add(headers);
    // for (final supplier in _filteredSuppliers) {
    //   rows.add([
    //     supplier['name'] ?? '',
    //     supplier['tax'] == true ? 'TRUE' : 'FALSE',
    //     supplier['praz'] == true ? 'TRUE' : 'FALSE',
    //     supplier['afs'] == true ? 'TRUE' : 'FALSE',
    //     supplier['profile'] == true ? 'TRUE' : 'FALSE',
    //     supplier['products'] ?? '',
    //   ]);
    // }
    // String csv = const ListToCsvConverter().convert(rows);
    // final bytes = utf8.encode(csv);
    // final blob = html.Blob([bytes]);
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // final anchor = html.AnchorElement(href: url)
    //   ..setAttribute('download', 'suppliers_directory.csv')
    //   ..click();
    // html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final complianceOptions = ['Tax', 'PRAZ', 'AFS', 'Profile'];
    return ListView(
      children: [
        const AdvertisingBannerWidget(
          adText: 'List your company here! Reach schools nationwide.',
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
                    labelText: 'Search suppliers...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ...complianceOptions.map((option) => FilterChip(
                    label: Text(option),
                    selected: _complianceFilters.contains(option),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _complianceFilters.add(option);
                        } else {
                          _complianceFilters.remove(option);
                        }
                        _applyFilters();
                      });
                    },
                  )),
              ElevatedButton.icon(
                onPressed: _importCSV,
                icon: const Icon(Icons.upload_file),
                label: const Text('Import CSV'),
              ),
              ElevatedButton.icon(
                onPressed: _exportCSV,
                icon: const Icon(Icons.download),
                label: const Text('Export CSV'),
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
                DataColumn(label: Text('Supplier')),
                DataColumn(label: Text('Tax Clearance')),
                DataColumn(label: Text('PRAZ Reg.')),
                DataColumn(label: Text('Audited AFS')),
                DataColumn(label: Text('Profile')),
                DataColumn(label: Text('Products/Services')),
              ],
              rows: _filteredSuppliers
                  .map((s) => DataRow(cells: [
                        DataCell(Text(s['name'] ?? '')),
                        DataCell(Icon(
                            (s['tax'] == true)
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: (s['tax'] == true)
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            (s['praz'] == true)
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: (s['praz'] == true)
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            (s['afs'] == true)
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: (s['afs'] == true)
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Icon(
                            (s['profile'] == true)
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: (s['profile'] == true)
                                ? Colors.green
                                : Colors.red)),
                        DataCell(Text(s['products'] ?? '')),
                      ]))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
