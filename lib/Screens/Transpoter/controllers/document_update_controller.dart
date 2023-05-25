import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/signature_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_order_details_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transport_web_services/transport_web_services.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_screen.dart';
import 'package:signature/signature.dart';

class DeliveryUpdateController extends GetxController{
  static DeliveryUpdateController get to => Get.find();
  SignatureController controller = SignatureController();
  TextEditingController otpController = TextEditingController();
  String? userTokenC = Constants.prefs?.getString('user_token');



  @override
  void onInit() {
    super.onInit();
    controller = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
    );
    otpController = TextEditingController();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   otpController.dispose();
  // }

  ///signature upload
  Rx<SignatureModel> signatureUpload = SignatureModel().obs;
  var isSignatureLoading = false.obs;
  signatureUploadFun(String userToken,File file,String documentType) async {
      isSignatureLoading(true);
    signatureUpload.value =
    await TransportWebServices().signatureSubmitApi(userToken,file,documentType);
    isSignatureLoading(false);
  }
  SignatureModel get signatureFinalData => signatureUpload.value;


  /// order details fun
  initStateOrderDetails(String userToken, orderId) {
    acceptOrderDetailsFun(userToken, orderId);
  }
  Rx<TransportOrderDetailsModel> acceptOrderDetails =
      TransportOrderDetailsModel()
          .obs;
  var isAcceptOrderDetailsLoad = false.obs;
  acceptOrderDetailsFun(String userToken, orderId,{isLoad = true}) async {
    if(isLoad){
      isAcceptOrderDetailsLoad(true);
    }

    acceptOrderDetails.value =
    await TransportWebServices().acceptOrderDetails(userToken, orderId);
    isAcceptOrderDetailsLoad(false);
  }
  TransportOrderDetailsModel get acceptOrderDetailsFinalData => acceptOrderDetails.value;


  var isDelLoad = false.obs;
  reachOrderActionFun(String userToken, String orderId,
      String assignOrderId, String orderStatus,String otp, File file) async {
    isDelLoad(true);
    Map<String, dynamic> acceptAction = await TransportWebServices()
        .dell( userToken, orderId, assignOrderId, orderStatus, otp, file);
    if (acceptAction["status"] == "success") {
     // print('***********');
     // print(acceptAction["data"]["order_id"]);
     /// print('***********');
     /* acceptOrderDetailsFun(userTokenC!,acceptAction["data"]["order_id"],isLoad: true);*/
      Fluttertoast.showToast(
          msg: '${acceptAction["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      isDelLoad(false);
      initStateOrderDetails(userTokenC!,acceptAction["data"]["order_id"]);
      update();
    /*  Get.back();
      Get.back();*/
     Get.offAll(()=>TransporterHomeScreen(),duration: const Duration(milliseconds: 400),transition: Transition.rightToLeft);
      otpController.clear();
      controller.clear();
    } else if(acceptAction["status"] == "error"){
      Fluttertoast.showToast(
          msg: '${acceptAction["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
      otpController.clear();
      isDelLoad(false);
    }else{
      isDelLoad(false);
    }
  }
}