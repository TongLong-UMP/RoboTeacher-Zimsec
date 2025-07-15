import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Added import for GoRouter
import 'package:provider/provider.dart';

import '../services/auth_service.dart'; // Added import for AuthService
import '../services/database_service.dart';
import '../services/theme_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showEnterButton = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    _startAppInitialization();
  }

  Future<void> _startAppInitialization() async {
    _animationController.forward();
    await Future.delayed(const Duration(seconds: 2));
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    await databaseService.initialize();
    setState(() {
      _showEnterButton = true;
    });
  }

  void _enterApp() {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isLoggedIn) {
      GoRouter.of(context).go('/');
    } else {
      GoRouter.of(context).go('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeService.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          themeService.currentTheme == AppTheme.western
                              ? Icons.school
                              : Icons.psychology,
                          size: 60,
                          color: themeService.currentTheme == AppTheme.western
                              ? const Color(0xFF8B4513)
                              : const Color(0xFFFF6B35),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // App Title
                      Text(
                        'RoboTeacher',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily:
                              themeService.currentTheme == AppTheme.western
                                  ? 'serif'
                                  : 'sans-serif',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Human-Tech Collaboration for Education.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ZIMSEC Learning Platform',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Loading indicator or ENTER button
                      _showEnterButton
                          ? ElevatedButton(
                              onPressed: _enterApp,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'ENTER',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.8),
                                ),
                                strokeWidth: 3,
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
