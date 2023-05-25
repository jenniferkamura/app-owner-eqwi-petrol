import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'network_controller.dart';

class NetworkBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<NetworkController>(
      () => NetworkController(),
    );
  }
}
