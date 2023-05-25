import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_list_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transport_web_services/transport_web_services.dart';

class OrdersController extends GetxController  with GetSingleTickerProviderStateMixin {
  static OrdersController get to => Get.find();
  final RxBool _isLoading = false.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);

  }

  Rx<TransportOrderListModel> ordersData =
      TransportOrderListModel(totalRecordsCount: 0, result: [], pagesCount: 0)
          .obs;
  var isOrdersLoad = false.obs;

  ordersFun(String userToken, orderStatus, {bool isLoad = true}) async {
    if (isLoad) {
      isOrdersLoad(true);
    }
    ordersData.value =
        await TransportWebServices().ordersApi(userToken, orderStatus);
    print("Print stat of lod:$isOrdersLoad");
    isOrdersLoad(false);
  }

  TransportOrderListModel get ordersFinalData => ordersData.value;
  bool get isLoading => _isLoading.value;
}
