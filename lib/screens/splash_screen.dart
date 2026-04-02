import 'package:flutter/material.dart';
import 'package:project/features/auth/controllers/auth_provider.dart';
import 'package:project/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

import '../features/auth/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });
  }

  void checkAuth() async {
    final user = await AuthService.getMe();

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      Provider.of<AuthProvider>(context, listen: false).setUser(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNav()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
        body: Center(child: CircularProgressIndicator())
    );

  }
}