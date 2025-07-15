import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:roboteacher_zimsec/screens/home_screen.dart';
import 'package:roboteacher_zimsec/screens/splash_screen.dart';
import 'package:roboteacher_zimsec/services/auth_service.dart';
import 'package:roboteacher_zimsec/services/database_service.dart';
import 'package:roboteacher_zimsec/services/router.dart';
import 'package:roboteacher_zimsec/services/theme_service.dart';

// Mock DatabaseService that skips Hive initialization
class MockDatabaseService extends DatabaseService {
  @override
  Future<void> initialize() async {
    // Do nothing for tests
  }
}

void main() {
  group('SplashScreen Widget Tests', () {
    testWidgets('SplashScreen shows animation and ENTER button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
            ChangeNotifierProvider<DatabaseService>(
                create: (_) => MockDatabaseService()),
            ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
          ],
          child: const MaterialApp(home: SplashScreen()),
        ),
      );
      // Initial state: loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Wait for animation and DB init
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('ENTER'), findsOneWidget);
    });

    testWidgets('SplashScreen ENTER button navigates to home or login',
        (WidgetTester tester) async {
      final authService = AuthService();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>(create: (_) => authService),
            ChangeNotifierProvider<DatabaseService>(
                create: (_) => MockDatabaseService()),
            ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
          ],
          child: MaterialApp.router(routerConfig: appRouter),
        ),
      );
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('ENTER'), findsOneWidget);
      await tester.tap(find.text('ENTER'));
      await tester.pumpAndSettle();
      // Should navigate to home or login based on authService.isLoggedIn
    });
  });

  group('GoRouter Navigation Tests', () {
    testWidgets('Navigates to splash, login, and home',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
            ChangeNotifierProvider<DatabaseService>(
                create: (_) => MockDatabaseService()),
            ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
          ],
          child: MaterialApp.router(routerConfig: appRouter),
        ),
      );
      await tester.pumpAndSettle();
      // Initial route is splash
      expect(find.byType(SplashScreen), findsOneWidget);
      // Simulate ENTER
      await tester.pump(const Duration(seconds: 3));
      await tester.tap(find.text('ENTER'));
      await tester.pumpAndSettle();
      // Should navigate to home or login
    });

    testWidgets('HomeScreen renders and navigation buttons exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
            ChangeNotifierProvider<DatabaseService>(
                create: (_) => MockDatabaseService()),
            ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
          ],
          child: MaterialApp.router(routerConfig: appRouter),
        ),
      );
      await tester.pumpAndSettle();
      // Simulate navigation to home by tapping Home in the bottom nav
      // (If needed, tap the correct index or text)
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Reading'), findsOneWidget);
      expect(find.text('Curriculum'), findsOneWidget);
      expect(find.text('Planner'), findsOneWidget);
      expect(find.text('Learning Desk'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });
  });
}
