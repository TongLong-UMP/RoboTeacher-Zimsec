import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';

class PlannerScreen extends StatefulWidget {
  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool isAdmin = false;
  bool initialized = false;
  int _bgIndex = 0;
  final List<String> _bgAssets = [
    'assets/ruled_pad_bg1.png',
    'assets/ruled_pad_bg2.png',
    'assets/ruled_pad_bg3.png',
  ];

  List<Map<String, dynamic>> _planner = [];
  List<Map<String, dynamic>> _teacherDates = [];
  bool _loading = true;
  List<Map<String, dynamic>> _schoolPlanner = [];
  bool _schoolPlannerLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      isAdmin = user != null && user['role'] == 'admin';
      _tabController = TabController(length: isAdmin ? 2 : 1, vsync: this);
      _loadPlanner();
      _loadSchoolPlanner();
      initialized = true;
    }
  }

  Future<void> _loadPlanner() async {
    setState(() => _loading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final db = Provider.of<DatabaseService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      final planner = await db.getLearnerPlanner(user['uid']);
      final teacherDates = await db.getTeacherPlannerDates(user['uid']);
      setState(() {
        _planner = planner;
        _teacherDates = teacherDates;
        _loading = false;
      });
    }
  }

  Future<void> _loadSchoolPlanner() async {
    setState(() => _schoolPlannerLoading = true);
    final db = Provider.of<DatabaseService>(context, listen: false);
    final planner = await db.getSchoolPlanner();
    setState(() {
      _schoolPlanner = planner;
      _schoolPlannerLoading = false;
    });
  }

  Future<void> _addPlannerEntry() async {
    final dateController = TextEditingController();
    final goalController = TextEditingController();
    final milestoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Planner Entry'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter date' : null,
              ),
              TextFormField(
                controller: goalController,
                decoration: InputDecoration(labelText: 'Goal'),
                validator: (v) => v == null || v.isEmpty ? 'Enter goal' : null,
              ),
              TextFormField(
                controller: milestoneController,
                decoration: InputDecoration(labelText: 'Milestone'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter milestone' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'Date': dateController.text.trim(),
                  'Goal': goalController.text.trim(),
                  'Milestone': milestoneController.text.trim(),
                });
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
    if (result != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final db = Provider.of<DatabaseService>(context, listen: false);
      final user = authService.currentUser;
      if (user != null) {
        await db.addLearnerPlannerEntry(user['uid'], result);
        await _loadPlanner();
      }
    }
  }

  Future<void> _addSchoolPlannerEntry() async {
    final lessonController = TextEditingController();
    final programController = TextEditingController();
    final dateController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Lesson/Program'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: lessonController,
                decoration: InputDecoration(labelText: 'Lesson'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter lesson' : null,
              ),
              TextFormField(
                controller: programController,
                decoration: InputDecoration(labelText: 'Program'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter program' : null,
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter date' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'Lesson': lessonController.text.trim(),
                  'Program': programController.text.trim(),
                  'Date': dateController.text.trim(),
                });
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
    if (result != null) {
      final db = Provider.of<DatabaseService>(context, listen: false);
      await db.addSchoolPlannerEntry(result);
      await _loadSchoolPlanner();
    }
  }

  Future<void> _removePlannerEntry(int index) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final db = Provider.of<DatabaseService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      await db.removeLearnerPlannerEntry(user['uid'], index);
      await _loadPlanner();
    }
  }

  Future<void> _removeSchoolPlannerEntry(int index) async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    await db.removeSchoolPlannerEntry(index);
    await _loadSchoolPlanner();
  }

  Future<void> _editPlannerEntry(int index) async {
    final entry = _planner[index];
    final dateController = TextEditingController(text: entry['Date'] ?? '');
    final goalController = TextEditingController(text: entry['Goal'] ?? '');
    final milestoneController =
        TextEditingController(text: entry['Milestone'] ?? '');
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Planner Entry'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter date' : null,
              ),
              TextFormField(
                controller: goalController,
                decoration: InputDecoration(labelText: 'Goal'),
                validator: (v) => v == null || v.isEmpty ? 'Enter goal' : null,
              ),
              TextFormField(
                controller: milestoneController,
                decoration: InputDecoration(labelText: 'Milestone'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter milestone' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'Date': dateController.text.trim(),
                  'Goal': goalController.text.trim(),
                  'Milestone': milestoneController.text.trim(),
                });
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final db = Provider.of<DatabaseService>(context, listen: false);
      final user = authService.currentUser;
      if (user != null) {
        final updatedPlanner = List<Map<String, dynamic>>.from(_planner);
        updatedPlanner[index] = result;
        await db.saveLearnerPlanner(user['uid'], updatedPlanner);
        await _loadPlanner();
      }
    }
  }

  Future<void> _editSchoolPlannerEntry(int index) async {
    final entry = _schoolPlanner[index];
    final lessonController = TextEditingController(text: entry['Lesson'] ?? '');
    final programController =
        TextEditingController(text: entry['Program'] ?? '');
    final dateController = TextEditingController(text: entry['Date'] ?? '');
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Lesson/Program'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: lessonController,
                decoration: InputDecoration(labelText: 'Lesson'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter lesson' : null,
              ),
              TextFormField(
                controller: programController,
                decoration: InputDecoration(labelText: 'Program'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter program' : null,
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter date' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'Lesson': lessonController.text.trim(),
                  'Program': programController.text.trim(),
                  'Date': dateController.text.trim(),
                });
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      final db = Provider.of<DatabaseService>(context, listen: false);
      await db.editSchoolPlannerEntry(index, result);
      await _loadSchoolPlanner();
    }
  }

  Future<void> _sendTeacherDate() async {
    final dateController = TextEditingController();
    final goalController = TextEditingController();
    final milestoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Important Date'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter date' : null,
              ),
              TextFormField(
                controller: goalController,
                decoration: InputDecoration(labelText: 'Goal'),
                validator: (v) => v == null || v.isEmpty ? 'Enter goal' : null,
              ),
              TextFormField(
                controller: milestoneController,
                decoration: InputDecoration(labelText: 'Milestone'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter milestone' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'Date': dateController.text.trim(),
                  'Goal': goalController.text.trim(),
                  'Milestone': milestoneController.text.trim(),
                });
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
    if (result != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final db = Provider.of<DatabaseService>(context, listen: false);
      final user = authService.currentUser;
      if (user != null) {
        // For demo, send to self. In real app, teacher selects learner.
        await db.addTeacherPlannerDate(user['uid'], result);
        await _loadPlanner();
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planner'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            if (isAdmin) Tab(text: 'School Planner', icon: Icon(Icons.school)),
            Tab(text: 'Learner Planner', icon: Icon(Icons.event_note)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          if (isAdmin) _buildSchoolPlanner(context),
          _buildLearnerPlanner(context),
        ],
      ),
    );
  }

  Widget _buildLearnerPlanner(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Container(
            key: ValueKey(_bgIndex),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_bgAssets[_bgIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _bgIndex =
                        (_bgIndex - 1 + _bgAssets.length) % _bgAssets.length;
                  });
                },
              ),
              Text('Change Background'),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _bgIndex = (_bgIndex + 1) % _bgAssets.length;
                  });
                },
              ),
            ],
          ),
        ),
        if (_loading) Center(child: CircularProgressIndicator()),
        if (!_loading)
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Planner',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text('Add'),
                            onPressed: _addPlannerEntry,
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: Icon(Icons.send),
                            label: Text('Send Date (Teacher)'),
                            onPressed: _sendTeacherDate,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Goal')),
                        DataColumn(label: Text('Milestone')),
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('')),
                      ],
                      rows: [
                        ..._teacherDates.map((row) => DataRow(
                              color:
                                  MaterialStateProperty.all(Colors.yellow[100]),
                              cells: [
                                DataCell(Text(row['Date'] ?? '')),
                                DataCell(Text(row['Goal'] ?? '')),
                                DataCell(Text(row['Milestone'] ?? '')),
                                DataCell(Text('Teacher')), // No edit
                                DataCell(Text('')), // No delete
                              ],
                            )),
                        ..._planner.asMap().entries.map((entry) {
                          final i = entry.key;
                          final row = entry.value;
                          return DataRow(cells: [
                            DataCell(Text(row['Date'] ?? '')),
                            DataCell(Text(row['Goal'] ?? '')),
                            DataCell(Text(row['Milestone'] ?? '')),
                            DataCell(IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Edit',
                              onPressed: () => _editPlannerEntry(i),
                            )),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Delete',
                              onPressed: () => _removePlannerEntry(i),
                            )),
                          ]);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSchoolPlanner(BuildContext context) {
    if (_schoolPlannerLoading) {
      _loadSchoolPlanner();
      return Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('School Planner',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                  onPressed: _addSchoolPlannerEntry,
                ),
              ],
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Lesson')),
                  DataColumn(label: Text('Program')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),
                ],
                rows: _schoolPlanner.asMap().entries.map((entry) {
                  final i = entry.key;
                  final row = entry.value;
                  return DataRow(cells: [
                    DataCell(Text(row['Lesson'] ?? '')),
                    DataCell(Text(row['Program'] ?? '')),
                    DataCell(Text(row['Date'] ?? '')),
                    DataCell(IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Edit',
                      onPressed: () => _editSchoolPlannerEntry(i),
                    )),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _removeSchoolPlannerEntry(i),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
