// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/delivery_conformation_popup.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_navigation_map_screen.dart';

class TranspoterDeliveredScreen extends StatelessWidget {
  String? name;
  TranspoterDeliveredScreen({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 50,
        backgroundColor: AppColor.appThemeColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Delivery - Order Details',
          style:
          CustomTextWhiteStyle.textStyleWhite(context, 18, FontWeight.w600),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TransporterNavigationMapScreen(),
              ));
            },
            child: Container(
              height: 22,
              margin: EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColor.blackColor.withOpacity(0.25),
                      offset: Offset(0, 4),
                      blurRadius: 4),
                ],
              ),
              //#
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('${StringConstatnts.assets}navigate.png'),
              ),
            ),
          ),
          SizedBox(
            width: 10,
            height: 0,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Order ID:',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),

                      Text(
                        'Order Date',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),
                      Text(
                        'Product',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),
                      Text(
                        'Who Order',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),
                      Text(
                        'Payment',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),
                      Text(
                        'Delivery 1 Address',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
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
                 SizedBox(width: 100,height: 0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '#ZXCFG1239',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        Text(
                          '23/02/2022',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        Text(
                          'Petrol',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        Text(
                          'Thomsan',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        Text(
                          'Cash on Delivery',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF828282)),
                        ),
                        Flexible(
                          child: Text(
                            'H-365,shell perol,Nairobi,Kenya,456781',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF828282)),
                          ),
                        ),
                        Text(
                          '1000 Lrt',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[200],height: 8,thickness: 8,),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount:',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),
                      Text(
                        'Tax',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),
                      Text(
                        'Delivery Charge:',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '₹ 1000',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      Text(
                        '₹ 8.50',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF828282)),
                      ),
                      Text(
                        '₹ 10',
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
            Divider(color: Colors.grey[200],height: 8,thickness: 1,),
            SizedBox(height: 10,width: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                  ],
                ),
                SizedBox(height: 10,width: 0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹ 1,018.19',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,width: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 32,
                  width: 100,
                  child: CommonIconButton(
                      tapIconButton: (){},
                      buttonColor:  AppColor.appThemeColor,
                      buttonText: 'Call',
                      iconDataD: Icons.call,
                      textColorData: Colors.white),
                ),
                SizedBox(
                  height: 32,
                  width: 110,
                  child: CommonIconButton(
                      tapIconButton: (){},
                      buttonColor:  AppColor.appThemeColor,
                      buttonText: 'Delivered',
                      iconDataD: Icons.delivery_dining_outlined,
                      textColorData: Colors.white),
                ),
                SizedBox(
                  height: 32,
                  width: 100,
                  child: CommonIconButton(
                      tapIconButton: (){},
                      buttonColor: AppColor.blackColor,
                      buttonText: 'Chat',
                      iconDataD: Icons.chat_outlined,
                      textColorData: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
