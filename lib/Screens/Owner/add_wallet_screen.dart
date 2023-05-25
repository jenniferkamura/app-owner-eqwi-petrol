// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';

import 'addAmountToWalletWebview.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({Key? key}) : super(key: key);

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  int tab = 0;
  switchTab(int selectedTab) {
    tab = selectedTab;
    setState(() {});
  }

  // ignore: non_constant_identifier_names
  String? user_token = Constants.prefs?.getString('user_token');
  List<dynamic> transactions = [];
  int notransactiondata = 0;
  String? amount;
  bool isloader = false;
  bool isloading = false;
  bool successloader = false;
  String? currentWalletAmount;
  var final_amount;
  int selectedamount = 0;
  String? name;
  int payment_id = 0;

  List<String> money = ['500', '1000', '2000', '3000', '4000'];

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController otherscontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    balancetransactionslist();
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    // Get.back();
    return Future.value(false);
  }

  Future<void> balancetransactionslist() async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token,
    };
    // print(bodyData);
    setState(() {
      isloader = true;
    });
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}transaction_list"),
        body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // print('waalet data');
      // print(result['data'].length);
      setState(() {
        isloader = false;
      });
      if (result['status'] == 'success') {
        currentWalletAmount = result['data']['wallet_balance'];
        if (result['data']['total_records_count'] == 0) {
          print('no trans');
          notransactiondata = 0;
        } else {
          print('no trans111');
          notransactiondata = 1;
          setState(() {
            transactions = result['data']['result'];
          });
        }
        //   print(transactions);
      } else {
        currentWalletAmount = '0';
      }
    }
  }

  Future<void> addAmounttoWallet() async {
    // print('amount');
    //   print(amount);
    final_amount = otherscontroller.text;

    if (final_amount == '' || final_amount == null) {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please enter minimum amount 10",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    // if (formkey.currentState!.validate()) {

    // }
    //true
    else {
      if (int.parse(final_amount) > 10) {
        Map<String, dynamic> bodyData = {
          'user_token': user_token.toString(),
          'amount': final_amount.toString()
        };
        print(bodyData);
        setState(() {
          isloading = true;
        });
        http.Response response = await http
            .post(Uri.parse("${Constants.baseurl}add_wallet"), body: bodyData);
        print('response');
        print(response.statusCode);
        if (response.statusCode == 200) {
          var result = convert.jsonDecode(response.body);
          print('result');
          print(result);
          // dart array
          setState(() {
            isloading = false;
            // ignore: avoid_print
            print(isloading);
          });
          if (result['status'] == 'success') {
            // ignore: use_build_context_synchronously
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AmountwalletWabview(
                    payment_url: result['data']['payment_initiate_url'],
                    paymentId: result['data']['transaction_id'].toString())));
            // Fluttertoast.showToast(
            //     // msg: jsonData['message'],
            //     msg: "${result['message']}",
            //     toastLength: Toast.LENGTH_SHORT,
            //     gravity: ToastGravity.TOP,
            //     timeInSecForIosWeb: 1,
            //     webBgColor: "linear-gradient(to right, #6db000 #6db000)",
            //     //  backgroundColor: Colors.red,
            //     textColor: Colors.white,
            //     fontSize: 16.0);
            //  balancetransactionslist();
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
          // }
        }
      } else {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: "Please enter minimum amount 10",
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context, title: 'Add Wallet',
            onTaped: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => TabbarScreen()));
        }),
        body: isloader == false
            ? ListView(
                children: [
                  Container(
                    height: 63,
                    margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppColor.appThemeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Current Wallet Balance',
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColor.whiteColor),
                        ),
                        Text(
                          'KES $currentWalletAmount',
                          style: GoogleFonts.roboto(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: AppColor.whiteColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Topup Wallet',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Form(
                          key: formkey,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: otherscontroller,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                // FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Amount',
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Amount';
                                } else if (value.startsWith(RegExp('[0]'))) {
                                  return "Please Enter Valid Amount";
                                } else if (int.parse(value) < 10) {
                                  return "Please Enter Valid Amount";
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  amount = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, top: 20),
                    child: Text(
                      'Recommended',
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF808080)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, top: 5),
                    height: 32,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: money.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                otherscontroller.text = money[index].toString();
                              });
                            },
                            child: otherscontroller.text ==
                                    money[index].toString()
                                ? Container(
                                    width: 70,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black,
                                      border: Border.all(
                                        color: Color(0xFFBEBEBE),
                                      ),
                                    ),
                                    child: Text(
                                      '\KES  ${money[index]}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Color(0xFFBEBEBE),
                                      ),
                                    ),
                                    child: Text(
                                      '\KES ${money[index]}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                          );
                        }),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 40),
                      child: isloading == false
                          ? ElevatedButton(
                              onPressed: () {
                                addAmounttoWallet();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.blackColor,
                                  fixedSize: Size(300, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(48 / 2),
                                  )),
                              child: Text(
                                'Proceed to topup'.toUpperCase(),
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
                                    borderRadius: BorderRadius.circular(48 / 2),
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
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    height: 8,
                    color: AppColor.appThemeColor.withOpacity(0.17),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 16,
                    ),
                    child: Text(
                      'Recent Transactions',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 10),
                  //   child: Row(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           switchTab(0);
                  //         },
                  //         child: Container(
                  //           height: 30,
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           // width: 60,
                  //           decoration: BoxDecoration(
                  //             border: Border(
                  //               bottom: BorderSide(
                  //                 color: tab == 0 ? Color(0xFF89A619) : Colors.white,
                  //                 width: 2,
                  //               ),
                  //             ),
                  //           ),
                  //           alignment: Alignment.center,
                  //           child: Text(
                  //             "ALL",
                  //             style: GoogleFonts.roboto(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w400,
                  //                 color: Colors.black),
                  //           ),
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       GestureDetector(
                  //         onTap: () {
                  //           switchTab(1);
                  //         },
                  //         child: Container(
                  //           height: 30,
                  //           // width: 60,
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           decoration: BoxDecoration(
                  //             border: Border(
                  //               bottom: BorderSide(
                  //                 color: tab == 1 ? Color(0xFF89A619) : Colors.white,
                  //                 width: 2,
                  //               ),
                  //             ),
                  //           ),
                  //           alignment: Alignment.center,
                  //           child: Text(
                  //             "PAID",
                  //             style: GoogleFonts.roboto(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w400,
                  //                 color: Colors.black),
                  //           ),
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       GestureDetector(
                  //         onTap: () {
                  //           switchTab(2);
                  //         },
                  //         child: Container(
                  //           height: 30,
                  //           // width: 60,
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           decoration: BoxDecoration(
                  //             border: Border(
                  //               bottom: BorderSide(
                  //                 color: tab == 2 ? Color(0xFF89A619) : Colors.white,
                  //                 width: 2,
                  //               ),
                  //             ),
                  //           ),
                  //           alignment: Alignment.center,
                  //           child: Text(
                  //             "PURCHASED",
                  //             style: GoogleFonts.roboto(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w400,
                  //                 color: Colors.black),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _transactions(transactions[index]);
                        }),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                    color: AppColor.appThemeColor, strokeWidth: 3),
              ),
      ),
    );
  }

  Widget _transactions(data) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['payment_type'] == 'Wallet')
            Image.asset(
              '${StringConstatnts.assets}wale.png',
              height: 24,
            ),
          if (data['payment_type'] == 'Purchase')
            Image.asset(
              '${StringConstatnts.assets}downwallet.png',
              height: 24,
            ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['payment_type'],
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
              // Text(
              //   data['station_name'],
              //   style: GoogleFonts.roboto(
              //       fontSize: 12,
              //       fontWeight: FontWeight.w400,
              //       color: Colors.black),
              // ),
              Text(
                data['payment_date'],
                style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6C6C6C)),
              ),
            ],
          ),
          Spacer(),
          if (data['payment_type'] == 'Purchase')
            Text(
              // ignore: prefer_interpolation_to_compose_strings
              '${'- ' + data['currency']} ' + data['amount'],
              style: GoogleFonts.roboto(
                  fontSize: 12, fontWeight: FontWeight.w400, color: Colors.red),
            ),
          if (data['payment_type'] == 'Wallet')
            Text(
              // ignore: prefer_interpolation_to_compose_strings
              '${'+ ' + data['currency']} ' + data['amount'],
              style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.green),
            ),
        ],
      ),
    );
  }
}
