import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:owner_eqwi_petrol/Screens/Owner/payment_scussefully_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/paymentwebview.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'dart:convert' as convert;

import 'order_generate_screen.dart';

// ignore: must_be_immutable
class ManagerVerifyOrder extends StatefulWidget {
  String? order_id;
  ManagerVerifyOrder({super.key, this.order_id});

  @override
  State<ManagerVerifyOrder> createState() => _ManagerVerifyOrderState();
}

class _ManagerVerifyOrderState extends State<ManagerVerifyOrder> {
  bool isLoader = false;
  bool isloading = false;
  bool isCartloader = false;
  String? payment_type;
  String? amount;
  String? paymentOption;
  int final_amount = 0;
  int final_total_amount = 0;
  String? currentWalletAmount;
  String? currentusedWalletAmount;
  bool isChecked = false;
  String? currency = 'KES';
  // ignore: non_constant_identifier_names
  int used_wallet_amount = 0;
  // ignore: non_constant_identifier_names
  String? is_wallet_used;
  bool walletamountHigh = false;
  int total_amount = 0;
  String? inVoiceAmount;
  bool isgenerateloading = false;
  var orderdetails;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController anySuggestionController = TextEditingController();

  // ignore: non_constant_identifier_names
  String? user_token = Constants.prefs?.getString('user_token');
  // ignore: non_constant_identifier_names
  String? user_type = Constants.prefs?.getString('user_type');

  @override
  void initState() {
    super.initState();
    print('dsffg');
    getpaymentOption();

    getorderDetail();
    CountFun();
  }

  // ignore: non_constant_identifier_names
  Future<void> CountFun() async {
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    print('gethomecarfffftData');
    http.Response response =
        await http.post(Uri.parse("${Constants.baseurl}home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        print(result['data']);
        setState(() {
          inVoiceAmount = result['data']['invoice_amount'].toString();
        });

        //    print('inVoiceAmount :$inVoiceAmount');
      }
    }
  }

