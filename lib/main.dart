import 'package:assessmentapp/controllers/product_controller.dart';
import 'package:assessmentapp/controllers/auth_controller.dart';
import 'package:assessmentapp/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  Get.put(AuthController());
  Get.put(ProductController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DummyJSON Flutter App',
      initialRoute: AppPages.LOGIN,
      getPages: AppPages.routes,
    );
  }
}

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final ProductController productListController = Get.put(ProductController());
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = storage.read<String>("token") ?? "";
      final user = productListController.user.value;

      if (token.isNotEmpty && user != null) {
        Get.offNamed(AppPages.PRODUCTS);
      } else {
        Get.offNamed(AppPages.LOGIN);
      }
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
