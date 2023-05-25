import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/contact_us_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/help_and_rais_ticket.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/help_and_support_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transport_web_services/transport_web_services.dart';

class DrawerDataController extends GetxController  {
  static DrawerDataController get to => Get.find();

  TextEditingController helpController = TextEditingController();





  @override
  void onInit() {
    super.onInit();
    helpController = TextEditingController();
  }


  Rx<ContactUsModel> contactUsData =
      ContactUsModel()
          .obs;
  var contactUsLoad = false.obs;
  contactUsFun() async {
    contactUsLoad(true);
    contactUsData.value =
    await TransportWebServices().contactUsApi();
    contactUsLoad(false);
  }
  ContactUsModel get contactUsFinalData => contactUsData.value;

  Rx<RaiseTicketModel> raiseTicketData =
      RaiseTicketModel(status: '', message: '', data: '')
          .obs;
  var raiseTicketLoading = false.obs;
  raiseTicketFun(String userToken,String queryDetails ) async {
    raiseTicketLoading(true);
    raiseTicketData.value = await TransportWebServices().raiseTicketApi(userToken, queryDetails);
    raiseTicketLoading(false);
  }
  RaiseTicketModel get raiseTicketFinalData => raiseTicketData.value;

  initStateHelpQData(String userToken,String queryDetails, {bool isLoad = true}) {
    if(isLoad){
      helpAndSupportFun(userToken,queryDetails);
    }
  }
  Rx<HelpAndSupportModel> helpAndSupportQData =
      HelpAndSupportModel(status: '', message: '', data: [])
          .obs;
  var helpAndSupportLoad = false.obs;
  helpAndSupportFun(String userToken,String queryDetails ) async {
    helpAndSupportLoad(true);
    helpAndSupportQData.value = await TransportWebServices().heliAndSupportQApi(userToken,queryDetails);
    helpAndSupportLoad(false);
  }
  HelpAndSupportModel get helpAndSupportQFinalData => helpAndSupportQData.value;
}