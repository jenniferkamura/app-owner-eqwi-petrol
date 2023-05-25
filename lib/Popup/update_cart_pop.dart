// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/cart_screen.dart';

import '../Common/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UpdateCartPopup extends StatefulWidget {
  String cartId;
  String categoryId;
  final Function notificationsCountFun_value;
  UpdateCartPopup(
      {Key? key,
      required this.cartId,
      required this.categoryId,
      required this.notificationsCountFun_value})
      : super(key: key);

  @override
  State<UpdateCartPopup> createState() => _UpdateCartPopupState();
}

class _UpdateCartPopupState extends State<UpdateCartPopup> {
  bool isdetailLoader = false;
  bool isloading = false;

  String? user_token = Constants.prefs?.getString('user_token');

  String? productName;
  String? productType;
  String? productMeasurement;
  String? productCurrency;
  String? productPrice;
  String? totalPrice;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController quantitycontroller = TextEditingController();
  void initState() {
    print('user_token');
    print(user_token);
    checkProduct();
    print(widget.cartId);
  }

  Future<void> checkProduct() async {
    setState(() {
      isdetailLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'category_id': widget.categoryId,
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "check_product"), body: bodyData);

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
        totalPrice = result['data']['total_price'];
        quantitycontroller.text = result['data']['qty'];
        print(quantitycontroller.text);
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
        .post(Uri.parse(Constants.baseurl + "get_product"), body: bodyData);

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
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> productupdatetocart() async {
    if (formkey.currentState!.validate()) {
      //true
      setState(() {
        isloading = true;
        // ignore: avoid_print
        print(isloading);
      });
      Map<String, dynamic> bodyData = {
        'quantity': quantitycontroller.text,
        'user_token': user_token.toString(),
        'cart_id': widget.cartId.toString()
      };
      http.Response response = await http
          .post(Uri.parse(Constants.baseurl + "update_cart"), body: bodyData);
      print(bodyData);

      if (response.statusCode == 200) {
        var result = convert.jsonDecode(response.body);
        // dart array
        setState(() {
          isloading = false;
          // ignore: avoid_print
        });
        print(result);
        if (result['status'] == 'success') {
          // reidrect to login Page
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
          // Navigator.pop(context);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CartScreen(
                      notificationsCountFun_value: () =>
                          widget.notificationsCountFun_value())));
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
      backgroundColor: Colors.transparent,
      body: Form(
        key: formkey,
        child: Container(
          height: 322,
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
                      'Update Cart',
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
                                height: 32,
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
                                    print(text);
                                    int val = int.parse(text);
                                    print(productPrice);
                                    setState(() {
                                      var test = val *
                                          int.parse(productPrice
                                              .toString()
                                              .split('.')[0]);
                                      print(test);
                                      totalPrice = test.toString();
                                      print(productPrice);
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
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              Text(
                                totalPrice.toString(),
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
                                      productupdatetocart();
                                    },
                                    child: Text(
                                      'UPDATE CART',
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
