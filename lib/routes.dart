import 'package:assessmentapp/views/auth/login_screen.dart';
import 'package:assessmentapp/views/product/add_product_screen.dart';
import 'package:assessmentapp/views/product/product_detail_screen.dart';
import 'package:assessmentapp/views/product/product_list_screen.dart';
import 'package:assessmentapp/views/profile/profile_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  AppPages._();
  static const INITIAL = LOGIN;
  static const LOGIN = '/login';
  static const PROFILE = '/profile';
  static const PRODUCTS = '/products';
  static const PRODUCT_DETAIL = '/products/detail';
  static const CREATE_PRODUCT = '/products/create';

  static final routes = [
    GetPage(name: LOGIN, page: () => LoginScreen()),
    GetPage(name: PROFILE, page: () => ProfileScreen()),
    GetPage(name: PRODUCTS, page: () => ProductListScreen()),
    GetPage(name: PRODUCT_DETAIL, page: () => ProductDetailScreen()),
    GetPage(name: CREATE_PRODUCT, page: () => ProductCreateScreen()),
  ];
}
