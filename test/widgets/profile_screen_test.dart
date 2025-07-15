import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:roboteacher_zimsec/screens/profile_screen.dart';
import 'package:roboteacher_zimsec/services/auth_service.dart';
import 'package:roboteacher_zimsec/services/database_service.dart';
import 'package:roboteacher_zimsec/services/theme_service.dart';

class MockDatabaseService extends DatabaseService {
  @override
  Future<void> initialize() async {}
}

class MockAuthService extends AuthService {}

void main() {
  testWidgets(
      'ProfileScreen shows avatar, theme selection, and commitment report',
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
          home: ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Check for avatar selection widget
    expect(find.textContaining('Avatar'), findsWidgets);
    // Check for theme selection widget
    expect(find.textContaining('Theme'), findsWidgets);
    // Check for commitment report
    expect(find.textContaining('Commitment'), findsWidgets);
  });
}
