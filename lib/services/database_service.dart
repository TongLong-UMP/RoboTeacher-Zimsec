// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class DatabaseService extends ChangeNotifier {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Offline storage using Hive
  late Box _curriculumBox;
  late Box _userProgressBox;
  late Box _settingsBox;
  late Box _learnerPlannerBox;
  late Box _schoolPlannerBox;

  // Mock data storage for local development
  final Map<String, dynamic> _mockData = {};

  // Initialize Hive boxes
  Future<void> initialize() async {
    _curriculumBox = await Hive.openBox('curriculum');
    _userProgressBox = await Hive.openBox('user_progress');
    _settingsBox = await Hive.openBox('settings');
    _learnerPlannerBox = await Hive.openBox('learner_planner');
    _schoolPlannerBox = await Hive.openBox('school_planner');
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    // Simulate profile update
    _mockData['profile_$userId'] = data;
    print('Profile updated for user $userId: $data');
  }

  Future<void> saveProgress(String userId, String subject, String topic,
      Map<String, dynamic> progress) async {
    // Simulate progress saving
    String key = 'progress_${userId}_${subject}_$topic';
    _mockData[key] = progress;
    print('Progress saved: $key = $progress');
  }

  Future<void> submitAssignment(
      String userId, String assignmentId, String content) async {
    // Simulate assignment submission
    String key = 'assignment_${assignmentId}_$userId';
    _mockData[key] = {
      'content': content,
      'submittedAt': DateTime.now().toIso8601String(),
    };
    print('Assignment submitted: $key');
  }

  Future<List<Map<String, dynamic>>> getCurriculumContent(String grade) async {
    try {
      // Try to get cached curriculum data first
      final cachedData = _curriculumBox.get(grade);
      if (cachedData != null) {
        print('Using cached curriculum data for $grade');
        return List<Map<String, dynamic>>.from(cachedData);
      }
    } catch (e) {
      print('Error accessing cached curriculum: $e');
    }

    // Fallback to mock curriculum data
    final mockData = [
      {
        'name': 'English Language',
        'description': 'Reading, Writing, and Communication',
        'topics': ['Phonics', 'Reading Comprehension', 'Writing Skills'],
        'grade': grade,
      },
      {
        'name': 'Mathematics',
        'description': 'Numbers, Algebra, and Geometry',
        'topics': ['Number Operations', 'Fractions', 'Geometry'],
        'grade': grade,
      },
      {
        'name': 'Science',
        'description': 'Physics, Chemistry, and Biology',
        'topics': ['Matter and Energy', 'Living Things', 'Earth Science'],
        'grade': grade,
      },
      {
        'name': 'History',
        'description': 'World History and Local History',
        'topics': ['Zimbabwe History', 'World Events', 'Cultural Heritage'],
        'grade': grade,
      },
      {
        'name': 'Geography',
        'description': 'Physical and Human Geography',
        'topics': ['Zimbabwe Geography', 'Climate', 'Natural Resources'],
        'grade': grade,
      },
    ];

    // Cache the data for offline use
    try {
      await _curriculumBox.put(grade, mockData);
      print('Cached curriculum data for $grade');
    } catch (e) {
      print('Error caching curriculum data: $e');
    }

    return mockData;
  }

  // Cache curriculum content for offline use
  Future<void> cacheCurriculumContent(
      String grade, List<Map<String, dynamic>> content) async {
    try {
      await _curriculumBox.put(grade, content);
      print('Successfully cached curriculum content for $grade');
    } catch (e) {
      print('Error caching curriculum content: $e');
    }
  }

  // Get cached curriculum content
  Future<List<Map<String, dynamic>>> getCachedCurriculumContent(
      String grade) async {
    try {
      final data = _curriculumBox.get(grade);
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Error getting cached curriculum: $e');
    }
    return [];
  }

  // Save user progress with offline storage
  Future<void> saveUserProgressOffline(String userId, String subject,
      String topic, Map<String, dynamic> progress) async {
    try {
      final key = 'progress_${userId}_${subject}_$topic';
      await _userProgressBox.put(key, progress);
      print('Progress saved offline: $key');
    } catch (e) {
      print('Error saving progress offline: $e');
    }
  }

  // Get user progress from offline storage
  Future<List<Map<String, dynamic>>> getUserProgressOffline(
      String userId) async {
    try {
      final keys = _userProgressBox.keys
          .where((key) => key.toString().startsWith('progress_${userId}_'));
      final progress = <Map<String, dynamic>>[];

      for (final key in keys) {
        final data = _userProgressBox.get(key);
        if (data != null) {
          progress.add(Map<String, dynamic>.from(data));
        }
      }

      return progress;
    } catch (e) {
      print('Error getting user progress: $e');
      return [];
    }
  }

  // Persistent storage for learner planner
  Future<List<Map<String, dynamic>>> getLearnerPlanner(String userId) async {
    try {
      final data = _learnerPlannerBox.get(userId);
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Error getting learner planner: $e');
    }
    return [];
  }

  Future<void> saveLearnerPlanner(
      String userId, List<Map<String, dynamic>> planner) async {
    try {
      await _learnerPlannerBox.put(userId, planner);
      print('Saved learner planner for $userId');
    } catch (e) {
      print('Error saving learner planner: $e');
    }
  }

  Future<void> addLearnerPlannerEntry(
      String userId, Map<String, dynamic> entry) async {
    final planner = await getLearnerPlanner(userId);
    planner.add(entry);
    await saveLearnerPlanner(userId, planner);
  }

  Future<void> removeLearnerPlannerEntry(String userId, int index) async {
    final planner = await getLearnerPlanner(userId);
    if (index >= 0 && index < planner.length) {
      planner.removeAt(index);
      await saveLearnerPlanner(userId, planner);
    }
  }

  // Persistent storage for teacher-sent planner dates
  Future<List<Map<String, dynamic>>> getTeacherPlannerDates(
      String userId) async {
    try {
      final data = _learnerPlannerBox.get('teacherDates_$userId');
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Error getting teacher planner dates: $e');
    }
    return [];
  }

  Future<void> addTeacherPlannerDate(
      String userId, Map<String, dynamic> entry) async {
    final dates = await getTeacherPlannerDates(userId);
    dates.add(entry);
    await _learnerPlannerBox.put('teacherDates_$userId', dates);
    print('Added teacher date for $userId');
  }

  Future<void> removeTeacherPlannerDate(String userId, int index) async {
    final dates = await getTeacherPlannerDates(userId);
    if (index >= 0 && index < dates.length) {
      dates.removeAt(index);
      await _learnerPlannerBox.put('teacherDates_$userId', dates);
    }
  }

  // Persistent storage for school planner (admin)
  Future<List<Map<String, dynamic>>> getSchoolPlanner() async {
    try {
      final data = _schoolPlannerBox.get('school_planner');
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Error getting school planner: $e');
    }
    return [];
  }

  Future<void> saveSchoolPlanner(List<Map<String, dynamic>> planner) async {
    try {
      await _schoolPlannerBox.put('school_planner', planner);
      print('Saved school planner');
    } catch (e) {
      print('Error saving school planner: $e');
    }
  }

  Future<void> addSchoolPlannerEntry(Map<String, dynamic> entry) async {
    final planner = await getSchoolPlanner();
    planner.add(entry);
    await saveSchoolPlanner(planner);
  }

  Future<void> editSchoolPlannerEntry(
      int index, Map<String, dynamic> entry) async {
    final planner = await getSchoolPlanner();
    if (index >= 0 && index < planner.length) {
      planner[index] = entry;
      await saveSchoolPlanner(planner);
    }
  }

  Future<void> removeSchoolPlannerEntry(int index) async {
    final planner = await getSchoolPlanner();
    if (index >= 0 && index < planner.length) {
      planner.removeAt(index);
      await saveSchoolPlanner(planner);
    }
  }

  // Mock: Get school info
  Future<Map<String, dynamic>> getSchoolInfo(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'name': 'Robo Academy',
      'address': '123 Main St, Harare',
      'contact': 'admin@roboacademy.co.zw',
    };
  }

  // Mock: Get all teachers for a school
  Future<List<Map<String, dynamic>>> getTeachers(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'name': 'Mrs. Sarah Johnson',
        'email': 'sarah@school.co.zw',
        'subjects': ['Mathematics', 'Science']
      },
      {
        'name': 'Mr. Moyo',
        'email': 'moyo@school.co.zw',
        'subjects': ['English', 'History']
      },
    ];
  }

  // Mock: Get all students for a school
  Future<List<Map<String, dynamic>>> getStudents(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'name': 'Tinashe', 'grade': '5', 'parent': 'parent@email.com'},
      {'name': 'Chipo', 'grade': '3', 'parent': 'parent@email.com'},
    ];
  }

  // Mock: Get all parents for a school
  Future<List<Map<String, dynamic>>> getParents(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'name': 'Mrs. Chikafu',
        'email': 'parent@email.com',
        'children': ['Tinashe', 'Chipo']
      },
    ];
  }

  // Mock: Get children for a parent
  Future<List<Map<String, dynamic>>> getChildrenForParent(
      String parentEmail) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'name': 'Tinashe', 'grade': '5'},
      {'name': 'Chipo', 'grade': '3'},
    ];
  }

  // Mock: Get teachers for a student
  Future<List<Map<String, dynamic>>> getTeachersForStudent(
      String studentName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'name': 'Mrs. Sarah Johnson', 'email': 'sarah@school.co.zw'},
      {'name': 'Mr. Moyo', 'email': 'moyo@school.co.zw'},
    ];
  }

  // Mock: Get contact info for a user
  Future<String> getContactInfo(String email) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return email;
  }

  // Mock: Get subjects for a teacher
  Future<List<String>> getSubjectsForTeacher(String teacherEmail) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (teacherEmail == 'sarah@school.co.zw') return ['Mathematics', 'Science'];
    if (teacherEmail == 'moyo@school.co.zw') return ['English', 'History'];
    return ['General Studies'];
  }

  // Clear cache for a specific grade
  Future<void> clearCurriculumCache(String grade) async {
    try {
      await _curriculumBox.delete(grade);
      print('Cleared curriculum cache for $grade');
    } catch (e) {
      print('Error clearing curriculum cache: $e');
    }
  }

  // Get cache size information
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final curriculumSize = _curriculumBox.length;
      final progressSize = _userProgressBox.length;
      final settingsSize = _settingsBox.length;

      return {
        'curriculum_entries': curriculumSize,
        'progress_entries': progressSize,
        'settings_entries': settingsSize,
      };
    } catch (e) {
      print('Error getting cache info: $e');
      return {};
    }
  }
}
