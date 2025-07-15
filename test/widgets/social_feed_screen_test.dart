import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:roboteacher_zimsec/screens/social_feed_screen.dart';
import 'package:roboteacher_zimsec/services/social_feed_service.dart';
import 'package:roboteacher_zimsec/services/theme_service.dart';

class MockSocialFeedService extends SocialFeedService {
  @override
  void dispose() {}
}

void main() {
  testWidgets('SocialFeedScreen shows MainBottomNavBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SocialFeedService>(
              create: (_) => MockSocialFeedService()),
          ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
        ],
        child: const MaterialApp(
          home: SocialFeedScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Check for BottomNavigationBar (actual widget rendered)
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    // Check for Community tab
    expect(find.text('Community'), findsOneWidget);
  });

  testWidgets('SocialFeedScreen shows advertising banner and demo chat panel',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SocialFeedService>(
              create: (_) => MockSocialFeedService()),
          ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
        ],
        child: const MaterialApp(
          home: SocialFeedScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Check for advertising banner
    expect(find.textContaining('Advert'), findsOneWidget);
    // Check for demo chat panel (update text to match actual implementation)
    expect(find.textContaining('Demo Community Chat'), findsWidgets);
  });
}
