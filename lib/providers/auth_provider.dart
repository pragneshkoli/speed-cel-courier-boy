import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/models.dart';
import '../../utils/mock_data.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  User? get user => _user;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;

  String get errorMessage => _errorMessage;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        _user = User.fromJson(userData);
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading user data: $e');
      }
    }
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    await prefs.setString('token', user.token);
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // final response = await MockData.login(email, password);
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('http://localhost:3000/courier-boy/login'),
      );
      request.body = json.encode({"email": email, "password": password});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseString);

      if (response.statusCode == 200) {
        _user = User.fromJson(responseJson);
        await _saveUserToPrefs(_user!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        if (response.statusCode == 401) {
          _errorMessage = 'Session expired. Please log in again.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
        _errorMessage = responseJson['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.clear();
      _user = null;
    } catch (e) {
      debugPrint('Error during logout: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
