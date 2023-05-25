// ignore_for_file: prefer_const_constructors

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/reject_order_poupup.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_accept_order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_screen.dart';

// ignore: must_be_immutable
class TransportViewOrderDetailScreen extends StatefulWidget {
  String? orderId;

  TransportViewOrderDetailScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<TransportViewOrderDetailScreen> createState() =>
      _TransportViewOrderDetailScreenState();
}

class _TransportViewOrderDetailScreenState
    extends State<TransportViewOrderDetailScreen> {
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());
  String? userToken = Constants.prefs?.getString('user_token');

/*  @override
  void initState() {
    if (kDebugMode) {
      print('widget.orderId >> ${widget.orderId}');
      print('userToken >> $userToken');
    }
    transportHomeController.acceptOrderDetailsFun(userToken!, widget.orderId,
        isLoad: true);

    super.initState();
  }*/

  @override
  Future<void> didChangeDependencies() async {
    await transportHomeController
        .acceptOrderDetailsFun(userToken!, widget.orderId, isLoad: true);
    super.didChangeDependencies();
  }

  /* @override
  Future <void> didChangeDependencies()async {
    if (kDebugMode) {
      print('widget.orderId >> ${widget.orderId}');
      print('userToken >> $userToken');
      print('orderDetails L>> ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?.length}');

    }
    await transportHomeController.acceptOrderDetailsFun(userToken!, widget.orderId);
    super.didChangeDependencies();
  }*/

  acceptOrderSubmit() async {
    await transportHomeController.transporterActionFun(
        userToken!,
        transportHomeController.acceptOrderDetailsFinalData.orderId.toString(),
        transportHomeController.acceptOrderDetailsFinalData.id.toString(),
        'Accept',
        '',
        '');
    transportHomeController.transportPickUpOrdersFun(
        userToken!.toString(), 'Pending',
        isLoad: true);
    transportHomeController.transportCurrentOrdersFun(
        userToken!.toString(), 'Accept',
        isLoad: true);
  }

  int serviceTimeStamp = DateTime.now().millisecondsSinceEpoch;

  Future<bool> _willPopCallback() async {

    await transportHomeController.transportPickUpOrdersFun(
        userToken.toString(), 'Pending',
        isLoad: true);
    await transportHomeController.transportCurrentOrdersFun(
        userToken.toString(), 'Accept',
        isLoad: true);
    await transportHomeController.transportHomeFun(userToken.toString());
    // await showDialog or Show add banners or whatever
    // then
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
          _willPopCallback();
          Get.back();
        }, title: 'PickUp Order Details'),
        /* floatingActionButton: Obx(
          () => Row(
            children: [
              SizedBox(
                  height: 32,
                  child: CommonIconButton(
                      tapIconButton: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return RejectOrderPopup(
                                orderId: transportHomeController
                                    .acceptOrderDetailsFinalData.orderId
                                    .toString(),
                                userToken: userToken.toString(),
                                assignOrderId: transportHomeController
                                    .acceptOrderDetailsFinalData.id
                                    .toString(),
                              );
                            });
                      },
                      buttonColor: AppColor.blackColor,
                      buttonText: transportHomeController.isRejectLoad.value
                          ? 'Please wait'
                          : 'Reject Order',
                      iconDataD: Icons.cancel_outlined,
                      textColorData: Colors.white)),
              SizedBox(
                  height: 32,
                  child: CommonIconButton(
                      tapIconButton:
                          transportHomeController.isTransActionLoad.value
                              ? () {}
                              : () => acceptOrderSubmit(),
                      buttonColor: AppColor.appThemeColor,
                      buttonText:
                          transportHomeController.isTransActionLoad.value
                              ? 'Please wail'
                              : 'Accept Order',
                      iconDataD: Icons.keyboard_double_arrow_right,
                      textColorData: Colors.white)),
            ],
          ),
        ),*/
        floatingActionButton: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.appThemeColor,
          ),
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.blackColor,
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return RejectOrderPopup(
                                    orderId: transportHomeController
                                        .acceptOrderDetailsFinalData.orderId
                                        .toString(),
                                    userToken: userToken.toString(),
                                    assignOrderId: transportHomeController
                                        .acceptOrderDetailsFinalData.id
                                        .toString(),
                                  );
                                });
                          },
                          child: Text(
                            'Reject Order',
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ))),
                Expanded(
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.appThemeColor,
                        ),
                        child: transportHomeController.isTransActionLoad.value
                            ? Center(
                                child: Text(
                                  'Please wait..',
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              )
                            : TextButton(
                                onPressed: () => acceptOrderSubmit(),
                                child: Text(
                                  'Accept Order',
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ))),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Obx(
          () {
            DateTime internetTime = DateTime.now();
            var date =
                DateTime.fromMillisecondsSinceEpoch(serviceTimeStamp * 1000);
            return transportHomeController.isAcceptOrderDetailsLoad.value
                ? Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColor.appThemeColor))
                : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    physics: BouncingScrollPhysics(),
                    children: [
                      (transportHomeController.acceptOrderDetailsFinalData
                                  .orderData?.todayDelivery
                                  .toString() ==
                              '1')
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Delivery Type :',
                                  style: TextStyle(fontSize: 12.0, color: Colors.black,fontWeight: FontWeight.bold)),
                              BlinkText(
                              'Delivery Now',
                              style: TextStyle(fontSize: 12.0, color: Colors.red,fontWeight: FontWeight.bold),
                              beginColor: Colors.red,
                              endColor: Colors.yellow,
                              duration: Duration(milliseconds: 700)
                      ),
                            ],
                          )
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Text('Delivery Type :',
                                  style: TextStyle(fontSize: 11.0, color: Colors.black,fontWeight: FontWeight.bold)),
                              Text('Scheduled Order Date :${transportHomeController.acceptOrderDetailsFinalData
                                  .orderData?.deliveryDate
                                  .toString()}',
                                  style: TextStyle(fontSize: 11.0, color: Colors.blue[900],fontWeight: FontWeight.bold)),
                            ],
                          ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text('Pick Up',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          SizedBox(
                            width: 10,
                            height: 0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await MapLauncher.showMarker(
                                mapType: MapType.google,
                                coords: Coords(
                                    double.parse(
                                        '${transportHomeController.acceptOrderDetailsFinalData.orderData?.latitude.toString()}'),
                                    double.parse(
                                        '${transportHomeController.acceptOrderDetailsFinalData.orderData?.longitude.toString()}')),
                                title:
                                    '${transportHomeController.acceptOrderDetailsFinalData.orderData?.address.toString()}',
                              );
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => TransporterNavigationMapScreen(),
                              // ));
                            },
                            child: Container(
                              height: 26,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color:
                                      const Color(0xFF000000).withOpacity(0.25),
                                  offset: const Offset(0, 4),
                                ),
                              ], borderRadius: BorderRadius.circular(10)),
                              child: Image.asset(
                                '${StringConstatnts.assets}Transpoter/pickup.png',
                                height: 26,
                              ),
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text('OrderID',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                              Text(
                                  '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderId}',
                                  style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                        width: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PickUp Address',
                                    style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                Text(
                                    '${transportHomeController.acceptOrderDetailsFinalData.vendorData?.address}',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF828282))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Delivery Address',
                                    style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                Text(
                                    '${transportHomeController.acceptOrderDetailsFinalData.stationData?.address}',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF828282)),textAlign: TextAlign.end,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                        width: 0,
                      ),
                      SizedBox(
                        height: 3,
                        width: 0,
                      ),
                      Text('PickUp Order Details :',
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      SizedBox(
                        height: 3,
                        width: 0,
                      ),
                      ListView.builder(
                          itemCount: transportHomeController
                              .acceptOrderDetailsFinalData
                              .orderData
                              ?.orderDetails
                              ?.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          clipBehavior: Clip.hardEdge,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColor.appThemeColor, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Product',
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                      Text(
                                          '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails![index].name.toString()}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF828282))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                    width: 0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Order Date',
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                      Text(
                                          '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails![index].cartCreated.toString()}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF828282))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                    width: 0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Product Qty',
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                      Text(
                                          '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails![index].qty.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails![index].measurement.toString()}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF828282))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                    width: 0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Price',
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                      Text(
                                          '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails![index].currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails![index].price.toString()}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF828282))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                    width: 0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Total_Price',
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                      Text(
                                          '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails![index].currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails![index].totalPrice.toString()}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF828282))),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColor.appThemeColor, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Amount',
                                    style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                Text(
                                    '${transportHomeController.acceptOrderDetailsFinalData.orderData?.currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.amount.toString()}',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF828282))),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                              width: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tax',
                                    style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                Text(
                                    '${transportHomeController.acceptOrderDetailsFinalData.orderData?.currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.tax.toString()}',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF828282))),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                              width: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Charge',
                                    style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                Text(
                                    '${transportHomeController.acceptOrderDetailsFinalData.orderData?.currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.shippingCharge.toString()}',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF828282))),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                              width: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Amount',
                                    style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                Text(
                                    '${transportHomeController.acceptOrderDetailsFinalData.orderData?.currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.totalAmount.toString()}',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.green)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 0,
                      ),
                    ],
                  );
          },
        ),
        /* body: ListView(
            shrinkWrap: true,
            children: [
             */ /* Container(
                height: 76,
                color: AppColor.appThemeColor,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        name == 'Delivered'
                            ? 'Delivered'
                            : 'Delivery - Order Details',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColor.whiteColor),
                      ),
                      Spacer(),
                      if (name != 'Delivered')
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  TransporterNavigationMapScreen(),
                            ));
                          },
                          child: Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(24 / 2),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColor.blackColor.withOpacity(0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 4),
                              ],
                            ), //#
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                  '${StringConstatnts.assets}navigate.png'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),*/ /*
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (name == 'Delivered')
                          Text(
                            'Status:  ',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF828282)),
                          ),
                        if (name == 'Delivered')
                          SizedBox(
                            height: 24,
                          ),
                        Text(
                          'Order ID:',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Order Date:',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Product:',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Who Order:',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Payment:',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Delivery 1 Address:',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Product Qty:',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (name == 'Delivered')
                          Text(
                            'Delivered',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF89A619)),
                          ),
                        if (name == 'Delivered')
                          SizedBox(
                            height: 24,
                          ),
                        Text(
                          '#ZXCFG1239',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          '23/02/2022',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Petrol',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Thomsan',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Cash on delivery',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'H-365, Shell Perol, Nairobi,\nKenya, 456781',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '1000 Ltr',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                height: 8,
                color: Color(0xFFF3F3F3),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 24),
                child: Row(
                  children: [
                    Text(
                      'Amount:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                    SizedBox(
                      width: 108,
                    ),
                    Text(
                      '\$1,000',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 24),
                child: Row(
                  children: [
                    Text(
                      'Tax:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                    SizedBox(
                      width: 135,
                    ),
                    Text(
                      '\$8.50',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 24),
                child: Row(
                  children: [
                    Text(
                      'Delivery Charge:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                    SizedBox(
                      width: 61,
                    ),
                    Text(
                      '\$10',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                height: 1,
                color: Color(0xFFC4C4C4),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 24),
                child: Row(
                  children: [
                    Text(
                      'Total:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                    SizedBox(
                      width: 126,
                    ),
                    Text(
                      '\$1,018.19',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 34,
              ),

            */ /*  if (name != 'Delivered')
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.appThemeColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '${StringConstatnts.assets}Transpoter/call_black.png',
                              height: 20,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Call',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DeliveryConformationPopup();
                              });
                        },
                        child: Container(
                          height: 32,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.appThemeColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Delivered',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 32,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.blackColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '${StringConstatnts.assets}Transpoter/chat.png',
                              height: 20,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Chat',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),*/ /*
            ],
          ),*/
      ),
    );
  }
}
