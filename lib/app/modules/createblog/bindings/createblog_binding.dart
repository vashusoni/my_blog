import 'package:get/get.dart';

import '../controllers/createblog_controller.dart';

class CreateblogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateblogController>(
      () => CreateblogController(),
    );
  }
}
