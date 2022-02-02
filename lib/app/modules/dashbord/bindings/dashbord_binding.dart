import 'package:get/get.dart';

import '../controllers/dashbord_controller.dart';

class DashbordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashbordController>(
      () => DashbordController(),
    );
  }
}
