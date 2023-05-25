// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

import '../Common/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// ignore: must_be_immutable
class AddCartPopup extends StatefulWidget {
  String categoryId;
  final Function cartCount;
  AddCartPopup({Key? key, required this.categoryId, required this.cartCount})
      : super(key: key);

  @override
  State<AddCartPopup> createState() => _AddCartPopupState();
}

class cartController extends GetxController {
  RxBool isloading = false.obs;
  final Rx<String> _cartCount = "0".obs;

  gethomecartData() async {
    isloading.value = true;
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    http.Response response =
        await http.post(Uri.parse("${Constants.baseurl}home"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      if (result['status'] == 'success') {
        _cartCount.value = result['data']['cart_count'].toString();
      }
      // print('cartCount : $cartCount');
    }
    isloading.value = false;
  }

  String get getcartCount => _cartCount.value;
}

class _AddCartPopupState extends State<AddCartPopup> {
  bool isdetailLoader = false;
  bool isloading = false;

  String? user_token = Constants.prefs?.getString('user_token');

  String? productName;
  String? productType;
  String? productMeasurement;
  String? productCurrency;
  String? productPrice;
  String? totalPrice;
  // String? cartCount = '0';
  String? notificationCount;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController quantitycontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkProduct();
    print(widget.cartCount);
  }

  Future<void> productAddtocart() async {
    if (formkey.currentState!.validate()) {
      //true
      setState(() {
        isloading = true;
        // ignore: avoid_print
        // print(isloading);
      });
      Map<String, dynamic> bodyData = {
        'quantity': quantitycontroller.text,
        'user_token': user_token.toString(),
        'category_id': widget.categoryId.toString()
      };
      http.Response response = await http
          .post(Uri.parse("${Constants.baseurl}add_to_cart"), body: bodyData);
      // print(bodyData);

      if (response.statusCode == 200) {
        var result = convert.jsonDecode(response.body);
        // dart array
        setState(() {
          isloading = false;
          // ignore: avoid_print
        });
        //  print(result);
        if (result['status'] == 'success') {
          widget.cartCount();
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
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
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

  Future<void> checkProduct() async {
    setState(() {
      isdetailLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'category_id': widget.categoryId,
    };
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}check_product"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      setState(() {
        isdetailLoader = false;
      });
      //print(result);
      if (result['status'] == 'success') {
        productName = result['data']['name'];
        productType = result['data']['type'];
        productMeasurement = result['data']['measurement'];
        productCurrency = result['data']['currency'];
        productPrice = result['data']['price'];
        totalPrice = result['data']['total_price'];
        quantitycontroller.text = result['data']['qty'];
        //  print(quantitycontroller.text);
      } else if (result['status'] == 'error') {
        getProductdetail();
        // Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> getProductdetail() async {
    setState(() {
      isdetailLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'category_id': widget.categoryId,
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}get_product"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      setState(() {
        isdetailLoader = false;
      });
      print(result);
      if (result['status'] == 'success') {
        print(result);
        productName = result['data']['name'];
        productType = result['data']['type'];
        productMeasurement = result['data']['measurement'];
        productCurrency = result['data']['currency'];
        productPrice = result['data']['price'];
        totalPrice = '0';
      } else {
        // ignore: use_build_context_synchronously
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  // Future<void> gethomecartData() async {
  //   Map<String, dynamic> bodyData = {
  //     'user_token': user_token.toString(),
  //   };
  //   print('gethomecartData');
  //   print(bodyData);
  //   http.Response response =
  //       await http.post(Uri.parse(Constants.baseurl + "home"), body: bodyData);

  //   if (response.statusCode == 200) {
  //     var result = convert.jsonDecode(response.body);
  //     print("print is.....${result}");

  //     if (result['status'] == 'success') {
  //       cartCount = result['data']['cart_count'].toString();
  //       notificationCount = result['data']['unread_notifications'].toString();
  //     }
  //     print('cartCount : $cartCount');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        key: formkey,
        child: Container(
          height: 370,
          margin: EdgeInsets.only(left: 16, right: 16, top: 80),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF89A619),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      'Add to cart',
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColor.whiteColor),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        '${StringConstatnts.assets}wrong.png',
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 11,
                    )
                  ],
                ),
              ),
              isdetailLoader == false
                  ? Column(
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          productName.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                          // height: 55,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Quantity',
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF646464)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                child: TextFormField(
                                  controller: quantitycontroller,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                  ],
                                  onChanged: (text) {
                                    int val = int.parse(text);
                                    setState(() {
                                      // if (quantitycontroller.text.isEmpty) {
                                      //   print('place');
                                      //    totalPrice = productPrice.toString();
                                      // } else {
                                      var test = val *
                                          int.parse(productPrice
                                              .toString()
                                              .split('.')[0]);
                                      print(test);
                                      totalPrice = test.toString();
                                      print(totalPrice);
                                      //}
                                      //  print(phonecontroller.text.length);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: '1000 ltrs',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 5.0, 20.0, 5.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    hintStyle: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFA0A0A0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your quantity';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   height: 55,
                        //   alignment: Alignment.topLeft,
                        //   margin: EdgeInsets.only(left: 20, right: 20),
                        //   child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           'Enter Quantity',
                        //           style: GoogleFonts.roboto(
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.w400,
                        //               color: AppColor.blackColor),
                        //         ),
                        //         Spacer(),
                        //         Container(
                        //           height: 32,
                        //           decoration: BoxDecoration(
                        //             border: Border.all(
                        //               color: Color(0xFFB7B7B7),
                        //             ),
                        //           ),
                        //           child: Padding(
                        //             padding: EdgeInsets.only(left: 16.0, top: 14),
                        //             child: TextFormField(
                        //               keyboardType: TextInputType.number,
                        //               controller: quantitycontroller,
                        //               autovalidateMode:
                        //                   AutovalidateMode.onUserInteraction,
                        //               decoration: InputDecoration(
                        //                 hintText: '1000 Ltr',
                        //                 border: InputBorder.none,
                        //                 hintStyle: TextStyle(color: Colors.black),
                        //               ),
                        //               validator: (value) {
                        //                 if (value!.isEmpty) {
                        //                   return 'Please enter your quantity';
                        //                 }
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       ]),
                        // ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          height: 58,
                          decoration: BoxDecoration(
                            color: Color(0xFF89A619),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    productName.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.whiteColor),
                                  ),
                                  Text(
                                    productMeasurement.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.whiteColor),
                                  ),
                                ],
                              ),
                              totalPrice != '0'
                                  ? Text(
                                      totalPrice.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.whiteColor),
                                    )
                                  : Text(
                                      productPrice.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.whiteColor),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: 16, right: 16, top: 22, bottom: 10),
                            child: isloading == false
                                ? ElevatedButton(
                                    onPressed: () {
                                      productAddtocart();
                                    },
                                    child: totalPrice != '0'
                                        ? Text(
                                            'ADD TO CART',
                                            style: TextStyle(
                                                fontFamily: "ROBOTO",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Text(
                                            'ADD TO CART',
                                            style: TextStyle(
                                                fontFamily: "ROBOTO",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.blackColor,
                                        fixedSize: Size(300, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(48 / 2),
                                        )),
                                  )
                                : ElevatedButton(
                                    onPressed: () {},
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.blackColor,
                                        fixedSize: Size(300, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(48 / 2),
                                        )),
                                  )),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        Center(
                          child: Container(
                            child: CircularProgressIndicator(
                                color: AppColor.appThemeColor, strokeWidth: 3),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
