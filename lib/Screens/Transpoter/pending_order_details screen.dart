import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';

class PendingOrderDetailsScreen extends StatefulWidget {
  String? orderId;
   PendingOrderDetailsScreen({Key? key,this.orderId}) : super(key: key);

  @override
  State<PendingOrderDetailsScreen> createState() => _PendingOrderDetailsScreenState();
}

class _PendingOrderDetailsScreenState extends State<PendingOrderDetailsScreen> {

  TransportHomeController transportHomeController =
  Get.put(TransportHomeController());
  String? userToken = Constants.prefs?.getString('user_token');

  @override
  Future<void> didChangeDependencies() async {
    if (kDebugMode) {
      print('widget.orderId >> ${widget.orderId}');
      print('userToken >> $userToken');
    }
    await transportHomeController
        .acceptOrderDetailsFun(userToken!, widget.orderId, isLoad: true);
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appThemeColor,
        elevation: 0,
        title: Text('Order Id : ${widget.orderId}',
            style: GoogleFonts.roboto(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
      ),
      body: Obx(()=>
      transportHomeController.isAcceptOrderDetailsLoad.value
          ? Center(
          child: CircularProgressIndicator(
              strokeWidth: 2, color: AppColor.appThemeColor))
          : ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        children: [
          Row(
            children: [
              Text(
                'Status :',
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[400]),
              ),
              const Spacer(),
              Text(
                '${transportHomeController
                    .acceptOrderDetailsFinalData.assignStatus}',
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
            width: 0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Order ID: #KJGFU25499
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Id:',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Text(
                        '${transportHomeController.acceptOrderDetailsFinalData.orderId}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF828282))),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
                width: 0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Address:',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Text(
                        '${transportHomeController.acceptOrderDetailsFinalData.stationData?.address}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF828282))),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
                width: 0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ContactPerson',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Text(
                        '${transportHomeController.acceptOrderDetailsFinalData.stationData?.contactPerson}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282))),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
                width: 0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'StationName',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Text(
                        '${transportHomeController.acceptOrderDetailsFinalData.stationData?.stationName}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282))),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
                width: 0,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
            width: 0,
          ),
          ListView.builder(
              itemCount: transportHomeController
                  .acceptOrderDetailsFinalData
                  .orderData
                  ?.orderDetails
                  ?.length,
              physics: const NeverScrollableScrollPhysics(),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                              '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].name.toString()}',
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
                        children: [
                          Text('Order Date',
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          Text(
                              '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].cartCreated.toString()}',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Qty',
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          Text(
                              '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].qty.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].measurement.toString()}',
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
                        children: [
                          Text('Price',
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          Text(
                              '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].price.toString()}',
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
                        children: [
                          Text('Total_Price',
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                          Text(
                              '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].totalPrice.toString()}',
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.green)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                        width: 0,
                      ),
                    ],
                  ),
                );
              }),
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
          const SizedBox(
            height: 10,
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
          const SizedBox(
            height: 10,
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
          const SizedBox(
            height: 10,
            width: 0,
          ),
          Divider(color: Colors.grey[600],),
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
    );
  }
}
