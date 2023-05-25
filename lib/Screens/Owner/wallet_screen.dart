// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_wallet_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int tab = 0;
  // ignore: non_constant_identifier_names
  String? user_token = Constants.prefs?.getString('user_token');
  List<dynamic> transactions = [];
  int notransactiondata = 0;
  String? amount;
  bool isloader = false;
  bool isloading = false;
  bool successloader = false;
  String? currentWalletAmount;
  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  var final_amount;
  int selectedamount = 0;
  String? name;
  int payment_id = 0;

  switchTab(int selectedTab) {
    tab = selectedTab;
    setState(() {});
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController otherscontroller = TextEditingController();
  @override
  void initState() {
    balancetransactionslist();
    super.initState();
  }

  Future<void> balancetransactionslist() async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token,
    };

    setState(() {
      isloader = true;
    });
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}transaction_list"),
        body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // print(result['data'].length);
      setState(() {
        isloader = false;
      });
      print(result);
      if (result['status'] == 'success') {
        currentWalletAmount = result['data']['wallet_balance'];
        if (result['data']['total_records_count'] == 0) {
          notransactiondata = 0;
        } else {
          notransactiondata = 1;
          setState(() {
            transactions = result['data']['result'];
          });
        }
      } else {
        currentWalletAmount = '0';
        notransactiondata = 0;
      }
    }
  }

  Future<void> addAmounttoWallet(amount, myState) async {
    if (amount == "Others") {
      final_amount = otherscontroller.text;
    } else {
      final_amount = amount;
    }
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
        myState(() {
          isloading = true;
        });
        http.Response response = await http
            .post(Uri.parse("${Constants.baseurl}add_wallet"), body: bodyData);

        if (response.statusCode == 200) {
          var result = convert.jsonDecode(response.body);
          // dart array
          myState(() {
            isloading = false;
            // ignore: avoid_print
            print(isloading);
          });
          if (result['status'] == 'valid') {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: isloader == false
          ? ListView(children: [
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
                            child: Image.asset(
                                '${StringConstatnts.assets}back.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Wallet',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddWalletScreen(),
                          ));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 142,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColor.blackColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                '${StringConstatnts.assets}wallet.png',
                                height: 15,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Add Money'.toUpperCase(),
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.whiteColor),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
              // Container(
              //   color: Color(0xFFEBF0D8),
              //   child: Row(
              //     children: [
              //       Container(
              //         margin: EdgeInsets.only(left: 16, top: 7, bottom: 7),
              //         child: Text(
              //           "March 2022",
              //           style: GoogleFonts.roboto(
              //               fontSize: 10, fontWeight: FontWeight.w400),
              //         ),
              //       ),
              //       Spacer(),
              //       Container(
              //         child: Text(
              //           "Sort",
              //           style: GoogleFonts.roboto(
              //               fontSize: 10,
              //               fontWeight: FontWeight.w400,
              //               color: Color(0xFF6C6C6C)),
              //         ),
              //       ),
              //       Container(
              //         margin: EdgeInsets.only(left: 5, right: 16),
              //         child: Image.asset(
              //           '${StringConstatnts.assets}ic_settings.png',
              //           height: 18,
              //         ),
              //       )
              //     ],
              //   ),
              // ),

              Container(
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: (notransactiondata != 0)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _transactions(transactions[index]);
                        })
                    : Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                          'No Transactions',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        )),
                      ),
              )
            ])
          : Center(
              child: CircularProgressIndicator(
                  color: AppColor.appThemeColor, strokeWidth: 3),
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
