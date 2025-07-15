import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:roboteacher_zimsec/screens/planner_screen.dart';
import 'package:roboteacher_zimsec/services/auth_service.dart';
import 'package:roboteacher_zimsec/services/database_service.dart';
import 'package:roboteacher_zimsec/services/theme_service.dart';

class MockDatabaseService extends DatabaseService {
  @override
  Future<void> initialize() async {}
}

class MockAuthService extends AuthService {}

void main() {
  testWidgets('PlannerScreen shows fallback UI or planner content',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
          ChangeNotifierProvider<DatabaseService>(
              create: (_) => MockDatabaseService()),
          ChangeNotifierProvider<AuthService>(create: (_) => MockAuthService()),
        ],
        child: MaterialApp(
          home: PlannerScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Check for fallback UI (e.g., "No planner data" or similar)
    expect(find.textContaining('No planner'), findsWidgets);
    // Or check for planner content if present
    expect(find.textContaining('Planner'), findsWidgets);
  });
}
