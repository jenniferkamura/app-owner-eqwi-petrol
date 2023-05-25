// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/reject_reason_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transport_web_services/transport_web_services.dart';

class RejectOrderPopup extends StatefulWidget {
  final String orderId, userToken, assignOrderId;
  const RejectOrderPopup(
      {super.key,
      required this.orderId,
      required this.userToken,
      required this.assignOrderId});

  @override
  State<RejectOrderPopup> createState() => _RejectOrderPopupState();
}

class _RejectOrderPopupState extends State<RejectOrderPopup> {
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());
  String? selectedValue;
  String? userToken = Constants.prefs?.getString('user_token');

  @override
  void initState() {
    getRejectReasonFun(widget.userToken);
    super.initState();
  }

  submit() async {
    if(selectedValue == null){
      Fluttertoast.showToast(
          msg: 'Please select reason',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 12.0);
    }else {
      await transportHomeController.rejectOrderActionFun(
          widget.userToken,
          widget.orderId,
          widget.assignOrderId,
          'Reject',
          selectedValue,
          transportHomeController.rejectDescriptionController.text);
      transportHomeController.transportPickUpOrdersFun(
          userToken!.toString(), 'Pending',
          isLoad: true);
    }

  }

  RejectReasonModel? rejectReasonModel;
  bool isLoadingDropDown = false;

  getRejectReasonFun(String userToken) async {
    setState((){
      isLoadingDropDown = true;
    });
    rejectReasonModel =
    await TransportWebServices().rejectReasonApi(userToken);
    setState((){
      isLoadingDropDown = false;
    });
    return rejectReasonModel;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.5,
            ),
            Container(
              height: 372,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14,
                        ),
                        Text(
                          'Reason for Rejecting',
                          style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColor.blackColor),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/wrong.png',
                            height: 24,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 11, left: 13, right: 15),
                    child: Text(
                      'Lorem ipsum dolor sit amet,consectetur adipiscing elit, sed do eiusmod tempor',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA0A0A7),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Reason',
                          style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 0),
                          height: 48,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Select Reason',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.blackColor),
                                  )),
                                ],
                              ),
                              items: rejectReasonModel?.data
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: Text(
                                          item.title.toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.blackColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: (selectedValue == null) ? null : selectedValue,
                              onChanged: (newValue) {
                                // if (this.mounted)
                                setState(() {
                                  selectedValue = newValue;
                                  if (kDebugMode) {
                                    print('$selectedValue');
                                  }
                                });
                              },
                              icon: isLoadingDropDown?  SizedBox(width:15,height:15,child: CircularProgressIndicator(strokeWidth: 2,color: AppColor.appThemeColor,)):const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 25,
                                color: Colors.black,
                              ),
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                              buttonHeight: 55,
                              buttonPadding:
                                  const EdgeInsets.only(left: 15, right: 0),
                              buttonDecoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFD1D1DC)),
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.whiteColor,
                              ),
                              itemHeight: 40,
                              itemPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              dropdownMaxHeight: 132,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 16),
                    child: Text(
                      'Description',
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 3),
                    child: TextField(
                      controller:
                          transportHomeController.rejectDescriptionController,
                      textAlign: TextAlign.left,
                      maxLines: 5,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Color(0xFFD1D1DC), width: 0.5),
                        ),
                        border: OutlineInputBorder(
                          // focusColor: Colors.white,
                          borderSide:
                              BorderSide(color: Color(0xFFD1D1DC), width: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    width: 0,
                  ),
                  Center(
                    child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.82,
                        child: Obx(
                          () => CommonButton(
                              onTapped: transportHomeController
                                      .isRejectLoad.value
                                  ? null
                                  : submit,
                              buttonTitle: transportHomeController
                                      .isRejectLoad.value
                                  ? SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ))
                                  : Text('SUBMIT')),
                        )),
                  ),
                  /*   GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 29, right: 29),
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.blackColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'SUBMIT'.toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
