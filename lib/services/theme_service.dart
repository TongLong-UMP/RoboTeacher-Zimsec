import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppTheme { western, african }

class ThemeService extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.african;

  AppTheme get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme =
        _currentTheme == AppTheme.western ? AppTheme.african : AppTheme.western;
    notifyListeners();
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  ThemeData getThemeData() {
    switch (_currentTheme) {
      case AppTheme.western:
        return _westernTheme;
      case AppTheme.african:
        return _africanTheme;
    }
  }

  // Western Theme - Cowboy/Wild West inspired
  ThemeData get _westernTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.brown,
      primaryColor: const Color(0xFF8B4513), // Saddle Brown
      scaffoldBackgroundColor: const Color(0xFFF5F5DC), // Beige
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF8B4513),
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFD2B48C), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B4513),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B4513),
          fontFamily: 'serif',
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B4513),
          fontFamily: 'serif',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF2F2F2F),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF2F2F2F),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8B4513),
        secondary: Color(0xFFD2B48C),
        surface: Colors.white,
        error: Color(0xFFDC143C),
        onPrimary: Colors.white,
        onSecondary: Color(0xFF2F2F2F),
        onSurface: Color(0xFF2F2F2F),
        onError: Colors.white,
      ),
    );
  }

  // African Theme - Vibrant and colorful
  ThemeData get _africanTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      primaryColor: const Color(0xFFFF6B35), // Vibrant Orange
      scaffoldBackgroundColor: const Color(0xFFFEF9E7), // Warm Yellow
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFFD700), width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B35),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF6B35),
          fontFamily: 'sans-serif',
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF6B35),
          fontFamily: 'sans-serif',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF2F2F2F),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF2F2F2F),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFF6B35),
        secondary: Color(0xFFFFD700),
        tertiary: Color(0xFF8E44AD),
        surface: Colors.white,
        error: Color(0xFFE74C3C),
        onPrimary: Colors.white,
        onSecondary: Color(0xFF2F2F2F),
        onTertiary: Colors.white,
        onSurface: Color(0xFF2F2F2F),
        onError: Colors.white,
      ),
    );
  }

  // Theme-specific gradient colors
  List<Color> get primaryGradient {
    switch (_currentTheme) {
      case AppTheme.western:
        return [
          const Color(0xFF8B4513),
          const Color(0xFFD2B48C),
        ];
      case AppTheme.african:
        return [
          const Color(0xFFFF6B35),
          const Color(0xFFFFD700),
        ];
    }
  }

  List<Color> get secondaryGradient {
    switch (_currentTheme) {
      case AppTheme.western:
        return [
          const Color(0xFFD2B48C),
          const Color(0xFFF5F5DC),
        ];
      case AppTheme.african:
        return [
          const Color(0xFFFFD700),
          const Color(0xFF8E44AD),
        ];
    }
  }

  // Theme-specific decoration patterns
  BoxDecoration get cardDecoration {
    switch (_currentTheme) {
      case AppTheme.western:
        return BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD2B48C), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B4513).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case AppTheme.african:
        return BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD700), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        );
    }
  }

  // User-selectable background asset (null = default color)
  String? _backgroundAsset;
  String? get backgroundAsset => _backgroundAsset;
  void setBackgroundAsset(String? asset) {
    _backgroundAsset = asset;
    notifyListeners();
  }
}
