// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/confirmation_popup.dart';
import 'package:http/http.dart' as http;
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:owner_eqwi_petrol/modals/orderdetailmodel.dart';
import 'dart:convert' as convert;

import 'package:owner_eqwi_petrol/modals/reviewordermodal.dart';

class ReceiveNewOrderScreen extends StatefulWidget {
  String? name;
  String? orderId;
  String? reviewDetail;
  String? displayStatus;

  ReceiveNewOrderScreen({Key? key, this.name, this.orderId, this.displayStatus})
      : super(key: key);

  @override
  State<ReceiveNewOrderScreen> createState() => _ReceiveNewOrderScreenState();
}

class _ReceiveNewOrderScreenState extends State<ReceiveNewOrderScreen> {
  bool isLoader = false;
  bool isloading = false;
  String? user_token = Constants.prefs?.getString('user_token');
  String? user_type = Constants.prefs?.getString('user_type');
  String? quality = 'Good';
  late OrderDetailModal orderdetails;
  String? checkquality;
  Receiveneworderreviewmodal receiveneworderDetail = Receiveneworderreviewmodal(
      id: '',
      cartOrderId: "",
      cartUserId: "",
      categoryId: "",
      name: "",
      type: "",
      image: "",
      measurement: "",
      qty: "",
      price: "",
      currency: "",
      totalPrice: "",
      status: "",
      cartUpdated: "",
      assignOrderId: "",
      assignOrderDetailId: "",
      transporterId: "",
      otpCode: "",
      receiveQty: "",
      qualityOfProduct: "",
      receiveStatus: "",
      receiveDatetime: "",
      deliveredDatetime: "",
      orderId: "",
      orderDate: "",
      imagePath: "",
      cartCreated: "",
      paymentType: "");
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController quantitycontroller = TextEditingController();
  void initState() {
    print(widget.orderId);
    //getReviewData();
    getorderDetail();
  }

