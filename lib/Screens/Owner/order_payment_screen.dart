// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_new_card_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_payment_request_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/payment_scussefully_screen.dart';

class OrderPaymentScreen extends StatefulWidget {
  String? name;
  OrderPaymentScreen({Key? key, this.name}) : super(key: key);

  @override
  State<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  int _selectIndex = 0;
  List<String> payment = ['Bank Transfer', 'Card Payment', 'Wallet / UPI'];
  List<String> paymentImage = ['bank.png', 'credit_card.png', 'wallet.png'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    widget.name == 'Wallet' ? 'Payment' : 'Order Payment',
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
            decoration: BoxDecoration(
                border: Border.all(color: AppColor.appThemeColor),
                borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.only(top: 14, left: 16, right: 16),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.all(9),
              child: Text(
                'Amount to pay - \$907',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.blackColor),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16, top: 12),
            child: Text(
              'Petrol Satation',
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2E364B)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16, top: 2),
            child: Text(
              'Lexo Station Ngong road',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF696969)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              'Payment Methode',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, top: 21),
            height: 56,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: payment.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectIndex = index;
                  });
                },
                child: Container(
                  height: 56,
                  width: 76,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      color: _selectIndex == index
                          ? AppColor.appThemeColor
                          : Color(0xFFECEBF2),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        '${StringConstatnts.assets}${paymentImage[index]}',
                        height: 24,
                        color: _selectIndex == index
                            ? AppColor.whiteColor
                            : AppColor.blackColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        payment[index],
                        style: GoogleFonts.roboto(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: _selectIndex == index
                              ? AppColor.whiteColor
                              : AppColor.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, top: 33, right: 16),
            height: 56,
            child: Row(
              children: [
                Text(
                  _selectIndex == 0
                      ? 'SELECT BENIFITIORY'
                      : _selectIndex == 1
                          ? 'saved cards'.toUpperCase()
                          : 'Pay With UPI / wallet'.toUpperCase(),
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColor.blackColor,
                  ),
                ),
                Spacer(),
                if (_selectIndex != 2)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => AddNewCardScreen(
                            index: _selectIndex, name: widget.name),
                      ))
                          .then((value) {
                        if (mounted) {
                          setState(() {
                            if (value['index'] != '') {
                              _selectIndex = value['index'];
                            }
                          });
                        }
                      });
                    },
                    child: Container(
                      width: 87,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.center,
                      child: Text(
                        _selectIndex == 0
                            ? 'ADD NEW'
                            : 'new card'.toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          if (_selectIndex == 0)
            ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(bottom: 16),
                height: 46,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 18, right: 51),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            index == 0
                                ? '${StringConstatnts.assets}hbfc_bank.png'
                                : '${StringConstatnts.assets}sbi.png',
                            height: 32,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ACCOUNT HOLDER NAME',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'XXXXXXXXXXXXXX16',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Image.asset(
                            index == 0
                                ? '${StringConstatnts.assets}select.png'
                                : '${StringConstatnts.assets}unchecked.png',
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFE5E5E5),
                    )
                  ],
                ),
              ),
            ),
          if (_selectIndex == 1)
            ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFE1E0FF),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 14, top: 18, right: 13, bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Charles .K. Kelfers',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            'charleskkelfers21@gmail.com',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Card No. :',
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFA0A0A0)),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '234222XX XXXX XX00',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.blackColor),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Expiry Date :',
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFA0A0A0)),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '06/23',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.blackColor),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 18,
                        right: 13,
                        child: Container(
                          child: Row(
                            children: [
                              Image.asset(
                                index == 0
                                    ? '${StringConstatnts.assets}visa.png'
                                    : '${StringConstatnts.assets}mastercard.png',
                                height: 32,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Image.asset(
                                index == 0
                                    ? '${StringConstatnts.assets}select.png'
                                    : '${StringConstatnts.assets}unchecked.png',
                                height: 20,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          if (_selectIndex == 2)
            Container(
              margin: EdgeInsets.only(top: 20, left: 16, right: 16),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0XFFDCE5BA),
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16, top: 16),
                      child: Text(
                        'Choose your easy payment UPI',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, top: 16),
                      height: 46,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                '${StringConstatnts.assets}select.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                '${StringConstatnts.assets}mpasa.png',
                                height: 32,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'MPesa',
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFE5E5E5),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, top: 16),
                      height: 46,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                '${StringConstatnts.assets}unchecked.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SvgPicture.asset(
                                '${StringConstatnts.assets}wallet.svg',
                                height: 32,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Eqwi',
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFE5E5E5),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, top: 16),
                      height: 46,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                '${StringConstatnts.assets}unchecked.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                '${StringConstatnts.assets}artel_money.png',
                                height: 32,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Airtel Money',
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFE5E5E5),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, top: 16),
                      height: 46,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                '${StringConstatnts.assets}unchecked.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                '${StringConstatnts.assets}paypal.png',
                                height: 32,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Paypal',
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_selectIndex == 0)
            Container(
              margin: EdgeInsets.only(top: 83, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ammount',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    height: 48,
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF6D6D6D), width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Ammount',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFAAAAAA))),
                    ),
                  )
                ],
              ),
            ),
          GestureDetector(
            onTap: () {
              if (widget.name == 'Wallet') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymenSucssefullyScreen(),
                ));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderPaymentRequestScreen(),
                ));
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: _selectIndex == 0
                      ? 62
                      : _selectIndex == 1
                          ? 18
                          : 91,
                  left: 16,
                  right: 16,
                  bottom: 29),
              alignment: Alignment.center,
              height: 48,
              decoration: BoxDecoration(
                color: AppColor.blackColor,
                borderRadius: BorderRadius.circular(48 / 2),
              ),
              child: Text(
                _selectIndex == 0
                    ? 'Pay Now Securely'.toUpperCase()
                    : _selectIndex == 1
                        ? 'CONTINUE'
                        : 'Pay Now Securely'.toUpperCase(),
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
