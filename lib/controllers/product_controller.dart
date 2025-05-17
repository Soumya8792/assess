import 'dart:convert';

import 'package:assessmentapp/core/constants.dart';
import 'package:assessmentapp/models/user_model.dart';
import 'package:assessmentapp/routes.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  var products = [].obs;
  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    loadUserFromStorage().then((_) {
      fetchUserProfile();
    });
  }

  Future<void> loadUserFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');

    if (userData != null) {
      user.value = UserModel.fromJson(jsonDecode(userData));
    }
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    final response = await http.get(Uri.parse("$baseUrl/products"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      products.value = data['products'];
    } else {
      Get.snackbar("Error", "Failed to load products");
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> fetchProduct(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/products/$id"));
    return jsonDecode(response.body);
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/products/$id"));
    if (response.statusCode == 200) {
      products.removeWhere((element) => element['id'] == id);
      Get.back();
    } else {
      Get.snackbar("Error", "Delete failed");
    }
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar('Error', 'No token found');
        return;
      }

      var response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        user.value = UserModel.fromJson(jsonResponse);

        await prefs.setString('userData', jsonEncode(user.value!.toJson()));
      } else {
        Get.snackbar('Failed', 'Could not fetch user profile');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(String title, String price) async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse("https://dummyjson.com/products/add"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"title": title, "price": int.tryParse(price) ?? 0}),
    );

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("Success", "Product added successfully!");
      await fetchProducts();
      Get.offAllNamed(AppPages.PRODUCTS);
    } else {
      Get.snackbar("Error", "Failed to add product");
    }
  }
}
