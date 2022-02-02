import 'package:get/get.dart';

class DashbordController extends GetxController {
  //TODO: Implement DashbordController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
