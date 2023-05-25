// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/processing_order_detail_screen.dart';
import 'package:owner_eqwi_petrol/widget/Owner/pending_order_card_design.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RequestedByManagerScreen extends StatefulWidget {
  const RequestedByManagerScreen({super.key});

  @override
  State<RequestedByManagerScreen> createState() => _RequestedByManagerState();
}

class _RequestedByManagerState extends State<RequestedByManagerScreen> {
  bool isRequestedByManger = false;
  List requestorders = [];
  int requestordersCount = 0;
  bool isLoader = false;
  String? user_token = Constants.prefs?.getString('user_token');
  int start = 0;
  @override
  void initState() {
    getrequestedbymangerorderslist();
    super.initState();
  }

  Future<void> getrequestedbymangerorderslist() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'user_type': 'Manager',
      'page': '1'
    };
    print(bodyData);
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}requested_orders"),
        body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      //  print(result);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        requestorders.clear();
        setState(() {
          requestordersCount = result['data']['total_records_count'];
          requestorders = result['data']['result'];
        });
        // });
      } else if (result['status'] == 'error') {
        requestorders.clear();
        setState(() {
          requestordersCount = 0;
        });
      }
    }
  }

  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadMoreData();
    return false;
  }

  Future<void> loadMoreData() async {
    start = 1;
    if (mounted) {
      setState(() {
        start = start+ 1;
      });
    }
    // dynamic sliders = [];
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'user_type': 'Manager',
      'page': start.toString()
    };
    print(bodyData);
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}requested_orders"),
        body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);

      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        // orders.clear();
        setState(() {
          requestordersCount = result['data']['total_records_count'];
          for (var i = 0; i < result['data']['result'].length; i++) {
            requestorders = result['data']['result'];
          }
        });
      } else if (result['status'] == 'error') {
        requestorders.clear();
        setState(() {
          requestordersCount = 0;
        });
      }
    }
    // print("serviceslist: $carservices");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom.commonAppBarCustom(context,
          title: 'Requested By Manager Orders', onTaped: () {
        Navigator.of(context).pop();
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text(
                  'Requested by manager',
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor),
                ),
              ),
              ListView.builder(
                itemCount: requestorders.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => requestorderstablist(
                  requestorders[index],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget requestorderstablist(data) {
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
                            text: data['order_id'].toString(),
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
                        if (data['order_status'] == 'Processing')
                          GestureDetector(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => OrderSummaryScreen(
                              //     name: 'Processing',
                              //     order_id: data['id'],
                              //   ),
                              // ));
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProcessingOrderDetailScreen(
                                        order_id: data['id'].toString()),
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
                            if (data['order_status'] == 'Processing') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderSummaryScreen(
                                  name: 'Processing',
                                  order_id: data['id'].toString(),
                                ),
                              ));
                            } else if (data['order_status'] == 'Pending') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderSummaryScreen(
                                    name: 'Pending',
                                    order_id: data['id'].toString()),
                              ));
                            } else if (data['order_status'] == 'Completed') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderSummaryScreen(
                                  name: 'Completed',
                                  order_id: data['id'].toString(),
                                ),
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
                      data['delivery_date'].toString(),
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF929292)),
                    ),
                    Spacer(),
                    Text(
                      data['order_status'] == 'Delivered'
                          ? ''
                          : 'Requested By: ' + data['contact_person'],
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
                      data['product_name'],
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5C5C5C),
                      ),
                    ),
                    Spacer(),
                    Text(
                      data['station_name'],
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5C5C5C),
                      ),
                    ),
                  ],
                ),
                if (data['order_status'] == 'Delivered')
                  SizedBox(
                    height: 8,
                  ),
                if (data['order_status'] == 'Delivered')
                  Row(
                    children: [
                      // Text.rich(
                      //   TextSpan(
                      //     text: 'Quantity: ',
                      //     style: GoogleFonts.roboto(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w400,
                      //         color: Color(0xFFA0A0A0)),
                      //     children: <InlineSpan>[
                      //       TextSpan(
                      //         text: '2,000 Ltr',
                      //         style: GoogleFonts.roboto(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w500,
                      //             color: AppColor.blackColor),
                      //       )
                      //     ],
                      //   ),
                      // ),
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
                              text: data['total_amount'],
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
          //   if (name == 'Pending' || accountName == 'Manager')
          if (data['order_status'] == 'Pending')
            Container(
              margin: EdgeInsets.only(
                  top: 10,
                  left: 11,
                  right: 10,
                  bottom: data['order_status'] == 'Processing' ? 0 : 10),
              child: Row(
                children: [
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
                          text: data['total_amount'],
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
          if (data['order_status'] == 'Processing')
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
                      text: data['payment_type'],
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    )
                  ],
                ),
              ),
            ),
          if (data['order_status'] == 'Completed')
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
                  initialRating: data['rating'] == null
                      ? double.parse("0")
                      : double.parse(data['rating']),
                  minRating: data['rating'] == null
                      ? double.parse("0")
                      : double.parse(data['rating']),
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  tapOnlyMode: false,
                  updateOnDrag: false,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    //  print(rating);
                  },
                ),
                Spacer(),
                if (data['rating'] == null)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderSummaryScreen(
                            name: 'Write A Review', order_id: data['id']),
                      ));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) =>
                      //       OrderSummaryScreen(name: 'Write A Review'),
                      // ));
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
