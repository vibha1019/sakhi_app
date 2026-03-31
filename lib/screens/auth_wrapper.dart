import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  final Widget home;
  const AuthWrapper({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) return home;       // logged in → HomeScreen
        return const LoginScreen();              // not logged in → your existing LoginScreen
      },
    );
  }
}