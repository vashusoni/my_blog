import 'package:get/get.dart';

import '../modules/Authentication/bindings/authentication_binding.dart';
import '../modules/Authentication/views/authentication_view.dart';
import '../modules/createblog/bindings/createblog_binding.dart';
import '../modules/createblog/views/createblog_view.dart';
import '../modules/dashbord/bindings/dashbord_binding.dart';
import '../modules/dashbord/views/dashbord_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTHENTICATION;

  static final routes = [
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.DASHBORD,
      page: () => DashbordView(),
      binding: DashbordBinding(),
    ),
    GetPage(
      name: _Paths.CREATEBLOG,
      page: () => CreateblogView(),
      binding: CreateblogBinding(),
    ),
  ];
}
