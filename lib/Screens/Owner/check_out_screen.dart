// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Attender/attender_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manager_cart_order_raise_sucessfully_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_generate_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_payment_request_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_payment_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/payment_scussefully_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/paymentwebview.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Common/common_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../Attender/attender_cart_raise_successfully_screen.dart';

class CheckOutScreen extends StatefulWidget {
  final String? cart_ids;
  final String? delivery_type;
  final String? delivery_date;
  final String? delivery_time;
  final String? station_id;
  final String? coupon_code;

  CheckOutScreen(
      {Key? key,
      this.cart_ids,
      this.delivery_type,
      this.delivery_date,
      this.delivery_time,
      this.station_id,
      this.coupon_code})
      : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  bool isCartloader = false;
  bool isCartsloader = false;
  bool isLoader = false;
  bool isgenerateloading = false;
  int cartcount = 0;
  int total_amount = 0;
  String? shipping_charges;
  String? tax;
  int total_mrp = 0;
  String? currency;
  List<dynamic> cart_list = [];
  List cart_ids = [];
  String? payment_type;
  String? amount;
  String? paymentOption;
  int final_amount = 0;
  int final_total_amount = 0;
  String? currentWalletAmount;
  String? currentusedWalletAmount;
  bool isChecked = false;
  int used_wallet_amount = 0;
  String? is_wallet_used;
  bool walletamountHigh = false;
  String? user_type = Constants.prefs?.getString('user_type');
  bool israiseloader = false;
  // final Uri payment_url;
  String url = "";
  String? inVoiceAmount;

  final GlobalKey webViewKey = GlobalKey();

  void initState() {
    //print('userType:$user_type');
    //print(widget.delivery_date);
    //print(widget.delivery_time);
    //print(widget.delivery_type);
    //print(widget.station_id);
    getpaymentOption();
    CountFun();
    getcartList();
  }

  Future<void> getpaymentOption() async {
    setState(() {
      // isCartloader = true;
      isCartsloader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    //print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "payment_option"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      //print(result);
      setState(() {
        //isCartloader = false;
        isCartsloader = false;
      });
      if (result['status'] == 'success') {
        paymentOption = result['data'].toString();
        cuurentwalletbalance();
        //stepperData = result['data']['order_data']['status_list'];

        //   Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> getcartList() async {
    //  var type = 'current';
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'coupon_code': widget.coupon_code.toString(),
      'station_id': widget.station_id.toString(),
    };
    //print(bodyData);
    setState(() {
      isCartloader = true;
    });
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}cart_list"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      cart_list.clear();
      //  //print("//print is.....${result}");
      setState(() {
        isCartloader = false;
      });
      if (result['status'] == 'success') {
        //   //print('valid');
        //  //print(result['data'].length);
        if (result['data']['cart_data'] == null ||
            result['data']['cart_data'] == '' ||
            result['data']['cart_data'].length == 0) {
        } else {
          setState(() {
            cart_list = result['data']['cart_data'];
            amount = result['data']['amount'].toString();
            total_mrp = result['data']['amount'];
            shipping_charges = result['data']['shipping_charge'].toString();
            tax = result['data']['tax'];
            total_amount = result['data']['total_amount'];
            final_amount = result['data']['total_amount'];
            final_total_amount = result['data']['final_total_amount'];
            currency = result['data']['currency'];
            cartcount = cart_list.length;
          });
          for (var i = 0; i < cart_list.length; i++) {
            cart_ids.add(cart_list[i]['cart_id']);
          }
          //print('cart_id');
          //print(cart_ids);
        }
      } else {
        setState(() {
          cartcount = 0;
        });

        //print(cartcount);
      }
    }
  }

  selectPaymentType(paymentType) {
    payment_type = paymentType.toString();
    //print(payment_type);
    //print(isChecked);
    if (isChecked == false) {
      is_wallet_used = '0';
      used_wallet_amount = 0;
    } else if (isChecked == true) {
      is_wallet_used = '1';
      //  currentWalletAmount = '0';
    }
    placeOrder(payment_type);
  }

