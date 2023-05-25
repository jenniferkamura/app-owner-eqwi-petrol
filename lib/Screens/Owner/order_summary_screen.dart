// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Attender/attender_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_payment_screen.dart';
import 'package:http/http.dart' as http;
import 'package:owner_eqwi_petrol/Screens/Owner/order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'dart:convert' as convert;

import 'package:owner_eqwi_petrol/modals/orderdetailmodel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Common/common_widgets/common_text_field_widget.dart';
import 'cart_screen.dart';

class OrderSummaryScreen extends StatefulWidget {
  String name;
  String? order_id;

  OrderSummaryScreen({super.key, required this.name, this.order_id});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  bool isLoader = false;
  bool isloading = false;
  bool reorderload = false;
  String? cartCount = '0';
  String? notiCount = '0';
  late OrderDetailModal orderdetails;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController anySuggestionController = TextEditingController();
  double rating = 0.0;
  // ignore: non_constant_identifier_names
  String? user_token = Constants.prefs?.getString('user_token');
  // ignore: non_constant_identifier_names
  String? user_type = Constants.prefs?.getString('user_type');
  @override
  void initState() {
    super.initState();
    getorderDetail();
  }

  void _launchWhatsapp(number, text) async {
    var whatsappAndroid = Uri.parse("https://wa.me/+919098576433");
    // Uri.parse("whatsapp://send?phone='+91'+$number&text=$text");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(
          // ignore: prefer_interpolation_to_compose_strings
          // Uri.parse('${'whatsapp://send?phone=+91' + number}&text=$text'));
          // ignore: prefer_interpolation_to_compose_strings
          Uri.parse('${'whatsapp://send?phone=+254' + number}&text=$text'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  void notificationsCountFun() async {
    print("datadtatatataatatta");
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    print('gethomecarfffftData');
    http.Response response =
        await http.post(Uri.parse(Constants.baseurl + "home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        print(result['data']);
        setState(() {
          cartCount = result['data']['cart_count'].toString();
          notiCount = result['data']['unread_notifications'].toString();
        });

        print('cartcountffffff :$cartCount');
      }
    }
  }

  Future<void> getorderDetail() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': widget.order_id.toString(),
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}order_details"), body: bodyData);

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
        print(orderdetails.userId);
        // });
      }
    }
  }

  Future<void> reorderSubmit() async {
    setState(() {
      reorderload = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': widget.order_id.toString(),
    };

    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}reorder"), body: bodyData);
    print(bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array
      setState(() {
        reorderload = false;
        // ignore: avoid_print
        print(isloading);
      });
      print(result);
      if (result['status'] == 'success') {
        // reidrect to login Page
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CartScreen(
                    notificationsCountFun_value: () =>
                        notificationsCountFun())));
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
      } else {
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
      }
    }
  }

  Future<void> reviewSubmit() async {
    print(rating.toString());
    if (rating == 0.0) {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please provide rating",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (formkey.currentState!.validate()) {
        //true
        setState(() {
          isloading = true;
          // ignore: avoid_print
          print(isloading);
        });
        Map<String, dynamic> bodyData = {
          'user_token': user_token.toString(),
          'order_id': widget.order_id.toString(),
          "rating": rating.toString(),
          "review": anySuggestionController.text,
        };

        http.Response response = await http.post(
            Uri.parse("${Constants.baseurl}add_order_review"),
            body: bodyData);
        print(bodyData);

        if (response.statusCode == 200) {
          var result = convert.jsonDecode(response.body);
          // dart array
          setState(() {
            isloading = false;
            // ignore: avoid_print
            print(isloading);
          });
          print(result);
          if (result['status'] == 'success') {
            // reidrect to login Page
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => TabbarScreen()));
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
          } else {
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
          }
        }
      }
    }
  }

  Future<bool> onWillPop() {
    if (user_type == "Owner") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    } else if (user_type == "Manager") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
    } else if (user_type == 'Attendant') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AttenderTabbarScreen()));
    }

    // Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBarCustom.commonAppBarCustom(context, title: 'Order Summary',
            onTaped: () {
          if (user_type == 'Owner') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabbarScreen()));
          } else if (user_type == 'Manager') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
          } else if (user_type == 'Attendant') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AttenderTabbarScreen()));
          }
        }),
        body: isLoader == false
            ? ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  for (var i = 0; i < orderdetails.orderDetails.length; i++)
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
                        margin: EdgeInsets.only(
                            bottom: 18, top: 16, left: 16, right: 16),
                        child: Column(
                          children: [
                            // Container(
                            //   alignment: Alignment.center,
                            //   child: Text.rich(
                            //     TextSpan(
                            //       text: 'Order ID:  ',
                            //       style: GoogleFonts.roboto(
                            //           fontSize: 12,
                            //           fontWeight: FontWeight.w400,
                            //           color: Color(0xFFA0A0A0)),
                            //       children: <InlineSpan>[
                            //         TextSpan(
                            //           text: orderdetails.orderDetails[i].cartOrderId,
                            //           style: GoogleFonts.roboto(
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.w400,
                            //               color: AppColor.blackColor),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order Requested by',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF929292)),
                                    ),
                                    Text(
                                      orderdetails.stationName,
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
                                      'Receiving Quantity',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF929292)),
                                    ),
                                    Text(
                                      orderdetails.orderDetails[i].qty,
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
                              height: 8,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order Date',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF929292)),
                                    ),
                                    Text(
                                      orderdetails.orderDate,
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    )
                                  ],
                                ),
                                Spacer(),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                //   children: [
                                //     Text(
                                //       'Approximate Receive Date',
                                //       style: GoogleFonts.roboto(
                                //           fontSize: 12,
                                //           fontWeight: FontWeight.w400,
                                //           color: Color(0xFF929292)),
                                //     ),
                                //     Text(
                                //       '15th Feb, 2022',
                                //       style: GoogleFonts.roboto(
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.w400,
                                //           color: AppColor.blackColor),
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 8,
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
                                      orderdetails.orderDetails[i].name,
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    )
                                  ],
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Shipped To',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF929292)),
                                    ),
                                    Text(
                                      '${orderdetails.city},${orderdetails.state},${orderdetails.country}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    )
                                  ],
                                )
                              ],
                            ),
                            if (widget.name == 'Write A Review' ||
                                widget.name == 'Processing' ||
                                widget.name == 'MAKE PAYMENT')
                              SizedBox(
                                height: 8,
                              ),
                            if (orderdetails.orderDetails[i].qualityOfProduct !=
                                '')
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quality of Product',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF929292)),
                                      ),
                                      Text(
                                        orderdetails
                                            .orderDetails[i].qualityOfProduct,
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
                                        'Status',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF929292)),
                                      ),
                                      Text(
                                        widget.name == 'Write A Review'
                                            ? 'Delivered'
                                            : 'Shipped',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                widget.name == 'Write A Review'
                                                    ? AppColor.appThemeColor
                                                    : AppColor.blackColor),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            if (widget.name != 'Recent Ordered Product')
                              SizedBox(
                                height: 8,
                              ),
                            if (widget.name != 'Recent Ordered Product')
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Payment Term:',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF929292)),
                                      ),
                                      Text(
                                        orderdetails.paymentType,
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.blackColor),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 8,
                            ),
                            if (orderdetails.otpCode != '0')
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text('OTP :${orderdetails.otpCode}')
                                    ],
                                  )
                                ],
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
                                  '${orderdetails.currency} ${orderdetails.amount}',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF212121)),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
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
                                  '${orderdetails.currency} ${orderdetails.shippingCharge}',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF212121)),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
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
                                  '${orderdetails.currency} ${orderdetails.tax}',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF212121)),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: 1,
                            color: widget.name == 'Write A Review'
                                ? Color(0xFFDDDDDD)
                                : Color(0xFFB8D44C),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 11),
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
                                  '${orderdetails.currency} ${orderdetails.totalAmount}',
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
                  // ignore: unnecessary_null_comparison
                  if (orderdetails.transporterMobile != "")
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        'Transporter Information',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  if (orderdetails.transporterMobile != "")
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.name == 'Write A Review'
                              ? Color(0xFFDDDDDD)
                              : Color(0xFFB8D44C),
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
                                    'Transporter Name',
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8F8F8F)),
                                  ),
                                  Spacer(),
                                  Text(
                                    orderdetails.transporterName,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF212121)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                children: [
                                  Text(
                                    'Transporter Mobile',
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8A8A8A)),
                                  ),
                                  Spacer(),
                                  Text(
                                    orderdetails.transporterMobile,
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF212121)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                children: [
                                  Text(
                                    'Vehicle Number',
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF8F8F8F)),
                                  ),
                                  Spacer(),
                                  Text(
                                    orderdetails.vehicleNumber,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF212121)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.name == 'Processing' ||
                      widget.name == 'MAKE PAYMENT')
                    Container(
                      margin: EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 32,
                            width: 100,
                            child: CommonIconButton(
                                tapIconButton: () async {
                                  await launchUrl(Uri.parse(
                                      'tel:${orderdetails.transporterMobile}'));
                                },
                                buttonColor: AppColor.appThemeColor,
                                buttonText: 'Call',
                                iconDataD: Icons.call,
                                textColorData: Colors.white),
                          ),
                          Spacer(),
                          SizedBox(
                            height: 32,
                            width: 100,
                            child: CommonIconButton(
                                tapIconButton: () async {
                                  _launchWhatsapp(
                                      orderdetails.transporterMobile, 'hello');
                                },
                                buttonColor: AppColor.blackColor,
                                buttonText: 'Chat',
                                iconDataD: Icons.chat_outlined,
                                textColorData: Colors.white),
                          ),
                        ],
                      ),
                    ),

                  // if (widget.name == 'Write A Review') ...[
                  // ignore: unrelated_type_equality_checks
                  if (orderdetails.rating == "0" &&
                      widget.name == 'Write A Review')
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 20),
                            child: Text(
                              'Rate our Transporter',
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF555561)),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 20),
                            child: RatingBar.builder(
                              itemSize: 30,
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              glow: false,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 5.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Color(0xFFFEDC00),
                              ),
                              onRatingUpdate: (val) {
                                // print(rating);
                                setState(() {
                                  rating = val;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 20),
                            child: Text(
                              'Add review',
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF555561)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 13.0, top: 0, bottom: 15, right: 9),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: anySuggestionController,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Write a review ....",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 10),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your message";
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  // ],
                  // ignore: unnecessary_null_comparison
                  if (orderdetails.rating == "0" &&
                      widget.name == 'Write A Review')
                    Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, top: 20, bottom: 20),
                        child: isloading == false
                            ? ElevatedButton(
                                onPressed: () {
                                  reviewSubmit();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                                child: Text(
                                  'Submit review'.toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: "ROBOTO",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                                child: Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3),
                                  ),
                                ),
                              )),

                  if (widget.name == 'Write A Review')
                    Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, top: 20, bottom: 20),
                        child: reorderload == false
                            ? ElevatedButton(
                                onPressed: () {
                                  reorderSubmit();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                                child: Text(
                                  'Re Order'.toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: "ROBOTO",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                                child: Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3),
                                  ),
                                ),
                              )),
                  // if (widget.name == 'Write A Review' ||
                  //     widget.name == 'Processing' ||
                  //     widget.name == 'MAKE PAYMENT' ||
                  //     widget.accountName == 'Manager')
                  //   GestureDetector(
                  //     onTap: () {
                  //       if ((widget.accountName != 'Manager' &&
                  //               widget.name == 'Processing') ||
                  //           widget.name == 'MAKE PAYMENT') {
                  //         Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => OrderPaymentScreen(),
                  //         ));
                  //       } else if (widget.accountName == 'Manager') {
                  //         showDialog(
                  //             context: context,
                  //             builder: (context) {
                  //               return ConfirmationPopup(
                  //                 name: widget.accountName,
                  //               );
                  //             });
                  //       } else {
                  //         Navigator.of(context).pop();
                  //       }
                  //     },
                  //     child: Container(
                  //       margin: EdgeInsets.only(left: 16, right: 16, top: 28),
                  //       alignment: Alignment.center,
                  //       height: 48,
                  //       decoration: BoxDecoration(
                  //         color: AppColor.blackColor,
                  //         borderRadius: BorderRadius.circular(48 / 2),
                  //       ),
                  //       child: Text(
                  //         widget.name == 'Write A Review'
                  //             ? 'Submit review'.toUpperCase()
                  //             : widget.accountName == 'Manager'
                  //                 ? 'Raise order'.toUpperCase()
                  //                 : 'Make Payment'.toUpperCase(),
                  //         style: GoogleFonts.roboto(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //             color: AppColor.whiteColor),
                  //       ),
                  //     ),
                  //   ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                    color: AppColor.appThemeColor, strokeWidth: 3),
              ),
      ),
    );
  }
}

// Container(
//             height: 76,
//             color: AppColor.appThemeColor,
//             width: MediaQuery.of(context).size.width,
//             child: Container(
//               margin: EdgeInsets.only(left: 16, right: 16),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       height: 24,
//                       decoration: BoxDecoration(
//                         color: AppColor.whiteColor,
//                         borderRadius: BorderRadius.circular(24 / 2),
//                         boxShadow: [
//                           BoxShadow(
//                               color: AppColor.blackColor.withOpacity(0.25),
//                               offset: Offset(0, 4),
//                               blurRadius: 4),
//                         ],
//                       ), //#
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.all(0),
//                         child:
//                             Image.asset('${StringConstatnts.assets}back.png'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Text(
//                     widget.name == 'Write A Review'
//                         ? 'Write A Review'
//                         : 'Order Summary',
//                     style: GoogleFonts.roboto(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: AppColor.whiteColor),
//                   )
//                 ],
//               ),
//             ),
//           ),
