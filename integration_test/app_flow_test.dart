import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:roboteacher_zimsec/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app flow: navigation and key screens', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Home screen should be visible
    expect(find.text('Home'), findsOneWidget);

    // Tap on Community/Feed
    await tester.tap(find.text('Community'));
    await tester.pumpAndSettle();
    expect(find.text('Community'), findsWidgets);

    // Tap on Reading
    await tester.tap(find.text('Reading'));
    await tester.pumpAndSettle();
    expect(find.text('Reading'), findsWidgets);

    // Tap on Curriculum
    await tester.tap(find.text('Curriculum'));
    await tester.pumpAndSettle();
    expect(find.text('Curriculum'), findsWidgets);

    // Tap on Planner
    await tester.tap(find.text('Planner'));
    await tester.pumpAndSettle();
    expect(find.text('Planner'), findsWidgets);

    // Tap on Learning Desk
    await tester.tap(find.text('Learning Desk'));
    await tester.pumpAndSettle();
    expect(find.text('Learning Desk'), findsWidgets);

    // Tap on Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsWidgets);
  });
} 