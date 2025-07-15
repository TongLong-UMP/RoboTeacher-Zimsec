import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/localization_service.dart';
import 'services/router.dart';
import 'services/social_feed_service.dart';
import 'services/teacher_chat_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const RoboTeacherApp());
}

class RoboTeacherApp extends StatelessWidget {
  const RoboTeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<DatabaseService>(
            create: (_) => DatabaseService()),
        ChangeNotifierProvider<LocalizationService>(
            create: (_) => LocalizationService()),
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
        ChangeNotifierProvider<SocialFeedService>(
            create: (_) => SocialFeedService()),
        Provider<TeacherChatService>(create: (_) => TeacherChatService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp.router(
            title: 'RoboTeacher ZIMSEC',
            debugShowCheckedModeBanner: false,
            theme: themeService.getThemeData(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('sn', 'ZW'), // Shona
              Locale('nd', 'ZW'), // Ndebele
            ],
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
