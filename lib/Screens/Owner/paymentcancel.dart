// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';

class PaymentCancel extends StatefulWidget {
  const PaymentCancel({super.key});

  @override
  State<PaymentCancel> createState() =>
      _PaymentCancelState();
}

class _PaymentCancelState extends State<PaymentCancel> {
  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    // Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context,
            title: 'Payment Cancel', onTaped: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => TabbarScreen())));
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Center(
                  child: Image.asset(
                    '${StringConstatnts.assets}paymentcancel.png',
                    height: 107,
                  ),
                ),
                // Text(
                //   'Money added Successfully.',
                //   style: GoogleFonts.roboto(
                //       fontSize: 24,
                //       fontWeight: FontWeight.w500,
                //       color: Color(0xFF2DBE7C)),
                // ),

                Text(
                  'Your Payment cancelled.',
                  style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2DBE7C)),
                ),

                Container(
                  margin: EdgeInsets.only(top: 200),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TabbarScreen()));
                    },
                    child: Text(
                      'Go To Home',
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
