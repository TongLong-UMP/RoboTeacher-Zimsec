import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:roboteacher_zimsec/screens/curriculum_screen.dart';
import 'package:roboteacher_zimsec/services/database_service.dart';
import 'package:roboteacher_zimsec/services/theme_service.dart';

class MockDatabaseService extends DatabaseService {
  @override
  Future<void> initialize() async {}
  @override
  get curriculumBox => null;
  // Add more overrides as needed to prevent Hive access
}

void main() {
  testWidgets('CurriculumScreen shows subject buttons and ZIMSEC links',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
          ChangeNotifierProvider<DatabaseService>(
              create: (_) => MockDatabaseService()),
        ],
        child: const MaterialApp(
          home: CurriculumScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Check for at least one subject button
    expect(find.byType(ElevatedButton), findsWidgets);
    // Check for ZIMSEC syllabus link button
    expect(find.textContaining('ZIMSEC'), findsWidgets);
  });
}
