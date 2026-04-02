import 'package:flutter/material.dart';
import '../../../core/storage/token_storage.dart';
import '../../../models/user_model.dart';

class AuthProvider extends ChangeNotifier {

  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  // getters
  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  // 🔥 set full auth (login / splash)
  void setAuth({
    required UserModel user,
    required String token,
  }) {
    _user = user;
    _token = token;
    notifyListeners();
  }

  // 🔥 update user (edit profile)
  void setUser(UserModel userData) {
    _user = userData;
    notifyListeners();
  }

  // 🔥 init từ storage (auto login)
  Future<void> initAuth(Future<UserModel?> Function(String token) getUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await TokenStorage.getToken();
      print("Token loaded: $token");

      if (token != null) {
        final user = await getUser(token);
        print("User loaded: $user");

        if (user != null) {
          _user = user;
          _token = token;
        }
      }
    } catch (e) {
      print("InitAuth ERROR: $e"); // 🔥 cực kỳ quan trọng
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔥 logout
  Future<void> logout() async {
    _user = null;
    _token = null;

    await TokenStorage.clearToken();

    notifyListeners();
  }
}