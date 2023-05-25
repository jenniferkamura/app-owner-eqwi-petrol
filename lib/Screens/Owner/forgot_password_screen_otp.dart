// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/set_new_password_screen.dart';

import '../../Common/constants.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String? token;
  final String? mobile;

  const ForgotPasswordOtpScreen({super.key, this.token, this.mobile});

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

bool hasError = false;
String verifyText = '';

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  bool isloading = false;
  String? otpverifcationCode;
  bool isloading1 = false;
  @override
  final verify_otp = GlobalKey<FormState>();
  String? deviceId = Constants.prefs?.getString('deviceId');
  TextEditingController otpController = TextEditingController();
  @override
  void initState() {
    startTimer();
    String? displaymobile = widget.mobile!.substring(widget.mobile!.length - 4);
    super.initState();
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
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
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
              seconds = '0$_start';
            } else {
              seconds = _start.toString();
            }
          });
          ;
        }
      },
    );
  }

  Future<void> doverifyOtp(otpverifcationCode) async {
    print(otpverifcationCode);

    setState(() {
      isloading = true;
      // ignore: avoid_print
      print(isloading);
    });
    Map<String, dynamic> bodyData = {
      'otp': otpverifcationCode,
      'token': widget.token.toString(),
      'device_id': deviceId.toString(),
      'platform_type': "android"
    };
    // print(push_notification_key);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}verify_otp"), body: bodyData);

    //  print(response.statusCode);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array
      print(result);
      setState(() {
        isloading = false;
      });
      if (result['status'] == 'success') {
        // reidrect to login Page
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    SetNewPasswordScreen(token: widget.token.toString())));
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

  Future<void> resendotp() async {
    setState(() {
      isloading1 = true;
      // ignore: avoid_print
    });

    Map<String, dynamic> bodyData = {'token': widget.token.toString()};
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}resend_otp"), body: bodyData);
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      setState(() {
        isloading1 = false;
        // ignore: avoid_print
        print(isloading1);
      });
      print(result);
      // dart array
      if (result['status'] == 'success') {
        resendwidget = true;
        _start = 30;
        seconds = '30';
        startTimer();
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: "Otp Sent Successfully",
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
        // invalid
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: ListView(children: [
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
                        child:
                            Image.asset('${StringConstatnts.assets}back.png'),
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
              child: Image.asset('${StringConstatnts.assets}otp.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 50),
            child: Text(
              'OTP has been sent successfully to YOUR REGESTER NUMBER ENDING WITH XXXXXXXXX ${widget.mobile!.substring(widget.mobile!.length - 4).toString()}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Center(
              child: Form(
                key: verify_otp,
                child: PinCodeTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: otpController,
                  enablePinAutofill: false,
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 4,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Please enter valid OTP';
                    } else if (v.length < 4) {
                      return "Please enter OTP code";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    errorBorderColor: Colors.white,
                    borderWidth: 0,
                    selectedColor: Color(0xFFfcd8ca),
                    selectedFillColor: Colors.white,
                    inactiveColor: Colors.white,
                    inactiveFillColor: Colors.grey.shade200,
                    activeColor: Colors.transparent,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 60,
                    fieldWidth: 65,
                    activeFillColor: Colors.white,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      verifyText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");

                    return true;
                  },
                ),
              ),
            ),
          ),
          // Container(
          //   height: 48,
          //   margin: EdgeInsets.only(right: 46, left: 46, top: 22),
          //   child: OtpTextField(
          //     filled: true,
          //     fillColor: AppColor.whiteColor,
          //     fieldWidth: 48,
          //     autoFocus: true,
          //     numberOfFields: 4,
          //     borderColor: Colors.grey,
          //     borderRadius: BorderRadius.all(Radius.circular(10)),
          //     showFieldAsBox: true,
          //     borderWidth: 0.0,
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     onCodeChanged: (String code) {
          //       print('code');
          //       print(code);
          //       setState(() {
          //         verifyText = code;
          //       });
          //     },

          //     onSubmit: (String verificationCode) {
          //       setState(() {
          //         otpverifcationCode = verificationCode;
          //       });
          //       showDialog(
          //           context: context,
          //           builder: (context) {
          //             return AlertDialog(
          //               title: Text("Verification Code"),
          //               content: Text('Code entered is $verificationCode'),
          //             );
          //           });
          //     }, // end onSubmit
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          resendwidget
              ? Center(
                  child: Text('Resend code in 00 : $seconds'),
                )
              : Container(),
          Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 40),
              child: isloading == false
                  ? ElevatedButton(
                      onPressed: () {
                        print(verifyText);
                        if (verifyText == null) {
                          Fluttertoast.showToast(
                              // msg: jsonData['message'],
                              msg: "Please Enter OTP",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              webBgColor:
                                  "linear-gradient(to right, #6db000 #6db000)",
                              //  backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() => hasError = true);
                        } else if (verifyText.toString().length != 4) {
                          Fluttertoast.showToast(
                              // msg: jsonData['message'],
                              msg: "Enter valid OTP",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              webBgColor:
                                  "linear-gradient(to right, #6db000 #6db000)",
                              //  backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() => hasError = true);
                        } else {
                          doverifyOtp(verifyText);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.blackColor,
                          fixedSize: Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48 / 2),
                          )),
                      child: Text(
                        'VERIFY OTP',
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
          SizedBox(height: 50),
          (_start == 0)
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Didn't Receive A Code?",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Mulish semibold",
                            fontWeight: FontWeight.bold,
                          )),
                      GestureDetector(
                        onTap: () => resendotp(),
                        child: isloading1 == true
                            ? Center(
                                // ignore: sized_box_for_whitespace
                                child: Container(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(
                                    strokeWidth: 3),
                              ))
                            : Text(
                                ' Resend Code',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Mulish semibold",
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
                      )
                    ],
                  ),
                )
              : Container(),
        ]),
      ),
    );
  }
}
