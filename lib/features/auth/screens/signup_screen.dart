import 'package:flutter/material.dart';
import 'package:project/features/auth/screens/login_screen.dart';
import 'package:project/screens/splash_screen.dart';

import '../../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();
  final addressController = TextEditingController();

  DateTime? selectedDate;
  String gender = "male";
  String role = "voter";

  Future<void> pickDate() async {
    DateTime now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        birthDateController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void register() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select birth date")),
      );
      return;
    }


    final user = await AuthService.register(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      phone: phoneController.text,
      gender: gender,
      role: role,
      birthDate: selectedDate!,
      address: addressController.text
    );


    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register success")),
      );
      final login = AuthService.login(user.email, passwordController.text);
      if(login != null){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SplashScreen(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text( "Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) =>
                v!.contains("@") ? null : "Invalid email",
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (v) =>
                v!.length >= 6 ? null : "Min 6 characters",
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextFormField(
                controller: birthDateController,
                readOnly: true,
                onTap: pickDate,
                decoration: const InputDecoration(
                  labelText: "Birth Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),

              const SizedBox(height: 10),

              // Gender dropdown
              DropdownButtonFormField(
                value: gender,
                items: const [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                ],
                onChanged: (v) => setState(() => gender = v.toString()),
                decoration: const InputDecoration(labelText: "Gender"),
              ),


              // Role dropdown
              DropdownButtonFormField(
                value: role,
                items: const [
                  DropdownMenuItem(value: "voter", child: Text("Voter")),
                  DropdownMenuItem(value: "manager", child: Text("Manager")),
                ],
                onChanged: (v) => setState(() => role = v.toString()),
                decoration: const InputDecoration(labelText: "Role"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: register,
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: 10),

              // 🔥 NEW: Sign Up button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text("Already have an account? Sign In"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}