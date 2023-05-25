// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/forgot_password_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/verify_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Common/common_widgets/common_text_field_widget.dart';
import '../../Common/constants.dart';
import 'dart:convert' as convert;

class RegisteScreen extends StatefulWidget {
  const RegisteScreen({super.key});

  @override
  State<RegisteScreen> createState() => _RegisteScreenState();
}

class _RegisteScreenState extends State<RegisteScreen> {
  int letterCount = 0;
  bool isloading = false;
  bool _passwordVisible = false;
  bool _cpasswordVisible = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  //TextEditingController vehicletypecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController loginidcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    _cpasswordVisible = true;
  }

  Future<void> doRegister() async {
    if (passwordcontroller.text != confirmpasswordcontroller.text) {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Password Does not match",
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
          'name': namecontroller.text,
          'email': emailcontroller.text,
          'password': passwordcontroller.text,
          'confirm_password': confirmpasswordcontroller.text,
          'mobile': mobilecontroller.text,
          'login_id': loginidcontroller.text,
          'address': addresscontroller.text,
        };
        http.Response response = await http
            .post(Uri.parse("${Constants.baseurl}signup"), body: bodyData);

        if (response.statusCode == 200) {
          var result = convert.jsonDecode(response.body);
          // dart array
          setState(() {
            isloading = false;
            // ignore: avoid_print
            print(isloading);
          });
          if (result['status'] == 'success') {
            // reidrect to login Page
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => VerifyOtpScreen(
                        token: result['data']['user_token'],
                        mobile: result['data']['mobile'],
                        otp: result['data']['otp_code'])));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leadingWidth: 50,
        backgroundColor: AppColor.appThemeColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Register',
          style:
              CustomTextWhiteStyle.textStyleWhite(context, 18, FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Form(
            key: formkey,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF646464)),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: namecontroller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z-,]+(\s{0,1}[a-zA-Z-, ])*$')),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
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
                              '${StringConstatnts.assets}user_id.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          } else if (value.length < 3) {
                            return 'minimum 3 letters';
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
                        'Email Address',
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
                          hintText: 'Enter Email Address',
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
                          RegExp emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (value!.isEmpty) {
                            return 'Please enter email id';
                          } else if (!emailValid.hasMatch(value)) {
                            return 'Please enter valid email address';
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
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
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
                          hintText: 'Confirm Password',
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
                              _cpasswordVisible
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
                        'Username',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF646464)),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: loginidcontroller,
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                          // FilteringTextInputFormatter.allow(
                          //     RegExp(r'^\w[a-zA-Z@#0-9.]*$')),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter Username',
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
                              '${StringConstatnts.assets}user_id.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Login ID';
                          } else if (value.length < 5) {
                            return 'minimum 5 letters';
                          } else if (value.contains(' ')) {
                            return 'Username cannot contains spaces';
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
                        'Address',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF646464)),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        maxLines: 4,
                        controller: addresscontroller,
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Enter Address',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20 / 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20 / 1)),
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFA0A0A0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Address';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: 16, right: 16, top: 82, bottom: 40),
                    child: isloading == false
                        ? ElevatedButton(
                            onPressed: () {
                              doRegister();
                            },
                            child: Text(
                              'CREATE ACCOUNT',
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
            )),
      ),
    );
  }

  void registerFunction(context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Your are register successfully.Please login',
                    style: GoogleFonts.baloo2(
                        textStyle: Theme.of(context).textTheme.displayMedium,
                        color: AppColor.appThemeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()));
                      },
                      child: Text('ok'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox(
            height: 0,
            width: 0,
          );
        });
  }
}




      // Container(
      //           margin: EdgeInsets.only(left: 16, right: 16, top: 24),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 'Phone Number',
      //                 style: GoogleFonts.roboto(
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w400,
      //                     color: Color(0xFF646464)),
      //               ),
      //               SizedBox(
      //                 height: 8,
      //               ),
      //               Container(
      //                 height: 48,
      //                 decoration: BoxDecoration(
      //                   color: AppColor.whiteColor,
      //                   borderRadius: BorderRadius.circular(48 / 2),
      //                   boxShadow: [
      //                     BoxShadow(
      //                         color: AppColor.blackColor.withOpacity(0.23),
      //                         offset: Offset(0, 1),
      //                         blurRadius: 15),
      //                   ],
      //                 ), //#
      //                 child: TextField(
      //                   decoration: InputDecoration(
      //                     hintText: 'Enter Phone Number',
      //                     hintStyle: GoogleFonts.roboto(
      //                       fontSize: 14,
      //                       fontWeight: FontWeight.w400,
      //                       color: Color(0xFFA0A0A0),
      //                     ),
      //                     border: InputBorder.none,
      //                     prefixIcon: Padding(
      //                       padding: const EdgeInsets.all(10.0),
      //                       child: Image.asset(
      //                         '${StringConstatnts.assets}mobile.png',
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),


          // GestureDetector(
          //       onTap: () {
          //         Navigator.of(context).pushAndRemoveUntil(
          //             MaterialPageRoute(builder: (context) => LoginScreen()),
          //             (Route<dynamic> route) => false);
          //       },
          //       child: Container(
          //         margin: EdgeInsets.only(left: 16, right: 16, top: 82),
          //         alignment: Alignment.center,
          //         height: 48,
          //         decoration: BoxDecoration(
          //           color: AppColor.blackColor,
          //           borderRadius: BorderRadius.circular(48 / 2),
          //         ),
          //         child: Text(
          //           'create account'.toUpperCase(),
          //           style: GoogleFonts.roboto(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w500,
          //               color: AppColor.whiteColor),
          //         ),
          //       ),
          //     ),