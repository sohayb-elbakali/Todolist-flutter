import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome.dart';
import 'home.dart';

class AuthVerify extends StatefulWidget {
  const AuthVerify({super.key});

  @override
  State<AuthVerify> createState() => _AuthVerifyState();
}

class _AuthVerifyState extends State<AuthVerify> {
  bool _showWelcome = false;
  User? _lastUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C63FF),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          // User logged out - reset welcome flag
          _lastUser = null;
          _showWelcome = false;
          
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            headerBuilder: (BuildContext context, BoxConstraints constraints,
                double shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const FlutterLogo();
                    },
                  ),
                ),
              );
            },
          );
        }

        // User is logged in
        final currentUser = snapshot.data;
        
        // Check if this is a new login (user changed from null to logged in)
        final isNewLogin = _lastUser == null && currentUser != null;
        _lastUser = currentUser;

        // Show welcome screen on new login
        if (isNewLogin && !_showWelcome) {
          _showWelcome = true;
          return const WelcomeScreen();
        }

        // Regular home screen
        return const HomeScreen();
      },
    );
  }
}