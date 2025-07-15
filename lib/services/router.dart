import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/analytics_screen.dart';
import '../screens/children_progress_screen.dart';
import '../screens/contact_teachers_screen.dart';
import '../screens/curriculum_screen.dart';
import '../screens/home_screen.dart';
import '../screens/learning_desk_screen.dart';
import '../screens/login_screen.dart';
import '../screens/manage_users_screen.dart';
import '../screens/planner_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/reading_screen.dart';
import '../screens/social_feed_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/students_screen.dart';
import '../screens/teachers_screen.dart';
import '../services/auth_service.dart';
import '../widgets/main_scaffold.dart';
// Add other screens as needed

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) =>
          const MainScaffold(currentIndex: 0, child: HomeScreen()),
    ),
    GoRoute(
      path: '/community',
      name: 'community',
      builder: (context, state) =>
          const MainScaffold(currentIndex: 1, child: SocialFeedScreen()),
    ),
    GoRoute(
      path: '/reading',
      name: 'reading',
      builder: (context, state) =>
          MainScaffold(currentIndex: 2, child: ReadingScreen()),
    ),
    GoRoute(
      path: '/curriculum',
      name: 'curriculum',
      builder: (context, state) =>
          const MainScaffold(currentIndex: 3, child: CurriculumScreen()),
    ),
    GoRoute(
      path: '/planner',
      name: 'planner',
      builder: (context, state) =>
          MainScaffold(currentIndex: 4, child: PlannerScreen()),
    ),
    GoRoute(
      path: '/learning-desk',
      name: 'learning_desk',
      builder: (context, state) =>
          const MainScaffold(currentIndex: 5, child: LearningDeskScreen()),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) =>
          const MainScaffold(currentIndex: 6, child: ProfileScreen()),
    ),
    GoRoute(
      path: '/manage-users',
      name: 'manage_users',
      builder: (context, state) => const ManageUsersScreen(),
    ),
    GoRoute(
      path: '/analytics',
      name: 'analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/students',
      name: 'students',
      builder: (context, state) => StudentsScreen(
          students: state.extra as List<Map<String, dynamic>>? ?? const []),
    ),
    GoRoute(
      path: '/teachers',
      name: 'teachers',
      builder: (context, state) => TeachersScreen(
          teachers: state.extra as List<Map<String, dynamic>>? ?? const []),
    ),
    GoRoute(
      path: '/children-progress',
      name: 'children_progress',
      builder: (context, state) => ChildrenProgressScreen(
          children: state.extra as List<Map<String, dynamic>>? ?? const []),
    ),
    GoRoute(
      path: '/contact-teachers',
      name: 'contact_teachers',
      builder: (context, state) => const ContactTeachersScreen(),
    ),
  ],
  redirect: (context, state) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final loggedIn = authService.isLoggedIn;
    final loggingIn = state.fullPath == '/login';
    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/';
    return null;
  },
);
