// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/document_update_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:signature/signature.dart';

// ignore: must_be_immutable
/*class DeliveryConformationPopup extends StatefulWidget {
  String userToken,
      orderId,
      assignOrderId,
      orderStatus,
      reasonTitle,
      reasonDescription,
      orderDetailsId,
      otp,
      signatureFile;

  DeliveryConformationPopup(
      {super.key,
      required this.userToken,
      required this.orderId,
      required this.assignOrderId,
      required this.orderStatus,
      required this.reasonTitle,
      required this.reasonDescription,
      required this.orderDetailsId,
      required this.otp,
      required this.signatureFile});

  @override
  State<DeliveryConformationPopup> createState() =>
      _DeliveryConformationPopupState();
}

class _DeliveryConformationPopupState extends State<DeliveryConformationPopup> {
  DeliveryUpdateController deliveryUpdateController =
      Get.put(DeliveryUpdateController());
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());
  String? currentText = "";

  String? userToken = Constants.prefs?.getString('user_token');



  submitSignature() async {
    final sign = await deliveryUpdateController.controller.toPngBytes();
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(sign!);
    await deliveryUpdateController.signatureUploadFun(
        '$userToken', file, 'Signature');
    print('SIGNATURE');
    print('${deliveryUpdateController.signatureFinalData.image}');
    print('${deliveryUpdateController.signatureFinalData.imagePath}');
    print('SIGNATURE');

    */ /*   dynamic result = await TransportWebServices()
        .uploadAttachmentAndFilesApiCall('$userToken',file,'Signature');
    print('image >>>$result');
    print('image >>>${result['data']['image'].toString()}');*/ /*
  }

  confirmDeliveryOrder() async {
    if (deliveryUpdateController.otpController.text.isEmpty ||
        deliveryUpdateController.otpController.text.length != 4) {
      Fluttertoast.showToast(
          msg: 'otp required',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (deliveryUpdateController.signatureFinalData.image == null) {
      Fluttertoast.showToast(
          msg: 'Signature required',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
    } else {
      //print('$userToken  ${widget.orderId} ${ widget.assignOrderId} ${deliveryUpdateController.otpController?.text} ${deliveryUpdateController.signatureFinalData.image}',);
      await deliveryUpdateController.reachOrderActionFun(
          userToken!,
          widget.orderId,
          widget.assignOrderId,
          'Delivered',
          '',
          '',
          '',
          deliveryUpdateController.otpController.text,
          deliveryUpdateController.signatureFinalData.image);
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.5,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
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
                      color: Color(0xFF89A619),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          'Delivery Confirmation',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.whiteColor),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/wrong.png',
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 11,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      'Enter OTP',
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                  ),
                  Container(
                    width: 200,

                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: PinCodeTextField(
                      enablePinAutofill: false,
                      controller: deliveryUpdateController.otpController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp("[ ]")),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        LengthLimitingTextInputFormatter(4),
                      ],
                      autoDismissKeyboard: true,
                      appContext: context,
                      validator: (v) {
                        if (v.toString().isEmpty || v!.length < 4) {
                          return "Please enter OTP code";
                        } else {
                          return null;
                        }
                      },
                      textStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontFamily: 'MontserratSemiBold'),
                      pastedTextStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        errorBorderColor: Colors.white,
                        borderWidth: 1,
                        selectedColor: AppColor.appThemeColor,
                        selectedFillColor: Colors.white,
                        inactiveColor: Colors.grey,
                        inactiveFillColor: Colors.white,
                        activeColor: Colors.blue,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 40,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        return true;
                      },
                    ),
                  ),
                  */ /*   Container(
                    height: 35,
                    width: 176,
                    margin: EdgeInsets.only(top: 8, left: 29),
                    child: OtpTextField(
                      filled: true,
                      fillColor: AppColor.whiteColor,
                      fieldWidth: 35,
                      autoFocus: false,
                      numberOfFields: 4,
                      borderColor: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      showFieldAsBox: true,
                      borderWidth: 1.0,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Verification Code"),
                                content:
                                    Text('Code entered is $verificationCode'),
                              );
                            });
                      }, // end onSubmit
                    ),
                  ),*/ /*
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 20),
                    child: Text(
                      'Signature',
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                  ),
                  Container(
                    height: 120,
                    margin: EdgeInsets.only(top: 8, left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Signature(
                        controller: deliveryUpdateController.controller,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                deliveryUpdateController.controller.clear();
                              },
                              child: Text(
                                'Clear Signature',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15),
                              )),
                          Obx(
                            () => ElevatedButton(
                              onPressed: deliveryUpdateController
                                      .isSignatureLoading.value
                                  ? () {}
                                  : () => submitSignature(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.appThemeColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  textStyle: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400)),
                              child: Text(deliveryUpdateController
                                      .isSignatureLoading.value
                                  ? 'Please wait..'
                                  : 'Submit Signature'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: deliveryUpdateController.isDelLoad.value
                          ? () {}
                          : () => confirmDeliveryOrder(),
                      */ /* onTap: () async {
                        //conversion
                        */ /* */ /*   final sign = await controller?.toPngBytes();
                        final tempDir = await getTemporaryDirectory();
                        File file = await File('${tempDir.path}/image.png').create();
                        file.writeAsBytesSync(sign!);
                       //
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              scrollable: true,
                                  content: Image.file(file),
                                title: Text('$file'),
                                ));*/ /* */ /*
                      },*/ /*
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.blackColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: deliveryUpdateController.isDelLoad.value
                            ? SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator())
                            : Text(
                                'confirm'.toUpperCase(),
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

class DeliveryConformationPopup extends StatelessWidget {
  String userToken,
      orderId,
      assignOrderId,
      orderStatus,
      reasonTitle,
      reasonDescription,
      orderDetailsId,
      otp,
      signatureFile;

  DeliveryConformationPopup(
      {Key? key,
      required this.userToken,
      required this.orderId,
      required this.assignOrderId,
      required this.orderStatus,
      required this.reasonTitle,
      required this.reasonDescription,
      required this.orderDetailsId,
      required this.otp,
      required this.signatureFile})
      : super(key: key);

  DeliveryUpdateController deliveryUpdateController =
      Get.put(DeliveryUpdateController());
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());
  String? currentText = "";

  // String? userToken = Constants.prefs?.getString('user_token');

  submitSignature() async {
    final sign = await deliveryUpdateController.controller.toPngBytes();
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(sign!);
    await deliveryUpdateController.signatureUploadFun(
        '$userToken', file, 'Signature');
  }

  confirmDeliveryOrder() async {
    print('woo');
    if (deliveryUpdateController.otpController.text.isEmpty ||
        deliveryUpdateController.otpController.text.length != 4) {
      Fluttertoast.showToast(
          msg: 'otp required',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (deliveryUpdateController.controller.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Signature required',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
    } else {
      final sign = await deliveryUpdateController.controller.toPngBytes();
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(sign!);
      await deliveryUpdateController.reachOrderActionFun(
          userToken,
          orderId,
          assignOrderId,
          'Delivered',
          deliveryUpdateController.otpController.text,
          file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<DeliveryUpdateController>(
        initState: (_) => DeliveryUpdateController.to.onInit(),
        init: DeliveryUpdateController(),
        builder: (value) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4.5,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
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
                        color: Color(0xFF89A619),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            'Delivery Confirmation',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.whiteColor),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Image.asset(
                              'assets/images/wrong.png',
                              height: 24,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 11,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        'Enter OTP',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor),
                      ),
                    ),
                    Container(
                      width: 200,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: PinCodeTextField(
                        enablePinAutofill: false,
                        controller: deliveryUpdateController.otpController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.deny(RegExp("[ ]")),
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          LengthLimitingTextInputFormatter(4),
                        ],
                        autoDismissKeyboard: true,
                        appContext: context,
                        validator: (v) {
                          if (v!.isEmpty || v.length < 4) {
                            return "Please enter OTP code";
                          } else {
                            return null;
                          }
                        },
                        textStyle: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'MontserratSemiBold'),
                        pastedTextStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          errorBorderColor: Colors.white,
                          borderWidth: 1,
                          selectedColor: AppColor.appThemeColor,
                          selectedFillColor: Colors.white,
                          inactiveColor: Colors.grey,
                          inactiveFillColor: Colors.white,
                          activeColor: Colors.blue,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        onChanged: (value) {
                          debugPrint(value);
                          currentText = value;
                        },
                        beforeTextPaste: (text) {
                          debugPrint("Allowing to paste $text");
                          return true;
                        },
                      ),
                    ),
                    /*   Container(
                      height: 35,
                      width: 176,
                      margin: EdgeInsets.only(top: 8, left: 29),
                      child: OtpTextField(
                        filled: true,
                        fillColor: AppColor.whiteColor,
                        fieldWidth: 35,
                        autoFocus: false,
                        numberOfFields: 4,
                        borderColor: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        showFieldAsBox: true,
                        borderWidth: 1.0,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Verification Code"),
                                  content:
                                      Text('Code entered is $verificationCode'),
                                );
                              });
                        }, // end onSubmit
                      ),
                    ),*/
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 20),
                      child: Text(
                        'Signature',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor),
                      ),
                    ),
                    Container(
                      height: 120,
                      margin: EdgeInsets.only(top: 8, left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Signature(
                          controller: deliveryUpdateController.controller,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    /*SizedBox(
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  deliveryUpdateController.controller.clear();
                                },
                                child: Text(
                                  'Clear Signature',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                )),
                            Obx(
                              () => ElevatedButton(
                                onPressed: deliveryUpdateController
                                        .isSignatureLoading.value
                                    ? () {}
                                    : () => submitSignature(),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.appThemeColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    textStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                                child: Text(deliveryUpdateController
                                        .isSignatureLoading.value
                                    ? 'Please wait..'
                                    : 'Submit Signature'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    SizedBox(height: 10,width:0),
                    Obx(
                      () => deliveryUpdateController.isDelLoad.value
                          ? Align(
                        alignment: Alignment.center,
                            child: SizedBox(
                               width: MediaQuery.of(context).size.width * 0.8,
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                            ),
                          )
                          : Align(
                        alignment: Alignment.center,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: confirmDeliveryOrder,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  child: Text('confirm'.toUpperCase()),
                                ),
                            ),
                          ),
                    ),
                    // Obx(
                    //   () => GestureDetector(
                    //     onTap: deliveryUpdateController.isDelLoad.value
                    //         ? () {}
                    //         : () => confirmDeliveryOrder(),
                    //     /* onTap: () async {
                    //       //conversion
                    //       */ /*   final sign = await controller?.toPngBytes();
                    //       final tempDir = await getTemporaryDirectory();
                    //       File file = await File('${tempDir.path}/image.png').create();
                    //       file.writeAsBytesSync(sign!);
                    //      //
                    //       showDialog(
                    //             context: context,
                    //             builder: (_) => AlertDialog(
                    //               scrollable: true,
                    //                   content: Image.file(file),
                    //                 title: Text('$file'),
                    //                 ));*/ /*
                    //     },*/
                    //     child: Container(
                    //       margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    //       height: 48,
                    //       alignment: Alignment.center,
                    //       decoration: BoxDecoration(
                    //         color: /*(deliveryUpdateController
                    //                     .otpController.text.isEmpty ||
                    //                 deliveryUpdateController
                    //                         .otpController.text.length !=
                    //                     4 || deliveryUpdateController.controller.isEmpty)
                    //             ? Colors.grey[500]
                    //             :*/
                    //             AppColor.blackColor,
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: deliveryUpdateController.isDelLoad.value
                    //           ? SizedBox(
                    //               height: 15,
                    //               width: 15,
                    //               child: CircularProgressIndicator())
                    //           : Text(
                    //               'confirm'.toUpperCase(),
                    //               style: GoogleFonts.roboto(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.white),
                    //             ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
