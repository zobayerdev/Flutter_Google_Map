import 'package:get/get.dart';

import 'location_controller.dart';

class BindingController extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationController());
  }
}
