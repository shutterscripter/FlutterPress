import 'dart:ffi';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/app/auth/login_screen.dart';
import 'package:news_app/screen/bottom_nav_home_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/constants/api_constants.dart';
import 'package:news_app/components/custom_snackbar.dart';

class AuthController extends GetxController {
  static const String _tokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _isLogin = 'is_login';

  // Get token from SharedPreferences
  Future<String?> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Get token type from SharedPreferences
  Future<String?> getTokenType() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenTypeKey);
    } catch (e) {
      print('Error getting token type: $e');
      return null;
    }
  }

  Future<bool?> getLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLogin);
    } catch (e) {
      print('Error getting login state: $e');
      return false;
    }
  }

  // Clear token from SharedPreferences
  Future<void> clearToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('Token cleared successfully');
    } catch (e) {
      print('Error clearing token: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Get authorization header for API requests
  Future<Map<String, String>> getAuthHeaders() async {
    String? token = await getToken();
    String? tokenType = await getTokenType();

    if (token != null && tokenType != null) {
      return {
        'Authorization': '$tokenType $token',
        'Content-Type': 'application/json',
      };
    }

    return {'Content-Type': 'application/json'};
  }

  // Logout user
  Future<void> logout() async {
    await clearToken();
    CustomSnackBar.showInfo(
        context: Get.context!, message: 'Logged out successfully');
    Get.to(() => LoginScreen(), transition: Transition.native);
  }

  Future<void> registerUser(
      {required String email, required String pass}) async {
    try {
      // Show loading snackbar
      CustomSnackBar.showLoading(
          context: Get.context!, message: 'Creating account...');

      var url = Uri.parse(ApiConstants.register);
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': pass,
        }),
      );

      // Hide loading snackbar
      CustomSnackBar.hideCurrent(Get.context!);

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackBar.showSuccess(
            context: Get.context!, message: 'Account created successfully!');
        // Handle successful registration - navigate to login or home
      } else {
        if (response.statusCode == 400) {
          CustomSnackBar.showError(
              context: Get.context!,
              message: 'Email Already Registered! Try again.');
        }
      }
    } catch (e) {
      CustomSnackBar.hideCurrent(Get.context!);
      CustomSnackBar.showError(
          context: Get.context!, message: 'Network error: $e');
    }
  }

  Future<void> loginUser({required String email, required String pass}) async {
    try {
      // Show loading snackbar
      CustomSnackBar.showLoading(
          context: Get.context!, message: 'Signing in...');

      var url = Uri.parse(ApiConstants.login);
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email,
          'password': pass,
        },
      );

      // Hide loading snackbar
      CustomSnackBar.hideCurrent(Get.context!);

      if (response.statusCode == 200) {
        try {
          // Parse the JSON response
          Map<String, dynamic> responseData = jsonDecode(response.body);

          // Extract token and token type
          String? accessToken = responseData['access_token'];
          String? tokenType = responseData['token_type'];

          if (accessToken != null && tokenType != null) {
            // Save token to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(_tokenKey, accessToken);
            await prefs.setString(_tokenTypeKey, tokenType);
            await prefs.setBool(_isLogin, true);

            CustomSnackBar.showSuccess(
                context: Get.context!, message: 'Login successful!');

            Get.offAll(
              () => const BottomNavHomeScreen(),
              transition: Transition.native,
            );
          } else {
            CustomSnackBar.showError(
                context: Get.context!, message: 'Invalid response format');
          }
        } catch (parseError) {
          CustomSnackBar.showError(
              context: Get.context!,
              message: 'Error parsing response: $parseError');
        }
      } else {
        CustomSnackBar.showError(
            context: Get.context!, message: 'Login failed: ${response.body}');
      }
    } catch (e) {
      CustomSnackBar.hideCurrent(Get.context!);
      CustomSnackBar.showError(
          context: Get.context!, message: 'Network error: $e');
    }
  }
}
