// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/processing_order_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PendingOrderCardDesign extends StatefulWidget {
  String name;
  String? accountName;
  String? orders;
  PendingOrderCardDesign(
      {Key? key, required this.name, this.accountName, this.orders})
      : super(key: key);

  @override
  State<PendingOrderCardDesign> createState() => _PendingOrderCardDesignState();
}

class _PendingOrderCardDesignState extends State<PendingOrderCardDesign> {
  bool isLoader = false;
  List orders = [];
  String? user_token = Constants.prefs?.getString('user_token');
  @override
  void initState() {
    super.initState();
  }

  Future<void> getorderslist(name) async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_status': name.toString(),
      'page': '1'
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "order_list"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      print(result);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        setState(() {
          orders = result['data']['result'];
        });
        // print('orders');
        // print(orders);
        // });
      } else {
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 20, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFFD4D4D4),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 11, right: 10, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Order ID:  ',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFA0A0A0)),
                        children: <InlineSpan>[
                          TextSpan(
                            text: '00112A',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blackColor),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        if (widget.name == 'Processing')
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProcessingOrderDetailScreen(),
                              ));
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          AppColor.blackColor.withOpacity(0.25),
                                      offset: Offset(0, 2),
                                      blurRadius: 4),
                                ],
                              ), //#
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                    '${StringConstatnts.assets}truck.png'),
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            if (widget.name == 'Processing') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderSummaryScreen(
                                  name: 'Processing',
                                ),
                              ));
                            } else if (widget.name == 'Pending') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    OrderSummaryScreen(name: 'Pending'),
                              ));
                            }
                          },
                          child: Container(
                            height: 24,
                            width: 24,

                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(24 / 2),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColor.blackColor.withOpacity(0.25),
                                    offset: Offset(0, 2),
                                    blurRadius: 4),
                              ],
                            ), //#
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Image.asset(
                                  '${StringConstatnts.assets}right.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      '08/02/2022',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF929292)),
                    ),
                    Spacer(),
                    Text(
                      widget.name == 'Delivered' ? '' : 'Requested By:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF929292)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      'Petrol (Pms)',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5C5C5C),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.name == 'Delivered'
                          ? ''
                          : 'Lexo Station Ngong road',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5C5C5C),
                      ),
                    ),
                  ],
                ),
                if (widget.name == 'Delivered')
                  SizedBox(
                    height: 8,
                  ),
                if (widget.name == 'Delivered')
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Quantity: ',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA0A0A0)),
                          children: <InlineSpan>[
                            TextSpan(
                              text: '2,000 Ltr',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          text: 'Total Amount: ',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA0A0A0)),
                          children: <InlineSpan>[
                            TextSpan(
                              text: '\$2,43,000',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color(0xFFDBDBDB),
          ),
          if (widget.name == 'Pending' || widget.accountName == 'Manager')
            Container(
              margin: EdgeInsets.only(
                  top: 10,
                  left: 11,
                  right: 10,
                  bottom: widget.name == 'Processing' ? 0 : 10),
              child: Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Quantity: ',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA0A0A0)),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '2,000 Ltr',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.blackColor),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      text: 'Total Amount: ',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA0A0A0)),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '\$2,43,000',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.blackColor),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (widget.name == 'Processing')
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 8, left: 11, right: 10, bottom: 10),
              child: Text.rich(
                TextSpan(
                  text: 'Payment Term: ',
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA0A0A0)),
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Payment Upfront',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    )
                  ],
                ),
              ),
            ),
          if (widget.name == 'Delivered')
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 8, left: 11, right: 10, bottom: 10),
              child: Row(children: [
                Text.rich(
                  TextSpan(
                    text: 'Rating',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA0A0A0)),
                  ),
                ),
                RatingBar.builder(
                  itemSize: 16,
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          OrderSummaryScreen(name: 'Write A Review'),
                    ));
                  },
                  child: Container(
                    child: Text.rich(
                      TextSpan(
                        text: 'Write a review',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF89A619)),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}
