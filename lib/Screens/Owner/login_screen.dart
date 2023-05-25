// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Attender/attender_home_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Attender/attender_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_station_manager_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_station_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/forgot_password_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/register_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/verify_mobile_otp_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/verify_otp.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:owner_eqwi_petrol/utility/auth_service.dart';
import 'dart:convert' as convert;
import '../../Common/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;
  bool _passwordVisible = false;
  bool showmobilenumberwidget = false;
  String? deviceId = Constants.prefs?.getString('deviceId');
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void initState() {
    _passwordVisible = true;
    super.initState();
  }

  String _dropDownValue = 'Owner';

  Future<void> doLogin() async {
    // print('login');
    if (formkey.currentState!.validate()) {
      //true
      setState(() {
        isloading = true;
        // ignore: avoid_print
        print(isloading);
      });
      Map<String, dynamic> bodyData = {
        'email': emailcontroller.text,
        'password': passwordcontroller.text,
        'device_id': deviceId.toString(),
        'platform_type': "android"
      };
      http.Response response = await http
          .post(Uri.parse("${Constants.baseurl}login"), body: bodyData);
      //   print(bodyData);
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
          //  print(result['data']['user_id']);
          Constants.prefs?.setString('user_id', result['data']['user_id']);
          Constants.prefs?.setString('user_type', result['data']['user_type']);
          Constants.prefs
              ?.setString('user_token', result['data']['user_token']);

          // print(result['data']['user_token']);

          if (result['data']['user_type'] == 'Owner') {
            if (result['data']['station_count'] == 0) {
              Fluttertoast.showToast(
                  // msg: jsonData['message'],
                  msg: "You have no petrol Station.Please add",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  webBgColor: "linear-gradient(to right, #6db000 #6db000)",
                  //  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddStationScreen()));
            } else if (result['data']['station_count'] > 0) {
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TabbarScreen()));
            }
          } else if (result['data']['user_type'] == 'Manager') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ManagerTabbarScreen()));
          } else if (result['data']['user_type'] == 'Transporter') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TransporterHomeScreen()));
          } else if (result['data']['user_type'] == 'Attendant') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AttenderTabbarScreen()));
          }
        } else if (result['status'] == 'error') {
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
          if (result['data']['mobile_verified'] == 0) {
            //  showmobilenumberwidget = true;
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => VerifyOtpScreen(
                        token: result['data']['token'],
                        mobile: result['data']['mobile'],
                        otp: result['data']['otp_code'])));
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => VerifyMobileOtp()));
          }
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign In',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address / Username',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF646464)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: emailcontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Enter Email Address / Username',
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
                            '${StringConstatnts.assets}mail.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        // RegExp emailValid = RegExp(
                        //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (value!.isEmpty) {
                          return 'Please enter Email Address or Login Id';
                        }
                        // else if (!emailValid.hasMatch(value)) {
                        //   return 'Please enter valid email address';
                        // }
                      },
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
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
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  'User Type',
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF646464)),
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.only(left: 14, right: 14, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border:
                      Border.all(color: Colors.grey, style: BorderStyle.solid),
                ),
                child: DropdownButton(
                  underline: SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  hint: Text(
                    _dropDownValue,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(color: Colors.blue),
                  items: ['Owner', 'Manager', 'Transporter'].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        _dropDownValue = val!;
                      },
                    );
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF0089D7)),
                      ),
                    ),
                    Spacer(),
                    _dropDownValue == 'Owner'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'First time on Eqwipetrol?',
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.appColor646464),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RegisteScreen(),
                                  ));
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Text(
                                    'Create an Account',
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.blackColor),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: isloading == false
                      ? ElevatedButton(
                          onPressed: () {
                            doLogin();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.blackColor,
                              fixedSize: Size(300, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48 / 2),
                              )),
                          child: Text(
                            'Login',
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
              // GestureDetector(
              //   onTap: () {
              //     if (email.text == 'owner' && password.text == '123') {
              //       Navigator.of(context).pushAndRemoveUntil(
              //           MaterialPageRoute(builder: (context) => TabbarScreen()),
              //           (Route<dynamic> route) => false);
              //     } else if (email.text == 'Manger' &&
              //         password.text == '123456') {
              //       Navigator.of(context).pushAndRemoveUntil(
              //           MaterialPageRoute(
              //               builder: (context) => ManagerTabbarScreen()),
              //           (Route<dynamic> route) => false);
              //     } else if (email.text == 'Trans' &&
              //         password.text == '123456789') {
              //       Navigator.of(context).pushAndRemoveUntil(
              //           MaterialPageRoute(
              //               builder: (context) => TranspoterHomeScreen()),
              //           (Route<dynamic> route) => false);
              //     }
              //   },
              //   child: Container(
              //     margin: EdgeInsets.only(left: 16, right: 16, top: 92),
              //     alignment: Alignment.center,
              //     height: 48,
              //     decoration: BoxDecoration(
              //       color: AppColor.blackColor,
              //       borderRadius: BorderRadius.circular(48 / 2),
              //     ),
              //     child: Text(
              //       'LOGIN',
              //       style: GoogleFonts.roboto(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w500,
              //           color: AppColor.whiteColor),
              //     ),
              //   ),
              // ),

              _dropDownValue == 'Owner'
                  ? Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 92),
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'OR Sign In with',
                            style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blackColor),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await AuthServices().signInWithGoogle();
                            },
                            // onTap: (){
                            //   // final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
                            //   // provider.googleLogin();
                            // },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          AppColor.blackColor.withOpacity(0.23),
                                      offset: Offset(0, 1),
                                      blurRadius: 15),
                                ],
                              ), //#
                              child: Padding(
                                padding: const EdgeInsets.all(11.25),
                                child: Image.asset(
                                    '${StringConstatnts.assets}google.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String userEmail = "";
}

// Container(
//   margin: EdgeInsets.only(left: 16, right: 16, top: 34),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'E-mail iD / User iD',
//         style: GoogleFonts.roboto(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: Color(0xFF646464)),
//       ),
//       SizedBox(
//         height: 8,
//       ),
//       Container(
//         height: 48,
//         decoration: BoxDecoration(
//           color: AppColor.whiteColor,
//           borderRadius: BorderRadius.circular(48 / 2),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColor.blackColor.withOpacity(0.23),
//                 offset: Offset(0, 1),
//                 blurRadius: 15),
//           ],
//         ), //#
//         child: TextFormField(
//           controller: emailcontroller,
//           decoration: InputDecoration(
//             hintText: 'E-mail iD / User iD',
//             hintStyle: GoogleFonts.roboto(
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               color: Color(0xFFA0A0A0),
//             ),
//             border: InputBorder.none,
//             prefixIcon: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Image.asset(
//                 '${StringConstatnts.assets}user_id.png',
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   ),
// ),
