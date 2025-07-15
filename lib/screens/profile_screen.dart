import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/background_selector.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String avatar = 'default_cartoon.png';
  String theme = 'light';

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final role = user != null ? user['role'] : 'student';
    final schoolId =
        user != null ? (user['schoolId'] ?? 'SCHOOL123') : 'SCHOOL123';
    final email = user != null ? (user['email'] ?? '') : '';
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            DropdownButton<String>(
              value: avatar,
              items: ['default_cartoon.png', 'hero.png', 'princess.png'].map((
                String avatar,
              ) {
                return DropdownMenuItem<String>(
                  value: avatar,
                  child: Text(avatar),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  avatar = value!;
                });
                databaseService.updateProfile(
                    user != null ? user['uid'] : 'local_user_123', {
                  'avatar': avatar,
                });
              },
            ),
            DropdownButton<String>(
              value: theme,
              items: ['light', 'dark', 'colorful'].map((String theme) {
                return DropdownMenuItem<String>(
                  value: theme,
                  child: Text(theme),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  theme = value!;
                });
                // Update theme dynamically (implement theme change logic)
              },
            ),
            const SizedBox(height: 12),
            const BackgroundSelector(),
            const SizedBox(height: 24),
            if (role == 'admin') ...[
              FutureBuilder<Map<String, dynamic>>(
                future: databaseService.getSchoolInfo(schoolId),
                builder: (context, snapshot) {
                  final school = snapshot.data ?? {};
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('School Admin Panel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 12),
                          Text('School: ${school['name'] ?? ''}'),
                          Text('Address: ${school['address'] ?? ''}'),
                          Text('Contact: ${school['contact'] ?? ''}'),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.group),
                            label: const Text('Manage Users'),
                            onPressed: () {
                              context.push('/manage-users');
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.analytics),
                            label: const Text('View Analytics'),
                            onPressed: () {
                              context.push('/analytics');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else if (role == 'teacher') ...[
              FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseService.getStudents(schoolId),
                builder: (context, snapshot) {
                  final students = snapshot.data ?? [];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Teacher Profile',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 12),
                          Text('Contact: $email'),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.people),
                            label: const Text('View Assigned Students'),
                            onPressed: () {
                              context.push('/students', extra: students);
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.event),
                            label: const Text('Teacher Planner'),
                            onPressed: () {
                              context.push('/planner');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else if (role == 'parent') ...[
              FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseService.getChildrenForParent(email),
                builder: (context, snapshot) {
                  final children = snapshot.data ?? [];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Parent Profile',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 12),
                          Text(
                              'Children: ${children.map((c) => c['name']).join(', ')}'),
                          Text('Contact: $email'),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.school),
                            label: const Text('View Children Progress'),
                            onPressed: () {
                              context.push('/children-progress',
                                  extra: children);
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.contact_mail),
                            label: const Text('Contact Teachers'),
                            onPressed: () {
                              context.push('/contact-teachers');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              // Default to student
              FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseService.getTeachersForStudent(
                    user != null ? (user['name'] ?? 'Tinashe') : 'Tinashe'),
                builder: (context, snapshot) {
                  final teachers = snapshot.data ?? [];
                  return Column(
                    children: [
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(top: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Student Profile',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 12),
                              Text(
                                  'Grade:  ${user != null ? (user['grade'] ?? '5') : '5'}'),
                              const Text('Parent: parent@email.com'),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.person),
                                label: const Text('View Assigned Teachers'),
                                onPressed: () {
                                  context.push('/teachers', extra: teachers);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: user != null
                            ? databaseService.getLearnerPlanner(user['uid'])
                            : Future.value([]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final planner = snapshot.data ?? [];
                          final totalGoals = planner.length;
                          final completed = planner
                              .where((e) =>
                                  (e['Milestone'] ?? '')
                                      .toString()
                                      .toLowerCase()
                                      .contains('complete') ||
                                  (e['Milestone'] ?? '')
                                      .toString()
                                      .toLowerCase()
                                      .contains('done'))
                              .length;
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(top: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Commitment Report',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  const SizedBox(height: 12),
                                  LinearProgressIndicator(
                                    value: totalGoals == 0
                                        ? 0
                                        : completed / totalGoals,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Goals: $totalGoals'),
                                      Text('Completed: $completed'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
