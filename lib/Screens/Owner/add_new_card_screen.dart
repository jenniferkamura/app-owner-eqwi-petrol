// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

class AddNewCardScreen extends StatefulWidget {
  int index;
  String? name;
  AddNewCardScreen({Key? key, required this.index, this.name})
      : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  int _selectIndex = 0;
  List<String> payment = ['Bank Transfer', 'Card Payment', 'Wallet / UPI'];
  List<String> paymentImage = ['bank.png', 'credit_card.png', 'wallet.png'];
  List<String> listImage = [
    'hbfc_bank.png',
    'sbi.png',
  ];
  String? selectedValue;
  @override
  void initState() {
    setState(() {
      _selectIndex = widget.index;
    });
    super.initState();
  }

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
                      Navigator.of(context).pop({'date': _selectIndex});
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
                    Navigator.of(context).pop({'index': _selectIndex});
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
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16, top: 29),
            child: Text(
              _selectIndex == 0
                  ? 'ADD NEW BENIFITIORY'
                  : 'Add New Card Details',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          if (_selectIndex == 0) ...[
            Container(
              margin: EdgeInsets.only(top: 25, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select bank',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
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
                                'Select Bank',
                                style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.blackColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: [
                          'State Bank of India',
                          'State Bank of India 1',
                        ]
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        '${StringConstatnts.assets}sbi.png',
                                        height: 32,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        item,
                                        style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.blackColor),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        },
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                          ),
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
                        itemPadding: const EdgeInsets.only(left: 14, right: 14),
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
              margin: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Number',
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
                                  color: Color(0xFFD1D1DC), width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: '',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFAAAAAA))),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm Account Number',
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
                              borderSide: BorderSide(color: Color(0xFFD1D1DC)),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: '',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFAAAAAA))),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IFSC Code',
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
                                  color: Color(0xFFD1D1DC), width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: '',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFAAAAAA))),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Holder Name',
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
                                  color: Color(0xFFD1D1DC), width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: '',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFAAAAAA))),
                    ),
                  )
                ],
              ),
            ),
          ],
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Card number',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      '${StringConstatnts.assets}star.png',
                      height: 8,
                    )
                  ],
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
                            borderSide:
                                BorderSide(color: Color(0xFFD1D1DC), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: '',
                        hintStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFAAAAAA))),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Card Holder Name',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      '${StringConstatnts.assets}star.png',
                      height: 8,
                    )
                  ],
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
                            borderSide:
                                BorderSide(color: Color(0xFFD1D1DC), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: '',
                        hintStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFAAAAAA))),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Email Id',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      '${StringConstatnts.assets}star.png',
                      height: 8,
                    )
                  ],
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
                            borderSide:
                                BorderSide(color: Color(0xFFD1D1DC), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: '',
                        hintStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFAAAAAA))),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Expiry Date',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      '${StringConstatnts.assets}star.png',
                      height: 8,
                    )
                  ],
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
                            borderSide:
                                BorderSide(color: Color(0xFFD1D1DC), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: '',
                        hintStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFAAAAAA))),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'CVV Number',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      '${StringConstatnts.assets}star.png',
                      height: 8,
                    )
                  ],
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
                            borderSide:
                                BorderSide(color: Color(0xFFD1D1DC), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: '',
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
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => OrderPaymentScreen(),
              // ));
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: _selectIndex == 0
                      ? 37
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
                    ? 'ADD BENEFITIORY'.toUpperCase()
                    : _selectIndex == 1
                        ? 'SAVE CARD DETAILS'
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
