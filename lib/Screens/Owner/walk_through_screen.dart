// ignore_for_file: prefer_const_constructors

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/login_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import '../../modals/onboarding.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({super.key});

  @override
  State<WalkThroughScreen> createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  List<Onboardinglist> sliders = [];
  var index = 0;
  bool loader = false;
  var currentBackPressTime;
  // get currentBackPressTime => null;
  @override
  void initState() {
    // data_load = false;
    getIntroSlides();
    //  introslider = true;
    Constants.prefs?.setString('introslider', 'true');
    super.initState();
  }

  Future<void> getIntroSlides() async {
    // dynamic sliders = [];
    // Map<String, dynamic> bodyData = {'user_access_token': token};
    setState(() {
      loader = true;
    });
    http.Response response =
        await http.get(Uri.parse("${Constants.baseurl}boarding_slider"));
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        loader = false;
      });
      if (result['status'] == 'success') {
        //print(result);
        result['data'].forEach((element) {
          setState(() {
            sliders.add(Onboardinglist.fromJson(element));
            //   print(result);
          });
          //  print(sliders);
        });
      } else {
        // ignore: use_build_context_synchronously
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  List<String> onBoringImage = [
    "${StringConstatnts.assets}onboard_image.png",
    "${StringConstatnts.assets}onboard_image1.png",
  ];
  List<String> onBordingText = [
    "We are happily saying we are awesome.",
    "We provide you with good standard Fuel.",
  ];
  List<String> onBordingText0 = [
    "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Morbi tincidunt auctor ",
    "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Morbi tincidunt auctor ",
  ];

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Tap back again to leave');

      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: loader == false
            ? ListView(
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(top: 16, right: 16),
                  //   alignment: Alignment.topRight,
                  //   child: Text(
                  //     index == 0 ? 'SKIP' : '',
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.roboto(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.black),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1,
                        left: 13,
                        right: 13),
                    height: 225,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        if (mounted) {
                          setState(() {
                            index = value;
                          });
                        }
                      },
                      itemCount: sliders.length,
                      itemBuilder: ((context, index) {
                        return ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: sliders[index].imagePath.toString(),
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      value: downloadProgress.progress)),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/onboard_image.png',
                            ),
                          ),
                        );
                        // return Image.asset(
                        //   // onBoringImage[index],
                        //   fit: BoxFit.contain,
                        // );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      sliders[index].title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 13),
                    alignment: Alignment.center,
                    child: Text(
                      sliders[index].description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF5A5A5A)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DotsIndicator(
                    dotsCount: sliders.length,
                    position: index.toDouble(),
                    decorator: DotsDecorator(
                      size: const Size.square(5.0),
                      activeSize: const Size(8, 8),
                      activeColor: AppColor.appThemeColor,
                      color: Color(0xFFAEAEAE),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.blackColor,
                        borderRadius: BorderRadius.circular(48 / 2),
                      ),
                      child: Text(
                        'LOGIN',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisteScreen(),
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 24),
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: Offset(0, 1),
                              blurRadius: 4.0),
                        ],
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(48 / 2),
                        border: Border.all(color: Color(0xFFCACACA), width: 1),
                      ),
                      child: Text(
                        'Register'.toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.blackColor),
                      ),
                    ),
                  )
                ],
              )
            : Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: AppColor.appThemeColor, strokeWidth: 3),
                ),
              ),
      ),
    );
  }
}