  Future<void> cuurentwalletbalance() async {
    //print('current balance');
    setState(() {
      isCartloader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    //print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}current_balance"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      setState(() {
        isCartloader = false;
      });
      if (result['status'] == 'success') {
        // //print('currentWalletAmount');
        currentWalletAmount = result['data'];
        currentusedWalletAmount = result['data'];
        // ignore: unnecessary_null_comparison
        if (currentusedWalletAmount.toString() == null) {
          currentusedWalletAmount = "0";
        }
        // //print(currentusedWalletAmount);
      } else {}
    }
  }

  Future<void> raiseOrder() async {
    setState(() {
      israiseloader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'station_id': widget.station_id.toString(),
      'cart_ids': cart_ids.toString(),
      'shipping_charge': shipping_charges.toString(),
      'tax': tax.toString(),
      'amount': amount.toString(),
      'total_amount': final_total_amount.toString(),
      'is_schedule_delivery': widget.delivery_type.toString(),
      'delivery_date': widget.delivery_date.toString(),
      'delivery_time': widget.delivery_time.toString(),
      'coupon_code': widget.coupon_code,
    };

    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}place_order"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      cart_list.clear();
      //   //print("//print is.....${result['data']}");
      setState(() {
        israiseloader = false;
      });
      //print(result);
      if (result['status'] == 'success') {
        if (user_type == 'Manager') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ManagerOrderRaiseScreen()));
        } else if (user_type == 'Attendant') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AttenderOrderRaiseScreen()));
        }
      } else {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: result['message'],
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

  Future<void> placeOrder(paymentType) async {
    setState(() {
      isCartloader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'station_id': widget.station_id.toString(),
      'cart_ids': cart_ids.toString(),
      'shipping_charge': shipping_charges.toString(),
      'tax': tax.toString(),
      'amount': amount.toString(),
      'total_amount': final_total_amount.toString(),
      'is_schedule_delivery': widget.delivery_type.toString(),
      'delivery_date': widget.delivery_date.toString(),
      'delivery_time': widget.delivery_time.toString(),
      'payment_type': paymentType.toString(),
      'coupon_code': widget.coupon_code,
      'is_invoice': '0'
    };
    //print(bodyData);

    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}place_order"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      cart_list.clear();
      //   //print("//print is.....${result['data']}");
      setState(() {
        isCartloader = false;
      });
      // //print(result);
      if (result['status'] == 'success') {
        if (paymentType == "Upfront") {
          //print('dgfdgdfg');
          //print(isChecked);
          if (isChecked == true) {
            //print('ischeckyes');
            if (int.parse(currentWalletAmount.toString().split('.')[0]) <
                int.parse(total_amount.toString())) {
              makePayment(result['data']['id'], final_amount.toString());
            } else if (int.parse(
                    int.parse(currentWalletAmount.toString().split('.')[0])
                        .toString()
                        .split('.')[0]) >
                int.parse(total_amount.toString())) {
              makewalletPayment(result['data']['id'], final_amount.toString());
            }
          } else if (isChecked == false) {
            //print('ischeckno');
            makePayment(result['data']['id'], total_amount.toString());
          }
        } else if (paymentType == "50 Advance") {
          //print('dgfdgdfgdsf 50 adva');
          final_amount = int.parse(total_amount.toString()) ~/ 2.floor();

          //print(final_amount);

          if (int.parse(currentWalletAmount.toString().split('.')[0]) <
              int.parse(final_amount.toString())) {
            makePayment(result['data']['id'], final_amount.toString());
          } else if (int.parse(
                  int.parse(currentWalletAmount.toString().split('.')[0])
                      .toString()
                      .split('.')[0]) >
              int.parse(final_amount.toString())) {
            makewalletPayment(result['data']['id'], final_amount.toString());
          }
        } else if (isChecked == false) {
          //print('ischeckno');
          makePayment(result['data']['id'], final_amount.toString());
        }

        //  makePayment(result['data']['id'], final_amount.toString());
      } else {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: result['message'],
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

  Future<void> makewalletPayment(orderId, amount) async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': orderId.toString(),
      'amount': amount.toString(),
      'wallet_amount': used_wallet_amount.toString(),
      'is_wallet_used': is_wallet_used.toString()
    };
    //print(bodyData);

    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}make_payment"), body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      //   //print('refdg');
      // //print(result);

      if (result['status'] == 'success') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PaymenSucssefullyScreen()));
      } else {
        // ignore: use_build_context_synchronously
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  // ignore: dead_code
  Future<void> makePayment(orderId, amount) async {
    //print(orderId);
    //print(amount);
    //print('dgfdgsds   fsdfdfg');
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': orderId.toString(),
      'amount': amount.toString(),
      'wallet_amount': used_wallet_amount.toString(),
      'is_wallet_used': is_wallet_used.toString()
    };
    //print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}make_payment"), body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      //   //print('refdg');

      if (result['status'] == 'success') {
        String? paymentUrl = result['data']['payment_initiate_url'];
        // final Uri _url = Uri.parse('https://flutter.dev');
        final Uri _url = Uri.parse(result['data']['payment_initiate_url']);
        //  _openPaymenturl(_url);
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentWebview(
                payment_url: paymentUrl,
                paymentId: result['data']['transaction_id'].toString())));
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => PaymentJambo()));
      } else {
        // ignore: use_build_context_synchronously
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  // Future<void> _openPaymenturl(Uri url) async {
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw 'Could not launch $url';
  //   }
  // }

  checkboxfun(value) {
    // //print(currentusedWalletAmount);
    // //print(total_final_amount);
    if (int.parse(currentusedWalletAmount.toString().split('.')[0]) < 100) {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Your wallet amount is less than  100 ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        if (value == true) {
          currentWalletAmount = currentusedWalletAmount;
          //   //print('currentusedWalletAmount');
          //    //print(currentusedWalletAmount);
          isChecked = true;
          is_wallet_used = '1';
          if (int.parse(currentWalletAmount.toString().split('.')[0]) <
              int.parse(total_amount.toString())) {
            //   //print('con1');
            //   //print(currentWalletAmount);
            used_wallet_amount =
                int.parse(currentWalletAmount.toString().split('.')[0]);
            final_amount = int.parse(total_amount.toString()) -
                int.parse(used_wallet_amount.toString());
            //print(final_amount);
          } else if (int.parse(
                  int.parse(currentWalletAmount.toString().split('.')[0])
                      .toString()
                      .split('.')[0]) >
              int.parse(total_amount.toString())) {
            //    //print('con2');
            //   //print(int.parse(currentWalletAmount.toString().split('.')[0]));
            used_wallet_amount = int.parse(total_amount.toString());
            //print(used_wallet_amount);
            final_amount = 0;
            walletamountHigh = true;
            // //print(used_wallet_amount);
            // //print(grandtotal);
          }
        } else if (value == false) {
          //   //print('false');
          walletamountHigh = false;
          isChecked = false;
          is_wallet_used = '0';

          currentWalletAmount = '0';
          // //print('is_wallet_used');
          // //print(is_wallet_used);
          // //print(walletamountHigh);
          //   total_final_amount = int.parse(widget.total_amount.toString());
        }
      });
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> CountFun() async {
    //print("datadtatatataatatta");
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    //print('gethomecarfffftData');
    http.Response response =
        await http.post(Uri.parse("${Constants.baseurl}home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        //print(result['data']);
        setState(() {
          inVoiceAmount = result['data']['invoice_amount'].toString();
        });

        //print('inVoiceAmount :$inVoiceAmount');
      }
    }
  }

  Future<void> generatePlaceOrder(paymentType) async {
    setState(() {
      isgenerateloading = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'station_id': widget.station_id.toString(),
      'cart_ids': cart_ids.toString(),
      'shipping_charge': shipping_charges.toString(),
      'tax': tax.toString(),
      'amount': amount.toString(),
      'total_amount': final_total_amount.toString(),
      'is_schedule_delivery': widget.delivery_type.toString(),
      'delivery_date': widget.delivery_date.toString(),
      'delivery_time': widget.delivery_time.toString(),
      'payment_type': 'Upfront',
      'coupon_code': widget.coupon_code,
      'is_invoice': '1'
    };
    //print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}place_order"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      cart_list.clear();
      //   //print("//print is.....${result['data']}");
      setState(() {
        isgenerateloading = false;
      });

      if (result['status'] == 'success') {
        generateBill(result['data']['id']);
      } else {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: result['message'],
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

  Future<void> generateBill(orderId) async {
    setState(() {
      isgenerateloading = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
      'order_id': orderId.toString()
    };
    //print('gethomecarfffftData');
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "generate_bill"), body: bodyData);
    setState(() {
      isgenerateloading = false;
    });
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => OrderGenerateScreen()));

        //print('inVoiceAmount :$inVoiceAmount');
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
    } else if (user_type == 'Attendant') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AttenderTabbarScreen()));
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
        appBar: AppBarCustom.commonAppBarCustom(context, title: 'Check out',
            onTaped: () {
          Navigator.pop(context);
        }),
        body: isCartloader == false
            ? ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 22),
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 17, left: 16, right: 16, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summery',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                '$currency $total_mrp',
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.blackColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Shipping Charges',
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF8F8F8F)),
                              ),
                              Spacer(),
                              Text(
                                '$currency $shipping_charges',
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.blackColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Tax',
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF8F8F8F)),
                              ),
                              Spacer(),
                              Text(
                                '$currency $tax',
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.blackColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Container(
                            height: 1,
                            color: Color(0xFFD1D1D1),
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Final Payable',
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Spacer(),
                              Text(
                                '$currency $total_amount',
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.blackColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded(
                  //   child: Container(
                  //     margin: const EdgeInsets.all(10.0),
                  //     decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.blueAccent)),
                  //     child: webView(
                  //       initialUrl:
                  //           "https://flutter.dev/", //"https://flutter.dev/",
                  //       //initialFile: "assets/index.html",
                  //       initialHeaders: {},
                  //       initialOptions: InAppWebViewWidgetOptions(
                  //           crossPlatform: InAppWebViewOptions(
                  //         debuggingEnabled: true,
                  //       )),
                  //       onWebViewCreated: (InAppWebViewController controller) {
                  //         webView = controller;
                  //       },
                  //       onLoadStart:
                  //           (InAppWebViewController controller, String url) {
                  //         //print("onLoadStart $url");
                  //         setState(() {
                  //           this.url = url;
                  //         });
                  //       },
                  //       onLoadStop: (InAppWebViewController controller,
                  //           String url) async {
                  //         //print("onLoadStop $url");
                  //         setState(() {
                  //           this.url = url;
                  //         });

                  //       },
                  //       onProgressChanged:
                  //           (InAppWebViewController controller, int progress) {
                  //         setState(() {
                  //           this.progress = progress / 100;
                  //         });
                  //       },

                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 8,
                    color: Color(0xFF89A619),
                  ),
                  // if (int.parse(currentWalletAmount.toString().split('.')[0]) > 0)
                  if (user_type == 'Owner')
                    if (int.parse(inVoiceAmount.toString()) >
                        int.parse(total_amount.toString().split('.')[0]))
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 15),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  activeColor: AppColor.appThemeColor,
                                  onChanged: (value) {
                                    // //print(isChecked);
                                    checkboxfun(value);
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                // ignore: unnecessary_null_comparison
                                if (currentusedWalletAmount.toString() != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Wallet Amount $currency $currentusedWalletAmount',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                          'Above $currency 100 only applicable',
                                          style: TextStyle(
                                            // color: Colors.black,
                                            fontSize: 10,
                                            fontFamily: 'Mulish',
                                            //fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          if (walletamountHigh == false)
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 46, left: 17),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Payment Type'.toUpperCase(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                ),
                                if (paymentOption == '1')
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 16, right: 16, top: 40),
                                      child: isCartsloader == false
                                          ? ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  payment_type = "Upfront";
                                                });
                                                selectPaymentType(payment_type);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColor.blackColor,
                                                  fixedSize: Size(300, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            48 / 2),
                                                  )),
                                              child: Text(
                                                'Payment Upfront',
                                                style: TextStyle(
                                                    fontFamily: "ROBOTO",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColor.blackColor,
                                                  fixedSize: Size(300, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            48 / 2),
                                                  )),
                                              child: Center(
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 3),
                                                ),
                                              ),
                                            )),
                                // GestureDetector(
                                //   onTap: () {

                                //     setState(() {
                                //       payment_type = "Upfront";
                                //     });
                                //     selectPaymentType(payment_type);
                                //   },
                                //   child: Container(
                                //     margin: EdgeInsets.only(
                                //         left: 16,
                                //         right: 16,
                                //         top: 25,
                                //         bottom: 14),
                                //     alignment: Alignment.center,
                                //     height: 48,
                                //     decoration: BoxDecoration(
                                //       color: AppColor.blackColor,
                                //       borderRadius:
                                //           BorderRadius.circular(48 / 2),
                                //     ),
                                //     child: Text(
                                //       'Payment Upfront',
                                //       style: GoogleFonts.roboto(
                                //           fontSize: 14,
                                //           fontWeight: FontWeight.w400,
                                //           color: AppColor.whiteColor),
                                //     ),
                                //   ),
                                // ),
                                if (paymentOption == '2')
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        payment_type = "50 Advance";
                                      });
                                      selectPaymentType(payment_type);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                      ),
                                      alignment: Alignment.center,
                                      height: 48,
                                      decoration: payment_type != "50 Advance"
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFFC9C9C9)),
                                              color: AppColor.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(48 / 2),
                                            )
                                          : BoxDecoration(
                                              color: AppColor.blackColor,
                                              borderRadius:
                                                  BorderRadius.circular(48 / 2),
                                            ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('50% Advance - 50% On Delivery',
                                              style: payment_type !=
                                                      "50 Advance"
                                                  ? GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColor.blackColor)
                                                  : GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColor.whiteColor)),
                                          Image.asset(
                                            '${StringConstatnts.assets}correct.png',
                                            color: Colors.white,
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          if (walletamountHigh == true)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  payment_type = "Upfront";
                                });
                                selectPaymentType(payment_type);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 25, bottom: 14),
                                alignment: Alignment.center,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColor.blackColor,
                                  borderRadius: BorderRadius.circular(48 / 2),
                                ),
                                child: Text(
                                  'Pay From Wallet',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.whiteColor),
                                ),
                              ),
                            ),
                        ],
                      ),

                  if ((int.parse(inVoiceAmount.toString()) >
                              int.parse(
                                  total_amount.toString().split('.')[0])) &&
                          (user_type == 'Manager') ||
                      (user_type == 'Attendant'))
                    Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 40),
                        child: israiseloader == false
                            ? ElevatedButton(
                                onPressed: () {
                                  raiseOrder();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                                child: Text(
                                  'RAISE ORDER',
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

                  if (int.parse(inVoiceAmount.toString()) <
                      int.parse(total_amount.toString().split('.')[0]))
                    Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 40),
                        child: isgenerateloading == false
                            ? ElevatedButton(
                                onPressed: () {
                                  generatePlaceOrder(payment_type);
                                },
                                child: Text(
                                  'Generate Bill',
                                  style: TextStyle(
                                      fontFamily: "ROBOTO",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
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
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                              )),
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

//  Container(
//             margin: EdgeInsets.only(left: 16, right: 16, top: 40),
//             child: isLoader == false
//                 ? ElevatedButton(
//                     onPressed: () {
//                       selectPaymentType('Upfront');
//                     },
//                     child: Text(
//                       'Payment Upfront',
//                       style: TextStyle(
//                           fontFamily: "ROBOTO",
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColor.blackColor,
//                         fixedSize: Size(300, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(48 / 2),
//                         )),
//                   )
//                 : ElevatedButton(
//                     onPressed: () {},
//                     child: Center(
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                             color: Colors.white, strokeWidth: 3),
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColor.blackColor,
//                         fixedSize: Size(300, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(48 / 2),
//                         )),
//                   )),
