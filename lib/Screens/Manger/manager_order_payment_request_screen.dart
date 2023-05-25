// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/confirmation_popup.dart';
import 'package:owner_eqwi_petrol/Popup/delivery_type_popup.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_payment_screen.dart';

class ManagerOrderPaymentRequstScreen extends StatefulWidget {
  String name;
  String? accountName;

  ManagerOrderPaymentRequstScreen(
      {super.key, required this.name, this.accountName});

  @override
  State<ManagerOrderPaymentRequstScreen> createState() =>
      _ManagerOrderPaymentRequstScreenState();
}

class _ManagerOrderPaymentRequstScreenState
    extends State<ManagerOrderPaymentRequstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                        child:
                            Image.asset('${StringConstatnts.assets}back.png'),
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
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 24),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.name == 'Write A Review'
                    ? Color(0xFFDDDDDD)
                    : Color(0xFFB8D44C),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 18, top: 16, left: 16, right: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF929292)),
                          ),
                          Text(
                            'QZXD89745',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Requested By',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF929292)),
                          ),
                          Text(
                            'Lexo Station Ngong road',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Requested Date',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF929292)),
                          ),
                          Text(
                            '08/02/2022',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Requested Quantity',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF929292)),
                          ),
                          Text(
                            '1000 Ltr',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF929292)),
                          ),
                          Text(
                            'Petrol (Pms)',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Shipped To',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF929292)),
                          ),
                          Text(
                            'Nairobi',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 24),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFB8D44C),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.only(
                bottom: 18,
                top: 16,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Text(
                          'Total MRP',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF8F8F8F)),
                        ),
                        Spacer(),
                        Text(
                          '\$1,000',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF212121)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Text(
                          'Shipping Charges',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF8A8A8A)),
                        ),
                        Spacer(),
                        Text(
                          '\$12',
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF212121)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Text(
                          'Tax',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF8F8F8F)),
                        ),
                        Spacer(),
                        Text(
                          '\$05',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF212121)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: 1,
                    color: widget.name == 'Write A Review'
                        ? Color(0xFFDDDDDD)
                        : Color(0xFFB8D44C),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 11),
                    child: Row(
                      children: [
                        Text(
                          'Final Payable',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor),
                        ),
                        Spacer(),
                        Text(
                          '\$1,017',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationPopup(
                      name: 'Manager',
                    );
                  });
            },
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 100),
              alignment: Alignment.center,
              height: 48,
              decoration: BoxDecoration(
                color: AppColor.blackColor,
                borderRadius: BorderRadius.circular(48 / 2),
              ),
              child: Text(
                'Raise order'.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
