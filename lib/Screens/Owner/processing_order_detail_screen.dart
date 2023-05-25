// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Common/common_widgets/common_text_field_widget.dart';

class ProcessingOrderDetailScreen extends StatefulWidget {
  String? order_id;

  ProcessingOrderDetailScreen({super.key, this.order_id});

  @override
  State<ProcessingOrderDetailScreen> createState() =>
      _ProcessingOrderDetailScreenState();
}

class _ProcessingOrderDetailScreenState
    extends State<ProcessingOrderDetailScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  bool isLoader = false;
  String? orderId;
  String? orderDate;
  String? orderItem;
  String? orderQuantity;
  String? totalAmount;

  String displayStatus0 = '';
  String displayTime0 = '';
  bool activeStatus0 = false;
  String displayStatus1 = '';
  String displayTime1 = '';
  bool activeStatus1 = false;
  String displayStatus2 = '';
  String displayTime2 = '';
  bool activeStatus2 = false;
  String displayStatus3 = '';
  String displayTime3 = '';
  bool activeStatus3 = false;
  String displayStatus4 = '';
  String displayTime4 = '';
  bool activeStatus4 = false;

  //List<StepperData> stepperData = [];
  List activeStatusData = [];
  // List<dynamic> stepperData = [];
  @override
  void initState() {
    super.initState();
    getorderDetail();
  }

  Future<void> getorderDetail() async {
    dynamic data = [];

    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': widget.order_id.toString(),
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}track_order"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // print(result);

      setState(() {
        isLoader = false;
      });
      // result['data']['order_data']['status_list'].clear();
      if (result['status'] == 'success') {
        orderId = result['data']['order_data']['order_id'];
        orderDate = result['data']['order_data']['order_date'];
        orderItem = result['data']['order_data']['product_name'];
        totalAmount = result['data']['order_data']['total_amount'];
        orderQuantity = result['data']['order_data']['total_qty'];
        displayStatus0 =
            result['data']['order_data']['status_list'][0]['display_status'];
        displayTime0 =
            result['data']['order_data']['status_list'][0]['date_time'];
        activeStatus0 =
            result['data']['order_data']['status_list'][0]['status_active'];
        displayStatus1 =
            result['data']['order_data']['status_list'][1]['display_status'];
        displayTime1 =
            result['data']['order_data']['status_list'][1]['date_time'];
        activeStatus1 =
            result['data']['order_data']['status_list'][1]['status_active'];
        displayStatus2 =
            result['data']['order_data']['status_list'][2]['display_status'];
        displayTime2 =
            result['data']['order_data']['status_list'][2]['date_time'];
        activeStatus2 =
            result['data']['order_data']['status_list'][2]['status_active'];
        displayStatus3 =
            result['data']['order_data']['status_list'][3]['display_status'];
        displayTime3 =
            result['data']['order_data']['status_list'][3]['date_time'];
        activeStatus3 =
            result['data']['order_data']['status_list'][3]['status_active'];
        displayStatus4 =
            result['data']['order_data']['status_list'][4]['display_status'];
        displayTime4 =
            result['data']['order_data']['status_list'][4]['date_time'];
        activeStatus4 =
            result['data']['order_data']['status_list'][4]['status_active'];

        //    .length);
        // stepperData = result['data']['order_data']['status_list'];
        // for (var i = 0;
        //     i < result['data']['order_data']['status_list'].length;
        //     i++) {
        //   stepperData.add(StepperData(
        //       title: result['data']['order_data']['status_list'][i]
        //           ['display_status'],
        //       subtitle: result['data']['order_data']['status_list'][i]
        //           ['date_time'],
        //       // isActive: '',
        //       isActive: result['data']['order_data']['status_list'][i]
        //           ['status_active']
        //       // ['status_active']
        //       ));
        //   // for (var i = 0;
        //   //     i < result['data']['order_data']['status_list'].length;
        //   //     i++) {
        //   //   activeStatusData.add(stepperData.length);
        //   // }
        //}

        // for (var j = 0; j < stepperData.length; j++) {
        //   if (stepperData[j].isActive == true) {
        //     activeStatusData.add(stepperData[j]);
        //   }
        // }

        //   Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  // List<StepperData> stepperData = [
  //   StepperData(
  //     title: "Order Placed",
  //     subtitle: "We have received your order\nOn 20-Feb-2022 ",
  //   ),
  //   StepperData(
  //     title: "TRANSPORTER ASSIGNED",
  //     subtitle: "We have received your order\nOn 22-Feb-2022 ",
  //   ),
  //   StepperData(
  //     title: "Order Loaded",
  //     subtitle: "We have received your order\nOn 23-Feb-2022 ",
  //   ),
  //   StepperData(
  //     title: "Order Reached",
  //     subtitle: "We have received your order\nOn 23-Feb-2022 ",
  //   ),
  //   StepperData(
  //     title: "Delivered",
  //     subtitle: "We have received your order\nOn 23-Feb-2022 ",
  //   ),
  // ];
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
          'Order ID:$orderId',
          style:
              CustomTextWhiteStyle.textStyleWhite(context, 18, FontWeight.w600),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
            textColor: Colors.white,
            padding: const EdgeInsets.all(8),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    getorderDetail();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blackColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ))
        ],
      ),
      body: isLoader == false
          ? ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        offset: Offset(0, 1),
                        color: Color(0xFF000000).withOpacity(0.25),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 12, top: 14, bottom: 14, right: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              orderDate.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF929292)),
                            ),
                            Spacer(),
                            Text.rich(
                              TextSpan(
                                text: 'Quantity: ',
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFA0A0A0)),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: orderQuantity,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.blackColor),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Text(
                              orderItem.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF5C5C5C)),
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
                                    text: totalAmount,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
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
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        offset: Offset(0, 1),
                        color: Color(0xFF000000).withOpacity(0.25),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 12, top: 14, bottom: 14, right: 12),
                    // child: AnotherStepper(
                    //   scrollPhysics: NeverScrollableScrollPhysics(),
                    //   barThickness: 4,
                    //   stepperList: stepperData,
                    //   stepperDirection: Axis.vertical,
                    //   horizontalStepperHeight: 70,
                    //   dotWidget: Container(
                    //     padding: EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //         color: AppColor.appThemeColor,
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(30))),
                    //     child: Icon(Icons.check_sharp, color: Colors.white),
                    //   ),
                    //   activeBarColor: AppColor.appThemeColor,
                    //   inActiveBarColor: Colors.grey,
                    //   inverted: false,
                    //   activeIndex: activeStatusData.length - 1,
                    // ),
                    child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Stack(children: [
                              Positioned(
                                left: 22,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: 4,
                                  color: activeStatus0 == true
                                      ? AppColor.appThemeColor
                                      : Colors.grey,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: activeStatus0 == true
                                        ? AppColor.appThemeColor
                                        : Colors.grey,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 0,
                                        height: 5,
                                      ),
                                      Text(
                                        displayStatus0,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(displayTime0,
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ],
                              )
                            ]),
                          ),
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Stack(children: [
                              Positioned(
                                left: 22,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: 4,
                                  color: activeStatus1 == true
                                      ? AppColor.appThemeColor
                                      : Colors.grey,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: activeStatus1 == true
                                        ? AppColor.appThemeColor
                                        : Colors.grey,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 0,
                                        height: 5,
                                      ),
                                      Text(
                                        displayStatus1,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(displayTime1,
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ],
                              )
                            ]),
                          ),
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Stack(children: [
                              Positioned(
                                left: 22,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: 4,
                                  color: activeStatus2 == true
                                      ? AppColor.appThemeColor
                                      : Colors.grey,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: activeStatus2 == true
                                        ? AppColor.appThemeColor
                                        : Colors.grey,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 0,
                                        height: 5,
                                      ),
                                      Text(
                                        displayStatus2,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(displayTime2,
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ],
                              )
                            ]),
                          ),
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Stack(children: [
                              Positioned(
                                left: 22,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: 4,
                                  color: activeStatus3 == true
                                      ? AppColor.appThemeColor
                                      : Colors.grey,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: activeStatus3 == true
                                        ? AppColor.appThemeColor
                                        : Colors.grey,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 0,
                                        height: 5,
                                      ),
                                      Text(
                                        displayStatus3,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(displayTime3,
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ],
                              )
                            ]),
                          ),
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Stack(children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: activeStatus4 == true
                                        ? AppColor.appThemeColor
                                        : Colors.grey,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 0,
                                        height: 5,
                                      ),
                                      Text(
                                        displayStatus4,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(displayTime4,
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ],
                              )
                            ]),
                          ),
                        ]),
                  ),
                )
              ],
            )
          : Center(
              child: Container(
                child: CircularProgressIndicator(
                    color: AppColor.appThemeColor, strokeWidth: 3),
              ),
            ),
    );
  }
}
