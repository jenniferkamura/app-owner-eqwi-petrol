// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/forgot_password_screen_otp.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;
import 'package:owner_eqwi_petrol/Screens/Owner/verify_otp.dart';
import '../../Common/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isloading = false;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController mobilecontroller = TextEditingController();

  Future<void> goToForgotOtp() async {
    if (formkey.currentState!.validate()) {
      //true

      Map<String, dynamic> bodyData = {
        'mobile': mobilecontroller.text,
      };
      setState(() {
        isloading = true;
        // ignore: avoid_print
        print(isloading);
      });
      http.Response response = await http.post(
          Uri.parse("${Constants.baseurl}forgot_password"),
          body: bodyData);
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return ForgotPasswordOtpScreen(
                token: result['data']['token'], mobile: mobilecontroller.text);
          }));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Form(
          key: formkey,
          child: ListView(
            children: [
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
                        'Forgot Password',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 39),
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ), //#
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Image.asset(
                      '${StringConstatnts.assets}forgot_password.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Number',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF646464)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: mobilecontroller,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      // onChanged: (text) {
                      //   setState(() {
                      //     letterCount = int.parse(text);
                      //     //  print(phonecontroller.text.length);
                      //   });
                      // },
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(48 / 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(48 / 1)),
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA0A0A0),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            '${StringConstatnts.assets}mobile.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        print(value);
                        if (value!.isEmpty) {
                          return 'Please Enter Mobile Number';
                        }
                        // else if (value.startsWith(RegExp('[0]'))) {
                        //   return "Please Enter Valid Mobile number";
                        // }
                      },
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 16, right: 16, top: 34),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Mobile Number',
              //         style: GoogleFonts.roboto(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w400,
              //             color: Color(0xFF646464)),
              //       ),
              //       SizedBox(
              //         height: 8,
              //       ),
              //       TextFormField(
              //         controller: mobilecontroller,
              //         keyboardType: TextInputType.number,
              //         autovalidateMode: AutovalidateMode.onUserInteraction,
              //         inputFormatters: <TextInputFormatter>[
              //           LengthLimitingTextInputFormatter(10),
              //           FilteringTextInputFormatter.digitsOnly,
              //           FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              //         ],
              //         decoration: InputDecoration(
              //           hintText: 'Enter Phone Number',
              //           contentPadding:
              //               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(48 / 1)),
              //           focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(48 / 1)),
              //           hintStyle: GoogleFonts.roboto(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w400,
              //             color: Color(0xFFA0A0A0),
              //           ),
              //           prefixIcon: Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Image.asset(
              //               '${StringConstatnts.assets}mobile.png',
              //               height: 20,
              //               width: 20,
              //             ),
              //           ),
              //         ),
              //         validator: (value) {
              //           print(value);
              //           if (value!.isEmpty) {
              //             return 'Please Enter Mobile Number';
              //           } else if (value.startsWith(RegExp('[0]'))) {
              //             return "Please Enter Valid Mobile number";
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 82, bottom: 40),
                  child: isloading == false
                      ? ElevatedButton(
                          onPressed: () {
                            goToForgotOtp();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.blackColor,
                              fixedSize: Size(300, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48 / 2),
                              )),
                          child: Text(
                            'SEND OTP',
                            style: TextStyle(
                                fontFamily: "ROBOTO",
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
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
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) {
              //         return ForgotPasswordOtpScreen();
              //       },
              //     ));
              //   },
              //   child: Container(
              //     margin: EdgeInsets.only(left: 16, right: 16, top: 40),
              //     alignment: Alignment.center,
              //     height: 48,
              //     decoration: BoxDecoration(
              //       color: AppColor.blackColor,
              //       borderRadius: BorderRadius.circular(48 / 2),
              //     ),
              //     child: Text(
              //       'send OTP'.toUpperCase(),
              //       style: GoogleFonts.roboto(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w500,
              //           color: AppColor.whiteColor),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
