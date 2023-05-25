// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/forgot_password_screen_otp.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;
import '../../Common/constants.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String? token;

  const SetNewPasswordScreen({super.key, this.token});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  bool isloading = false;
  bool isloading1 = false;
  bool _passwordVisible = false;
  bool _cpasswordVisible = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  @override
  void initState() {
    _passwordVisible = true;
    _cpasswordVisible = true;
    super.initState();
    startTimer();
  }

  bool resendwidget = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;
  int _start = 30;
  String seconds = '30';
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            resendwidget = false;
          });
        } else {
          setState(() {
            _start--;
            if (_start < 10) {
              seconds = '0' + _start.toString();
            } else {
              seconds = _start.toString();
            }
          });
          ;
        }
      },
    );
  }

  Future<void> updatePassword() async {
    if (formkey.currentState!.validate()) {
      //true
      setState(() {
        isloading = true;
        // ignore: avoid_print
        print(isloading);
      });
      Map<String, dynamic> bodyData = {
        'token': widget.token.toString(),
        'password': passwordcontroller.text,
        'confirm_password': confirmpasswordcontroller.text
      };
      http.Response response = await http.post(
          Uri.parse(Constants.baseurl + "update_password"),
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
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
                        'Set New Password',
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
                      'Set Password',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF646464)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: passwordcontroller,
                      obscureText: _passwordVisible,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp("[ ]")),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10 / 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10 / 1)),
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA0A0A0),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            '${StringConstatnts.assets}password.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFFA0A0A0),
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 4) {
                          return 'minimum 4 letters';
                        }
                      },
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Password',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF646464)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: confirmpasswordcontroller,
                      obscureText: _cpasswordVisible,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp("[ ]")),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10 / 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10 / 1)),
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA0A0A0),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            '${StringConstatnts.assets}password.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFFA0A0A0),
                          ),
                          onPressed: () {
                            setState(() {
                              _cpasswordVisible = !_cpasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your confirm password';
                        } else if (value.length < 4) {
                          return 'minimum 4 letters';
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 16, right: 16, top: 24),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Confirm Password',
              //         style: GoogleFonts.roboto(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w400,
              //             color: Color(0xFF646464)),
              //       ),
              //       SizedBox(
              //         height: 8,
              //       ),
              //       TextFormField(
              //         controller: confirmpasswordcontroller,
              //         obscureText: _cpasswordVisible,
              //         autovalidateMode: AutovalidateMode.onUserInteraction,
              //         inputFormatters: <TextInputFormatter>[
              //           FilteringTextInputFormatter.deny(RegExp("[ ]")),
              //         ],
              //         decoration: InputDecoration(
              //           hintText: 'Password',
              //           contentPadding:
              //               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(10 / 1)),
              //           focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(10 / 1)),
              //           hintStyle: GoogleFonts.roboto(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w400,
              //             color: Color(0xFFA0A0A0),
              //           ),
              //           prefixIcon: Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Image.asset(
              //               '${StringConstatnts.assets}password.png',
              //               height: 20,
              //               width: 20,
              //             ),
              //           ),
              //           suffixIcon: IconButton(
              //             icon: Icon(
              //               // Based on passwordVisible state choose the icon
              //               _cpasswordVisible
              //                   ? Icons.visibility_off
              //                   : Icons.visibility,
              //               color: Color(0xFFA0A0A0),
              //             ),
              //             onPressed: () {
              //               setState(() {
              //                 _cpasswordVisible = !_cpasswordVisible;
              //               });
              //             },
              //           ),
              //         ),
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
                            updatePassword();
                          },
                          child: Text(
                            'SUBMIT',
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
            ],
          ),
        ),
      ),
    );
  }
}
