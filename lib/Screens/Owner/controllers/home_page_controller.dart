import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/models/owner_current_order_model.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/web_services_owner/owner_web_services.dart';

class OwnerHomeScreenController extends GetxController{
  static OwnerHomeScreenController get to => Get.find();


  var currentOrderData = <OwnerCurrentOrdersModel>[].obs;
  var isCurrentOrderLoading = false.obs;
  ownerHomeScreenFun( String userToken) async {
    isCurrentOrderLoading(true);
    currentOrderData.value = await WebServices().ownerCurrentOrdersApi(userToken);
    isCurrentOrderLoading(false);
  }

  RxList<OwnerCurrentOrdersModel> get currentOrderFinalData => currentOrderData;
}