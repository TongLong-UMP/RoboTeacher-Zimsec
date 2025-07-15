import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _schoolIdController = TextEditingController();
  String _role = 'student';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _schoolIdController,
              decoration: const InputDecoration(labelText: 'School ID'),
            ),
            DropdownButton<String>(
              value: _role,
              items:
                  ['student', 'teacher', 'parent', 'admin'].map((String role) {
                return DropdownMenuItem<String>(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final user = await authService.signUp(
                  _emailController.text,
                  _passwordController.text,
                  _role,
                  _schoolIdController.text,
                );
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = await authService.signIn(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