  Future<void> getReviewData() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_detail_id': widget.orderId.toString()
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "review_order"), body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      print(result);
      if (result['status'] == 'success') {
        receiveneworderDetail =
            Receiveneworderreviewmodal.fromJson(result['data']);
        // reviewDetail = result['data'];
      } else {
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> getorderDetail() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': widget.orderId.toString(),
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "order_details"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      print(result);

      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        // result['data']((element) {
        setState(() {
          orderdetails = (OrderDetailModal.fromJson(result['data']));
        });
        print(orderdetails);
        // });
      }
    }
  }

  Future<void> doConfirmation() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': widget.orderId.toString(),
      'quality_of_product': quality.toString(),
      'quantity_of_product': orderdetails.totalQty.toString(),
    };
    print(bodyData);

    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "receive_order"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      print(result);

      setState(() {
        isloading = false;
      });

      if (result['status'] == 'success') {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: "${result['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            webBgColor: "linear-gradient(to right, #6db000 #6db000)",
            //  backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TabbarScreen(),
        ));
        print(orderdetails);
        // });
      }
    }
  }

  Future<bool> onWillPop() {
    if (user_type == 'Owner') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TabbarScreen()));
      //Get.back();
    } else if (user_type == 'Manager') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
      //Get.back();
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context,
            title: 'Receive new order for review', onTaped: () {
          Navigator.pop(context);
        }),
        body: isLoader == false
            ? ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFFC2C2C2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 10, left: 11, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      text: '#${orderdetails.orderId}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF5C5C5C)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Order Date: ' +
                                          '${orderdetails.orderDate}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFFA0A0A0)),
                                    ),
                                  ),
                                  Spacer(),
                                  if (widget.name == 'Manager')
                                    Text.rich(
                                      TextSpan(
                                        text: 'Requested By:',
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFFA0A0A0)),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Payment Term: ',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFFA0A0A0)),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '${orderdetails.paymentType}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF5C5C5C)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Station: ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFA0A0A0)),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '${orderdetails.stationName}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF5C5C5C)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Total Amount: ',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFA0A0A0)),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '${orderdetails.totalAmount}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF5C5C5C)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                          height: 1,
                          color: Color(0xFFD3D3D3),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        for (var i = 0;
                            i < orderdetails.orderDetails.length;
                            i++)
                          Container(
                            margin: EdgeInsets.only(left: 11, right: 10),
                            child: Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Product: ',
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFA0A0A0)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text:
                                            '${orderdetails.orderDetails[i].name}',
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF5C5C5C)),
                                      )
                                    ],
                                  ),
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
                                        text:
                                            '${orderdetails.orderDetails[i].qty} ( ${orderdetails.orderDetails[i].measurement} )',
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF5C5C5C)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  //     if (widget.displayStatus == 'Review Order')
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: 16, right: 16, top: 24, bottom: 10),
                    child: Text.rich(
                      TextSpan(
                        text: 'Quality Of Product',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  //    if (widget.displayStatus == 'Review Order')
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 10),
                    child: Row(
                      children: [
                        quality == 'Good'
                            ? ElevatedButton(
                                onPressed: () {
                                  // doLogin();
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      '${StringConstatnts.assets}like.png',
                                      color: Colors.white,
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Good',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    Image.asset(
                                      '${StringConstatnts.assets}correct.png',
                                      color: Colors.white,
                                      height: 15,
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(120, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    quality = 'Good';
                                  });
                                  print(quality);
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      '${StringConstatnts.assets}like.png',
                                      color: Colors.black,
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Good',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      '${StringConstatnts.assets}correct.png',
                                      color: Colors.white,
                                      height: 15,
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.whiteColor,
                                    fixedSize: Size(120, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                              ),
                        SizedBox(
                          width: 16,
                        ),
                        quality == 'Bad'
                            ? ElevatedButton(
                                onPressed: () {
                                  // doLogin();
                                },
                                child: Row(children: [
                                  Image.asset(
                                    '${StringConstatnts.assets}bad.png',
                                    color: Colors.white,
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Bad',
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    '${StringConstatnts.assets}correct.png',
                                    color: Colors.white,
                                    height: 15,
                                  ),
                                ]),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(120, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    quality = 'Bad';
                                  });
                                  print(quality);
                                },
                                child: Row(children: [
                                  Image.asset(
                                    '${StringConstatnts.assets}bad.png',
                                    color: Color(0xFF828282),
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Bad',
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF828282)),
                                  ),
                                  Image.asset(
                                    '${StringConstatnts.assets}correct.png',
                                    color: Colors.white,
                                    height: 15,
                                  ),
                                ]),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.whiteColor,
                                    fixedSize: Size(120, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                              ),
                      ],
                    ),
                  ),
                  //      if (widget.displayStatus == 'Review Order')
                  //    if (widget.displayStatus == 'Review Order')
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: 16, right: 16, top: 24, bottom: 10),
                    child: Text.rich(
                      TextSpan(
                        text: 'Quantity of Product',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ),

                  Container(
                    height: 42,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF828282))),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: 16,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: '${orderdetails.totalQty}',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  //  if (widget.displayStatus == 'Review Order')
                  Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 40),
                      child: isloading == false
                          ? ElevatedButton(
                              onPressed: () {
                                doConfirmation();
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return ConfirmationPopup(name: widget.name);
                                //     });
                              },
                              child: Text(
                                'Confirmation',
                                style: TextStyle(
                                    fontFamily: "ROBOTO",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.blackColor,
                                  fixedSize: Size(300, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(48 / 2),
                                  )),
                            )
                          : ElevatedButton(
                              onPressed: () {},
                              child: Center(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 3),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.blackColor,
                                  fixedSize: Size(300, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(48 / 2),
                                  )),
                            )),
                  // GestureDetector(
                  //   onTap: () {
                  //     showDialog(
                  //         context: context,
                  //         builder: (context) {
                  //           return ConfirmationPopup(name: widget.name);
                  //         });
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 16, right: 16, top: 199),
                  //     alignment: Alignment.center,
                  //     height: 48,
                  //     decoration: BoxDecoration(
                  //       color: AppColor.blackColor,
                  //       borderRadius: BorderRadius.circular(48 / 2),
                  //     ),
                  //     child: Text(
                  //       'confirmation'.toUpperCase(),
                  //       style: GoogleFonts.roboto(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //           color: AppColor.whiteColor),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            : Center(
                child: Container(
                  child: CircularProgressIndicator(
                      color: AppColor.appThemeColor, strokeWidth: 3),
                ),
              ),
      ),
    );
  }
}
