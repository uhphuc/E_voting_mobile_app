import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/core/storage/token_storage.dart';
import 'package:provider/provider.dart';
import 'package:project/features/auth/controllers/auth_provider.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/screens/splash_screen.dart';

import '../../../models/user_info_model.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfoModel? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.user!.id;
    final token = await TokenStorage.getToken();

    final user = await ProfileService.getUserProfile(
      id: userId,
      token: token!,
    );

    setState(() {
      userInfo = user;
      isLoading = false;
    });
  }

  void logout() {
    AuthService.logOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat("dd/MM/yyyy").format(date);
  }

  /// 👇 reusable tile
  Widget buildInfoTile({
    required String label,
    required String value,
    IconData? icon,
    Color? color,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: color) : null,
      title: Text(label),
      subtitle: Text(value),
    );
  }

  /// 👇 gender with icon
  Widget buildGenderTile(String? gender) {
    switch (gender?.toLowerCase()) {
      case "male":
        return buildInfoTile(
          label: "Gender",
          value: "Male",
          icon: Icons.male,
          color: Colors.blue,
        );
      case "female":
        return buildInfoTile(
          label: "Gender",
          value: "Female",
          icon: Icons.female,
          color: Colors.pink,
        );
      default:
        return buildInfoTile(
          label: "Gender",
          value: "N/A",
          icon: Icons.help_outline,
          color: Colors.grey,
        );
    }
  }

  /// 👇 role beautify
  String formatRole(String? role) {
    if (role == null) return "N/A";
    return role[0].toUpperCase() + role.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userInfo == null
          ? const Center(child: Text("Failed to load user"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 👇 Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF5170FF),
              foregroundColor: Colors.white,
              child: Icon(Icons.person, size: 50),
            ),

            const SizedBox(height: 20),

            /// 👇 Name
            Text(
              userInfo!.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// 👇 Info Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildInfoTile(
                      label: "Email",
                      value: userInfo!.email,
                      icon: Icons.email,
                      color: Colors.redAccent
                    ),
                    buildInfoTile(
                      label: "Phone",
                      value: userInfo!.phone ?? "No phone",
                      icon: Icons.phone,
                      color: Colors.amber
                    ),

                    /// 👇 dùng gender tile mới
                    buildGenderTile(userInfo!.gender),

                    buildInfoTile(
                      label: "Birth Date",
                      value: formatDate(userInfo!.birthDate),
                      icon: Icons.cake,
                      color: Colors.purpleAccent
                    ),
                    buildInfoTile(
                      label: "Address",
                      value: userInfo!.address ?? "N/A",
                      icon: Icons.location_on,
                      color: Colors.green
                    ),
                    buildInfoTile(
                      label: "Role",
                      value: formatRole(userInfo!.role),
                      icon: Icons.badge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 👇 Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}