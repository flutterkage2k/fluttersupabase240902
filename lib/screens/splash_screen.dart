import 'package:flutter/material.dart';
import 'package:fluttersupabase240902/screens/home_screen.dart';
import 'package:fluttersupabase240902/screens/login_screen.dart';
import 'package:fluttersupabase240902/services/auth_service.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // authService.signOut();

    return authService.currentUser == null ? const LoginScreen() : const HomeScreen();
  }
}
