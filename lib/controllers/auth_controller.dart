import 'dart:convert';

import 'package:assessmentapp/core/constants.dart';
import 'package:assessmentapp/models/login_model.dart';
import 'package:assessmentapp/models/user_model.dart';
import 'package:assessmentapp/routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<LoginModel>();

  Future<void> login(String username, String password) async {
    isLoading.value = true;

    try {
      var url = Uri.parse('$baseUrl/auth/login');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username.trim(), 'password': password.trim()}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        LoginModel loginModel = LoginModel.fromJson(jsonResponse);

        if (loginModel.accessToken != null && loginModel.refreshToken != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('userData', jsonEncode(loginModel.toJson()));

          await prefs.setString('accessToken', loginModel.accessToken!);
          await prefs.setString('refreshToken', loginModel.refreshToken!);

          user.value = loginModel;

          Get.offAllNamed(AppPages.PRODUCTS);
        } else {
          Get.snackbar('Login Failed', 'Token not received');
        }
      } else {
        Get.snackbar('Login Failed', 'Invalid username or password');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userData');

    user.value = null;
    Get.offAllNamed(AppPages.LOGIN);
  }

  Future<void> loadUserFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      Map<String, dynamic> userMap = jsonDecode(userDataString);
      user.value = LoginModel.fromJson(userMap);
    }
  }
}
