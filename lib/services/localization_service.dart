import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const Locale _defaultLocale = Locale('en', '');

  Locale _currentLocale = _defaultLocale;

  Locale get currentLocale => _currentLocale;

  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('sn', ''), // Shona
    Locale('nd', ''), // Ndebele
  ];

  // Translation maps
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'welcome': 'Welcome to RoboTeacher_Zimsec',
      'login': 'Login',
      'sign_up': 'Sign Up',
      'sign_in': 'Sign In',
      'email': 'Email',
      'password': 'Password',
      'school_id': 'School ID',
      'role': 'Role',
      'student': 'Student',
      'teacher': 'Teacher',
      'parent': 'Parent',
      'reading_module': 'Reading Module',
      'curriculum_portal': 'Curriculum Portal',
      'profile': 'Profile',
      'logout': 'Logout',
      'current_word': 'Current Word',
      'syllables': 'Syllables',
      'test_pronunciation': 'Test Pronunciation',
      'rating': 'Rating',
      'next_word': 'Next Word',
      'english_language': 'English Language',
      'mathematics': 'Mathematics',
      'science': 'Science',
      'history': 'History',
      'geography': 'Geography',
      'reading_writing_communication': 'Reading, Writing, and Communication',
      'numbers_algebra_geometry': 'Numbers, Algebra, and Geometry',
      'physics_chemistry_biology': 'Physics, Chemistry, and Biology',
      'world_history_local_history': 'World History and Local History',
      'physical_human_geography': 'Physical and Human Geography',
    },
    'sn': {
      'welcome': 'Mhoro kuRoboTeacher_Zimsec',
      'login': 'Pinda',
      'sign_up': 'Nyora',
      'sign_in': 'Pinda',
      'email': 'Email',
      'password': 'Password',
      'school_id': 'ID Yechikoro',
      'role': 'Baso',
      'student': 'Mudzidzi',
      'teacher': 'Mudzidzisi',
      'parent': 'Mubereki',
      'reading_module': 'Module yekuVerenga',
      'curriculum_portal': 'Portal yeCurriculum',
      'profile': 'Profile',
      'logout': 'Buda',
      'current_word': 'Izwi Razvino',
      'syllables': 'Masirabhu',
      'test_pronunciation': 'Edza Kududzira',
      'rating': 'Chiyero',
      'next_word': 'Izwi Rinotevera',
      'english_language': 'Mutauro weChirungu',
      'mathematics': 'Masvomhu',
      'science': 'Sainzi',
      'history': 'Nhoroondo',
      'geography': 'Geography',
      'reading_writing_communication': 'Kuverenga, Kunyora, uye Kutaurirana',
      'numbers_algebra_geometry': 'Nhamba, Algebra, uye Geometry',
      'physics_chemistry_biology': 'Fizikisi, Chemistry, uye Biology',
      'world_history_local_history': 'Nhoroondo Yenyika uye Nhoroondo Yemuno',
      'physical_human_geography': 'Geography Yemuviri uye Yevanhu',
    },
    'nd': {
      'welcome': 'Sawubona kuRoboTeacher_Zimsec',
      'login': 'Ngena',
      'sign_up': 'Bhalisa',
      'sign_in': 'Ngena',
      'email': 'Email',
      'password': 'Password',
      'school_id': 'ID Yesikolo',
      'role': 'Indima',
      'student': 'Umfundi',
      'teacher': 'Uthisha',
      'parent': 'Umzali',
      'reading_module': 'Module Yokufunda',
      'curriculum_portal': 'Portal Yekharikhulamu',
      'profile': 'Iphrofayili',
      'logout': 'Phuma',
      'current_word': 'Igama Langamanje',
      'syllables': 'Amasilabhasi',
      'test_pronunciation': 'Hlola Ukubiza',
      'rating': 'Isilinganiso',
      'next_word': 'Igama Elilandelayo',
      'english_language': 'Ulimi LwesiNgisi',
      'mathematics': 'Izibalo',
      'science': 'Isayensi',
      'history': 'Umlando',
      'geography': 'Ijografi',
      'reading_writing_communication': 'Ukufunda, Ukubhala, nokuxhumana',
      'numbers_algebra_geometry': 'Izibalo, I-algebra, ne-geometry',
      'physics_chemistry_biology': 'I-fiziksi, I-chemistry, ne-biology',
      'world_history_local_history': 'Umlando Womhlaba nokwasekhaya',
      'physical_human_geography': 'Ijografi Yomzimba nokwabantu',
    },
  };

  LocalizationService() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    _currentLocale = Locale(languageCode, '');
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      _currentLocale = Locale(languageCode, '');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }

  String translate(String key) {
    final translations =
        _translations[_currentLocale.languageCode] ?? _translations['en'] ?? {};
    return translations[key] ?? key;
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'sn':
        return 'Shona';
      case 'nd':
        return 'Ndebele';
      default:
        return 'English';
    }
  }
}
