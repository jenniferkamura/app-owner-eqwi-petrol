// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/processing_order_detail_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';

class OrderPaymentRequestScreen extends StatefulWidget {
  final orderNo;
  final order_id;
  const OrderPaymentRequestScreen({Key? key, this.orderNo, this.order_id})
      : super(key: key);

  @override
  State<OrderPaymentRequestScreen> createState() =>
      _OrderPaymentRequestScreenState();
}

class _OrderPaymentRequestScreenState extends State<OrderPaymentRequestScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    // Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
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
                            padding: const EdgeInsets.all(0),
                            child: Image.asset(
                                '${StringConstatnts.assets}back.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Order Payment Request',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor),
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                '${StringConstatnts.assets}congratulation.png',
                height: 88,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Congratulations.\nYour Payment Successfully Done.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColor.appThemeColor),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Your Order ID is : ' + widget.orderNo,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8F8F8F)),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'KINDLY TRACK YOUR ORDER FROM ORDERS\nSECTION',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8F8F8F)),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProcessingOrderDetailScreen(
                        order_id: widget.order_id.toString()),
                  ));
                },
                child: Container(
                  height: 40,
                  width: 161,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Track order',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8F8F8F)),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
