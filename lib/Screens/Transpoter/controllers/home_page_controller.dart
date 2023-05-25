import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/adds_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/button_status_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/get_compartments_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_avail_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_home_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_list_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_order_details_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/selected_dates_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transport_web_services/transport_web_services.dart';
import 'package:owner_eqwi_petrol/utility/location_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class TransportHomeController extends GetxController {
  static TransportHomeController get to => Get.find();

  late TextEditingController rejectDescriptionController;
  DateRangePickerController dateRangePickerController = DateRangePickerController();

  String? userTokenC = Constants.prefs?.getString('user_token');

  List dateListData = [];
  List selectedData = [];

  @override
  void onInit() {
    super.onInit();
    rejectDescriptionController = TextEditingController();
    dateRangePickerController = DateRangePickerController();
  }


  @override
  void dispose() {
    dateRangePickerController.dispose();
    super.dispose();
  }



  ///transport available
  Rx<TransporterAvailModel> transportAvail = TransporterAvailModel(
          userId: '',
          loginId: '',
          name: '',
          email: '',
          mobile: '',
          address: '',
          stationId: '',
          latitude: '',
          longitude: '',
          profilePic: '',
          userToken: '',
          userType: '',
          transporterAvailable: false,
          profilePicUrl: '')
      .obs;
  var isAvailLoading = false.obs;

  transportAvailFun(String userToken, String available, String dateTime,{bool isLoad = true}) async {
    try {
      final location = await LocationService.fetchDeviceGPSPosition();
      if (isLoad) {
        isAvailLoading(true);
      }
      transportAvail.value = await TransportWebServices()
          .transporterAvailabilityApi(
              userToken, available, location.latitude, location.longitude,dateTime);
      transportHomeFun(userToken, isLoad: true);
      isAvailLoading(false);
    } catch (e) {
      // final location = await LocationService.fetchDeviceGPSPosition();
      // print('Hello sending data >>>> $userToken ${available.runtimeType} ${location.latitude} ${location.longitude}');
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 12.0);
      isAvailLoading(false);
    }
  }

  TransporterAvailModel get transportAvailSuccessData => transportAvail.value;

  ///transport home
  initStateHomeData(String userToken, {bool isLoad = true}) {
    if (isLoad) {
      transportHomeFun(userToken);
    }
  }

  Rx<TransporterHomeModel> transportHome = TransporterHomeModel(rating: "0").obs;
  var isHomeLoading = false.obs;

  transportHomeFun(String userToken, {bool isLoad = false}) async {
    if (isLoad) {
      isHomeLoading(true);
    }
    transportHome.value =
        await TransportWebServices().transporterHomeApi(userToken);
    isHomeLoading(false);
  }

  TransporterHomeModel get transportHomeSuccessData => transportHome.value;

  /// pickUp orders data
  initStatePickUpOrder(String userToken, orderStatus) {
    transportPickUpOrdersFun(userToken, orderStatus);
  }

  Rx<TransportOrderListModel> pickUpOrders =
      TransportOrderListModel(totalRecordsCount: 0, result: [], pagesCount: 0)
          .obs;
  var isPickOrdersLoad = false.obs;

  transportPickUpOrdersFun(String userToken, orderStatus,
      {bool isLoad = true}) async {
    if (isLoad) {
      isPickOrdersLoad(true);
    }
    pickUpOrders.value =
        await TransportWebServices().pickUpOrdersApi(userToken, orderStatus);
    print("Print stat of lod:$isPickOrdersLoad");
    isPickOrdersLoad(false);
  }

  TransportOrderListModel get pickUpOrdersFinalData => pickUpOrders.value;

  ///current Orders data
  initStateCurrentOrder(String userToken, orderStatus) {
    transportPickUpOrdersFun(userToken, orderStatus);
  }

  Rx<TransportOrderListModel> currentOrders =
      TransportOrderListModel(totalRecordsCount: 0, result: [], pagesCount: 0)
          .obs;
  var isCurrentOrdersLoad = false.obs;
  transportCurrentOrdersFun(String userToken, orderStatus,
      {bool isLoad = true}) async {
    if (isLoad) {
      isCurrentOrdersLoad(true);
    }
    currentOrders.value =
        await TransportWebServices().pickUpOrdersApi(userToken, orderStatus);
    isCurrentOrdersLoad(false);
  }

  TransportOrderListModel get currentOrdersFinalData => currentOrders.value;

  ///transporter action fun
  var isTransActionLoad = false.obs;

  transporterActionFun(String userToken, orderId, assignOrderId, orderStatus,
      reasonTitle, reasonDescription) async {
    isTransActionLoad(true);
    Map<String, dynamic> acceptAction = await TransportWebServices()
        .transporterActionApi(userToken, orderId, assignOrderId, orderStatus,
            reasonTitle, reasonDescription);
    if (acceptAction["status"] == "success") {
      Get.back();
      /* Fluttertoast.showToast(
          msg: forgot["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0
      );*/
      isTransActionLoad(false);
    } else {
      Get.back();
      var error = acceptAction["message"];
       Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0
      );
      isTransActionLoad(false);
    }
  }

  /// reject Order Action
  var isRejectLoad = false.obs;
  rejectOrderActionFun(String userToken, orderId, assignOrderId, orderStatus,
      reasonId, reasonDescription) async {
    isRejectLoad(true);
    Map<String, dynamic> acceptAction = await TransportWebServices()
        .transporterActionApi(userToken, orderId, assignOrderId, orderStatus,
            reasonId, reasonDescription);
    if (acceptAction["status"] == "success") {
      Get.back();
      Get.back();
      isRejectLoad(false);
      rejectDescriptionController.clear();
    } else {
      Get.back();
      isRejectLoad(false);
    }
  }

  /// reject Order Action

  var isReachLoad = false.obs;
  reachOrderActionFun(
      String userToken,
      orderId,
      assignOrderId,
      orderStatus,
      reasonTitle,
      reasonDescription,
      orderDetailsId,
      otp,
      signatureFile) async {
    isReachLoad(true);
    Map<String, dynamic> acceptAction = await TransportWebServices()
        .reachedButtonApi(userToken, orderId, assignOrderId, orderStatus,
            reasonTitle, reasonDescription, orderDetailsId, otp, signatureFile);
    if (acceptAction["status"] == "success") {

      // print('reached doneddd');
      Get.back();
      print('INSIDE');
      acceptOrderDetailsFun(
          userToken.toString(), acceptAction["data"]["order_id"].toString(),
          isLoad: true);
      update();
      isReachLoad(false);
    } else if (acceptAction["status"] == "error") {
      Fluttertoast.showToast(
          msg: acceptAction["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
      isReachLoad(false);
    }
  }

//////// Reach order api
  var isReachorderLoad = false.obs;
  reachButtonOrderActionFun(
      userToken, orderId, assignOrderId, orderStatus) async {

    isReachorderLoad(true);
    Map<String, dynamic> acceptAction = await TransportWebServices()
        .reachedOrderButtonApi(userToken, orderId, assignOrderId, orderStatus);
    if (acceptAction["status"] == "success") {

      acceptOrderDetailsFun(
          userToken.toString(), acceptAction["data"]["order_id"].toString(),
          isLoad: true);
      Get.back();
      //    print('reached fff doneddd');
      isReachorderLoad(false);
    } else if (acceptAction["status"] == "error") {
      Fluttertoast.showToast(
          msg: acceptAction["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
      isReachorderLoad(false);
    }
  }

  /// order details fun
  initStateOrderDetails(String userToken, orderId) {
    acceptOrderDetailsFun(userToken, orderId);
  }



  Rx<TransportOrderDetailsModel> acceptOrderDetails =
      TransportOrderDetailsModel().obs;
  var isAcceptOrderDetailsLoad = false.obs;
  acceptOrderDetailsFun(String userToken, orderId, {isLoad = false}) async {
    print('INSIDE FUN ');
    if (isLoad) {
      isAcceptOrderDetailsLoad(true);
    }

    acceptOrderDetails.value =
        await TransportWebServices().acceptOrderDetails(userToken, orderId);
    isAcceptOrderDetailsLoad(false);

  }

  TransportOrderDetailsModel get acceptOrderDetailsFinalData =>
      acceptOrderDetails.value;

  ///delivery action
  Rx<ButtonStatusModel> deliveryActionDetails = ButtonStatusModel().obs;
  var isDeliveryActionLoad = false.obs;
  deliveryActionFun(
      String userToken,
      orderId,
      assignOrderId,
      orderStatus,
      reasonTitle,
      reasonDescription,
      orderDetailsId,
      otp,
      signatureFile) async {
    print('goint');
    print('userToken');
    print(userToken);
    print(orderId);
    print(assignOrderId);
    print(orderStatus);
    print(signatureFile);
    print(otp);
    isDeliveryActionLoad(true);
    deliveryActionDetails.value = await TransportWebServices()
        .deliveredButtonApi(userToken, orderId, assignOrderId, orderStatus,
            reasonTitle, reasonDescription, orderDetailsId, otp, signatureFile);
    isDeliveryActionLoad(false);
  }

  ButtonStatusModel get finalDeliveryData => deliveryActionDetails.value;

  ///adds
  Rx<AddsModel> addsData = AddsModel(status: '', message: '', data: []).obs;
  var isAddsLoading = false.obs;
  getAddsFun(String userToken) async {
    isAddsLoading(true);
    addsData.value = await TransportWebServices().addsApiCall(userToken);
    isAddsLoading(false);
  }

  AddsModel get addsFinalData => addsData.value;


  ///date based available
  var isDatesAvalbleLoad = false.obs;
  transporterAvailableDateFun(
      String userToken,
      String available,
      List listDate) async {
    Map<String, dynamic> acceptDatesAction = await TransportWebServices()
        .transporterAvailableDateVise(
        userToken,
        available,
        listDate);
    isDatesAvalbleLoad(true);
    if (acceptDatesAction["status"] == "success") {
      // print('***********');
      // print(acceptAction["data"]["order_id"]);
      /// print('***********');
      /* acceptOrderDetailsFun(userTokenC!,acceptAction["data"]["order_id"],isLoad: true);*/
      Fluttertoast.showToast(
          msg: acceptDatesAction["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      Get.offAll(() => const SelectedDatesScreen(),
          duration: const Duration(milliseconds: 400),
          transition: Transition.leftToRight);
      // dateRangePickerController.dispose();
      // dateRangePickerController.selectedDates?.clear();
      // dateRangePickerController.selectedDates = null;
      // dateRangePickerController.selectedDates = [];
      // dateListData = [];
      // dateListData.clear();
      Get.delete<TransportHomeController>();
      // // Get.to(() => TransporterProfileScreen(),
      // //     duration: Duration(milliseconds: 400),
      // //     transition: Transition.rightToLeft);
      // // update();
      // /*  Get.back();
      // Get.back();*/
      isDatesAvalbleLoad(false);
    } else if (acceptDatesAction["status"] == "error") {
      Fluttertoast.showToast(
          msg: acceptDatesAction["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
      // dateRangePickerController.selectedDates?.clear();
      // dateRangePickerController.selectedDates = null;
      // dateRangePickerController.selectedDates = [];
      // dateListData = [];
      // dateListData.clear();
      // dateRangePickerController.dispose();
      Get.delete<TransportHomeController>();
      isDatesAvalbleLoad(false);
    }
  }

  RxString compartmentTextData = ''.obs;
  RxList selectedItems = [].obs;
  Rx<GetCompartmentModel> getCompartment = GetCompartmentModel(status: '',data: [],message: '').obs;
  var isComLoad = false.obs;
  getCompartmentsFun(String userToken) async {
    isComLoad(true);
    getCompartment.value = await TransportWebServices().getCompartmentsApi(userToken);
    isComLoad(false);

  }
  GetCompartmentModel get getCompartmentData => getCompartment.value;

  var addFuelLoad = false.obs;
  addFuelFun(
      String userToken,
      String orderId,
      List compartmentData,String catId) async {
    addFuelLoad(true);
    Get.dialog(const Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 2,),),
      barrierDismissible: false,);
    Get.back();
     await TransportWebServices()
        .addFuelApi(userToken, orderId, compartmentData,catId).then((acceptAction){

       if (acceptAction["status"] == "success") {
         // selectedItems = [].obs;

         addFuelLoad(false);
         //    print('reached fff doneddd');
         Fluttertoast.showToast(
             msg: acceptAction["message"],
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.green,
             textColor: Colors.white,
             fontSize: 12.0);
         acceptOrderDetailsFun(
             userToken.toString(), orderId,
             isLoad: true);
         selectedItems = [].obs;
         Get.back();
       } else if (acceptAction["status"] == "error") {
         Fluttertoast.showToast(
             msg: acceptAction["message"],
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.red,
             textColor: Colors.white,
             fontSize: 12.0);
         addFuelLoad(false);
       }else{
         addFuelLoad(false);
       }
     });
  }

  // ///transport available
  // Rx<TransporterAvailModel> transportAvailDate = TransporterAvailModel(
  //     userId: '',
  //     loginId: '',
  //     name: '',
  //     email: '',
  //     mobile: '',
  //     address: '',
  //     stationId: '',
  //     latitude: '',
  //     longitude: '',
  //     profilePic: '',
  //     userToken: '',
  //     userType: '',
  //     transporterAvailable: '',
  //     profilePicUrl: '')
  //     .obs;
  // var isAvailDateLoadingNew = false.obs;
  //
  // transportAvailDatesFun(String userToken, available,List listData, {bool isLoad = true}) async {
  //   try {
  //     final location = await LocationService.fetchLocationByDeviceGPS();
  //     if (isLoad) {
  //       isAvailDateLoadingNew(true);
  //     }
  //     transportAvailDate.value = await TransportWebServices()
  //         .transporterAvailableDateVise(
  //         userToken, available, location.latitude, location.longitude,listData);
  //     transportHomeFun(userToken, isLoad: true);
  //     isAvailDateLoadingNew(false);
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.toString(),
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 12.0);
  //   }
  // }
  //
  // TransporterAvailModel get transportAvailDateSuccessData => transportAvailDate.value;
}
