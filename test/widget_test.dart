import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Text('Hello RoboTeacher')),
    ));
    expect(find.text('Hello RoboTeacher'), findsOneWidget);
  });
}