  Future<void> getpaymentOption() async {
    setState(() {
      isCartloader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}payment_option"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      //   print(result);
      setState(() {
        isCartloader = false;
      });
      if (result['status'] == 'success') {
        paymentOption = result['data'].toString();
        cuurentwalletbalance();
        //stepperData = result['data']['order_data']['status_list'];

        //   Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> generateBill() async {
    setState(() {
      isgenerateloading = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
      'order_id': widget.order_id.toString()
    };
    print('gethomecarfffftData');
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}generate_bill"), body: bodyData);
    setState(() {
      isgenerateloading = false;
    });
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const OrderGenerateScreen()));

        //  print('inVoiceAmount :$inVoiceAmount');
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
      //   print(result);

      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        // result['data']((element) {
        setState(() {
          //   orderdetails = (OrderDetailModal.fromJson(result['data']));
          orderdetails = result['data'];
          total_amount =
              int.parse(result['data']['total_amount'].split('.')[0]);
          final_amount =
              int.parse(result['data']['total_amount'].split('.')[0]);
        });
        //  print('totalAmount : $total_amount');
        // });
      }
    }
  }

  checkboxfun(value) {
    // print(currentusedWalletAmount);
    // print(total_final_amount);
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
          //   print('currentusedWalletAmount');
          //    print(currentusedWalletAmount);
          isChecked = true;
          is_wallet_used = '1';
          if (int.parse(currentWalletAmount.toString().split('.')[0]) <
              int.parse(total_amount.toString())) {
            //   print('con1');
            //   print(currentWalletAmount);
            used_wallet_amount =
                int.parse(currentWalletAmount.toString().split('.')[0]);
            final_amount = int.parse(total_amount.toString()) -
                int.parse(used_wallet_amount.toString());
            //  print(final_amount);
          } else if (int.parse(
                  int.parse(currentWalletAmount.toString().split('.')[0])
                      .toString()
                      .split('.')[0]) >
              int.parse(total_amount.toString())) {
            //    print('con2');
            //   print(int.parse(currentWalletAmount.toString().split('.')[0]));
            used_wallet_amount = int.parse(total_amount.toString());
            //  print(used_wallet_amount);
            final_amount = 0;
            walletamountHigh = true;
            // print(used_wallet_amount);
            // print(grandtotal);
          }
        } else if (value == false) {
          //   print('false');
          walletamountHigh = false;
          isChecked = false;
          is_wallet_used = '0';

          currentWalletAmount = '0';
          // print('is_wallet_used');
          // print(is_wallet_used);
          // print(walletamountHigh);
          //   total_final_amount = int.parse(widget.total_amount.toString());
        }
      });
    }
  }

  selectPaymentType(paymentType) {
    payment_type = paymentType.toString();
    // print(payment_type);
    // print(isChecked);
    if (isChecked == false) {
      is_wallet_used = '0';
      used_wallet_amount = 0;
    } else if (isChecked == true) {
      is_wallet_used = '1';
      //  currentWalletAmount = '0';
    }
    placeOrder(payment_type);
  }

  Future<void> placeOrder(paymentType) async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': widget.order_id.toString(),
      'payment_type': paymentType.toString(),
      'order_action': '1',
    };

    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}approve_order"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      //   print("print is.....${result['data']}");
      setState(() {
        isloading = false;
      });
      // print(result);
      if (result['status'] == 'success') {
        if (paymentType == "Upfront") {
          print('dgfdgdfg');
          print(isChecked);
          if (isChecked == true) {
            print('ischeckyes');
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
            print('ischeckno');
            makePayment(result['data']['id'], total_amount.toString());
          }
        } else if (paymentType == "50 Advance") {
          print('dgfdgdfgdsf 50 adva');
          final_amount = int.parse(total_amount.toString()) ~/ 2.floor();

          print(final_amount);

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
          print('ischeckno');
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

  Future<void> makewalletPayment(order_id, amount) async {
    print(order_id);
    print(amount);
    print('dgfdgsdsfsdfdfg');
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': order_id.toString(),
      'amount': amount.toString(),
      'wallet_amount': used_wallet_amount.toString(),
      'is_wallet_used': is_wallet_used.toString()
    };
    print(bodyData);

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
      //   print('refdg');
      // print(result);

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

  Future<void> makePayment(orderId, amount) async {
    //  print(order_id);
    //  print(amount);

    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': orderId.toString(),
      'amount': total_amount.toString(),
      'wallet_amount': used_wallet_amount.toString(),
      'is_wallet_used': is_wallet_used.toString()
    };
    print(bodyData);

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
      print('refdg');
      print(result);

      if (result['status'] == 'success') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentWebview(
                payment_url: result['data']['payment_initiate_url'],
                paymentId: result['data']['transaction_id'].toString())));

        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => OrderPaymentRequestScreen(
        //       orderNo: result['data']['order_no'],
        //       order_id: order_id.toString()),
        // ));
      } else {
        // ignore: use_build_context_synchronously
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> cuurentwalletbalance() async {
    print('current balance');
    setState(() {
      isCartloader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    print(bodyData);

    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "current_balance"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      setState(() {
        isCartloader = false;
      });
      if (result['status'] == 'success') {
        // print('currentWalletAmount');
        currentWalletAmount = result['data'];
        currentusedWalletAmount = result['data'];
        if (currentusedWalletAmount.toString() == null) {
          currentusedWalletAmount = "0";
        }
        // print(currentusedWalletAmount);
      } else {}
    }
  }

  Future<bool> onWillPop() {
    if (user_type == "Owner") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    } else if (user_type == "Manager") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
    }
    // Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBarCustom.commonAppBarCustom(context,
            title: 'Manager Verify Order', onTaped: () {
          if (user_type == 'Owner') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabbarScreen()));
          } else if (user_type == 'Manager') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
          }
        }),
        body: isLoader == false
            ? ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  for (var i = 0; i < orderdetails['order_details'].length; i++)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: 18, top: 16, left: 16, right: 16),
                        child: Column(
                          children: [
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
                                      "${orderdetails['station_name']}",
                                      //  orderdetails.stationName,
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
                                      "${orderdetails['order_details'][i]['qty']}",
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
                                      "${orderdetails['order_date']}",
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
                                      'Product',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF929292)),
                                    ),
                                    Text(
                                      "${orderdetails['order_details'][i]['name']}",
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
                                      "${orderdetails['city']}" +
                                          ',' +
                                          "${orderdetails['state']}" +
                                          ',' +
                                          "${orderdetails['country']}" +
                                          ',' +
                                          "${orderdetails['pincode']}",
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
                          ],
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFDDDDDD)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(left: 16, right: 16, top: 14),
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
                                  "${orderdetails['currency']}" +
                                      ' ' +
                                      "${orderdetails['amount']}",
                                  // orderdetails.currency +
                                  //     ' ' +
                                  //     orderdetails.amount,
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
                                  "${orderdetails['currency']}" +
                                      ' ' +
                                      "${orderdetails['shipping_charge']}",
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
                                  "${orderdetails['currency']}" +
                                      ' ' +
                                      "${orderdetails['tax']}",
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
                                  "${orderdetails['currency']}" +
                                      ' ' +
                                      "${orderdetails['total_amount']}",
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
                  Column(
                    children: [
                      if (int.parse(inVoiceAmount.toString()) >
                          int.parse(total_amount.toString().split('.')[0]))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 15),
                          child: Container(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  activeColor: AppColor.appThemeColor,
                                  onChanged: (value) {
                                    print(isChecked);
                                    checkboxfun(value);
                                  },
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                if (currentusedWalletAmount.toString() != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Wallet Amount $currency $currentusedWalletAmount',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                          'Above $currency 100 only applicable',
                                          style: const TextStyle(
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
                        ),
                      if (walletamountHigh == false)
                        Column(children: [
                          Container(
                            margin: const EdgeInsets.only(top: 46, left: 17),
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
                          if (paymentOption == '1' &&
                              (int.parse(inVoiceAmount.toString()) >
                                  int.parse(
                                      total_amount.toString().split('.')[0])))
                            isloading == false
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        payment_type = "Upfront";
                                      });
                                      selectPaymentType(payment_type);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 25,
                                          bottom: 14),
                                      alignment: Alignment.center,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColor.blackColor,
                                        borderRadius:
                                            BorderRadius.circular(48 / 2),
                                      ),
                                      child: Text(
                                        'Payment Upfront',
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.whiteColor),
                                      ),
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
                                    child: const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3),
                                      ),
                                    ),
                                  )
                        ]),
                      Column(
                        children: [
                          if (paymentOption == '2' &&
                              (int.parse(inVoiceAmount.toString()) >
                                  int.parse(
                                      total_amount.toString().split('.')[0])))
                            isloading == false
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        payment_type = "50 Advance";
                                      });
                                      selectPaymentType(payment_type);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                      ),
                                      alignment: Alignment.center,
                                      height: 48,
                                      decoration: BoxDecoration(
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
                                              style: GoogleFonts.roboto(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.whiteColor)),
                                          Image.asset(
                                            '${StringConstatnts.assets}correct.png',
                                            color: Colors.white,
                                            height: 15,
                                          ),
                                        ],
                                      ),
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
                                    child: const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3),
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
                            margin: const EdgeInsets.only(
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
                  if (int.parse(inVoiceAmount.toString()) <
                      int.parse(total_amount.toString().split('.')[0]))
                    Container(
                        margin:
                            const EdgeInsets.only(left: 16, right: 16, top: 40),
                        child: isgenerateloading == false
                            ? ElevatedButton(
                                onPressed: () {
                                  generateBill();
                                },
                                // ignore: sort_child_properties_last
                                child: const Text(
                                  'Generate Bill',
                                  style: TextStyle(
                                      fontFamily: "ROBOTO",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: const Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
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
                                child: const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3),
                                  ),
                                ),
                              )),
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
