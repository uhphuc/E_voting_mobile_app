import 'package:flutter/material.dart';
import 'package:project/features/auth/screens/signup_screen.dart';
import 'package:project/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../controllers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void handleLogin() async {

    setState(() {
      isLoading = true;
    });

    UserModel? user = await AuthService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      Provider.of<AuthProvider>(context, listen: false).setUser(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BottomNav(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: handleLogin,
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),

            // 🔥 NEW: Sign Up button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}