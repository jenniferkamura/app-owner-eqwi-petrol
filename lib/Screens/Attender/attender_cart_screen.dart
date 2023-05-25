// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/delivery_type_popup.dart';
import 'package:owner_eqwi_petrol/Popup/update_cart_pop.dart';
import 'package:owner_eqwi_petrol/Screens/Attender/attender_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/change_address_screen.dart';
import '../../Common/common_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

class AttenderCartScreen extends StatefulWidget {
  final Function notificationsCountFun_value;
  const AttenderCartScreen(
      {super.key, required this.notificationsCountFun_value});

  @override
  State<AttenderCartScreen> createState() => _AttenderCartScreenState();
}

class _AttenderCartScreenState extends State<AttenderCartScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  bool isCartloader = false;
  int cartcount = 0;
  int total_amount = 0;
  String? shipping_charges;
  String? tax;
  int total_mrp = 0;
  String? currency;
  String? selectStationId;
  List<dynamic> cart_list = [];
  List cart_ids = [];
  int stationsCount = 0;
  List<dynamic> stations = [];
  List<dynamic> stationslist = [];
  bool isentercouponloader = false;
  String? couponDiscount = '0';
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController couponcontroller = TextEditingController();
  // String? selectStationId = Constants.prefs?.getString('selectStationId');
  bool isLoader = false;
  bool apirequest = false;
  void initState() {
    getcartList();
    getstationslist();
  }

  Future<void> getcartList() async {
    //  var type = 'current';
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'coupon_code': couponcontroller.text,
      //  'station_id': widget.station_id.toString(),
    };
    print(bodyData);
    setState(() {
      isCartloader = true;
    });
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "cart_list"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      cart_list.clear();
      //   print("print is.....${result['data']}");
      setState(() {
        isCartloader = false;
      });
      if (result['status'] == 'success') {
        print('valid');
        //  print(result['data'].length);
        if (result['data']['cart_data'] == null ||
            result['data']['cart_data'] == '' ||
            result['data']['cart_data'].length == 0) {
        } else {
          setState(() {
            cart_list = result['data']['cart_data'];
            total_mrp = result['data']['amount'];
            shipping_charges = result['data']['shipping_charge'];
            tax = result['data']['tax'];
            total_amount = result['data']['total_amount'];
            currency = result['data']['currency'];
            couponDiscount = result['data']['discount'].toString();
            cartcount = cart_list.length;
          });
          for (var i = 0; i < cart_list.length; i++) {
            cart_ids.add(cart_list[i]['cart_id']);
          }
          print('cart_id');
          print(cart_ids);
        }
      } else {
        setState(() {
          cartcount = 0;
        });

        print(cartcount);
      }
    }
  }

  var selectedData;
  Future<void> getstationslist() async {
    stationslist.clear();
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "stations"), body: bodyData);
    print('body data');
    print(bodyData);
    print('isloader: $isLoader');
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      print(result);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        if (result['data'] == null ||
            result['data'] == '' ||
            result['data'].length == 0) {
          stationslist.clear();
        } else {
          stationslist.clear();
          setState(() {
            stationslist = result['data'];
            selectStationId = stationslist[0]['station_id'];
            selectedData = stationslist[0];

            print(stationslist);
            stationsCount = result['data'].length;
            //   managersCount = result['data']['total_records_count'];
          });
          print('selectedData');
          print(selectedData);
        }
      } else if (result['status'] == 'error') {
        setState(() {
          stationsCount = 0;
        });
      }
    }
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => AttenderTabbarScreen()));
    //Get.back();
    return Future.value(false);
  }

  Future<void> deleteItemFromCart(cart_id) async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token,
      'cart_id': cart_id.toString(),
    };
    print(bodyData);
    setState(() {
      isCartloader = true;
    });
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "delete_cart"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array
      print(result);
      if (result['status'] == 'success') {
        // reidrect to login Page
        setState(() {
          isCartloader = false;
        });
        Navigator.of(context).pop();
        getcartList();
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        appBar: AppBarCustom.commonAppBarCustom(context, title: 'Cart ',
            onTaped: () {
          onWillPop();
        }),
        body: isCartloader == false
            ? ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  cartcount != 0
                      ? Column(
                          children: [
                            stationsCount != 0
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: 12, left: 16, right: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            '${StringConstatnts.assets}room_black_24dp 1.png'),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Deliver: ' +
                                                selectedData['station_name'] +
                                                ',' +
                                                selectedData['contact_person'] +
                                                ',' +
                                                selectedData['address'] +
                                                ',' +
                                                selectedData['pincode'] +
                                                ',' +
                                                selectedData['state'] +
                                                ',' +
                                                selectedData['city'],
                                            style: GoogleFonts.roboto(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.blackColor),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            var selectedstation =
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeAddressScreen(
                                                      notificationsCountFun_value:
                                                          () => widget
                                                              .notificationsCountFun_value()),
                                            ));
                                            print('coupon applied');
                                            print(selectedstation);
                                            if (selectedstation['station_id'] !=
                                                null) {
                                              setState(() {
                                                selectedData = selectedstation;
                                                selectStationId =
                                                    selectedstation[
                                                        'station_id'];
                                              });
                                            }
                                            print(selectStationId);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 60,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: AppColor.appThemeColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'Change',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.whiteColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height: 50,
                                      child: Text(
                                          'No Stations Found.Please add stations'),
                                    ),
                                  ),
                          ],
                        )
                      : Container(
                          height: 10,
                        ),
                  SizedBox(
                    height: 11,
                  ),
                  cartcount != 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cart_list.length,
                          itemBuilder: (context, index) =>
                              carCardDesign(cart_list[index]))
                      : emptycart(),
                  if (cartcount != 0) _applycoupon(),
                  cartcount != 0
                      ? Container(
                          margin: EdgeInsets.only(bottom: 22),
                          color: Colors.white,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 17, left: 16, right: 16, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Summery',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total MRP',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8F8F8F)),
                                    ),
                                    Spacer(),
                                    Text(
                                      currency.toString() +
                                          ' ' +
                                          total_mrp.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Shipping Charges',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8F8F8F)),
                                    ),
                                    Spacer(),
                                    Text(
                                      currency.toString() +
                                          ' ' +
                                          shipping_charges.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Tax',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8F8F8F)),
                                    ),
                                    Spacer(),
                                    Text(
                                      currency.toString() +
                                          ' ' +
                                          tax.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                if (couponDiscount != '0')
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Coupon Discount',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF8F8F8F)),
                                      ),
                                      Spacer(),
                                      Text(
                                        '- ' +
                                            currency.toString() +
                                            ' ' +
                                            couponDiscount.toString(),
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.blackColor),
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  height: 1,
                                  color: Color(0xFFD1D1D1),
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Final Payable',
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    Spacer(),
                                    Text(
                                      currency.toString() +
                                          ' ' +
                                          total_amount.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 11,
                        ),
                  SizedBox(
                    height: 11,
                  ),
                  cartcount != 0
                      ? Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, -4),
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 48,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Payable Amount',
                                      style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      currency.toString() +
                                          ' ' +
                                          total_amount.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DeliveryTypePopup(
                                            selectStationId: selectStationId,
                                            coupon_code: couponcontroller.text);
                                      });
                                },
                                child: Container(
                                  color: Colors.black,
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 48,
                                  child: Text(
                                    'Raise order'.toUpperCase(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 30,
                        ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              )
            : Center(
                child: Container(
                  child: CircularProgressIndicator(
                      color: AppColor.appThemeColor, strokeWidth: 3),
                ),
              ),
      ),
    );
  }

  Widget emptycart() {
    return Container(
      child: Center(
        child: Column(
          children: [
            Image.asset('${StringConstatnts.assets}emptycart.png'),
            Text(
              'No Items Found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Mulish semibold',
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget carCardDesign(data) {
    return Container(
      margin: EdgeInsets.only(bottom: 11),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 133,
              width: 84,
              decoration: BoxDecoration(
                  color: Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 46.0, left: 22, right: 22, bottom: 46),
                child: Image.network(
                  data['image_path'].toString(),
                ),
              ),
            ),
            SizedBox(
              width: 9,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product:',
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF929292)),
                    ),
                    SizedBox(
                      width: 130,
                    ),
                    Text(
                      'Delete',
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8D8D8D)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        deleteFunction(context, data['cart_id']);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Text.rich(
                  TextSpan(
                    text: data['name'],
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF161614)),
                    children: <InlineSpan>[
                      TextSpan(
                        //  text: ' (\$ 110 / Litr)',
                        text: ' (' +
                            data['currency'] +
                            ' ' +
                            data['price'] +
                            ' / ' +
                            data['measurement'] +
                            ')',
                        style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8C8C8C)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  'Order Quantity : ',
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF929292)),
                ),
                SizedBox(
                  height: 5,
                ),
                Text.rich(
                  TextSpan(
                    text: data['qty'] + ' ' + data['measurement'],
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF161614)),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  'Total Price : ',
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF929292)),
                ),
                SizedBox(
                  height: 5,
                ),
                Text.rich(
                  TextSpan(
                    text: data['currency'] + ' ' + data['total_price'],
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF161614)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product:',
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF929292)),
                        ),
                        Text.rich(
                          TextSpan(
                            text: data['currency'] + ' ' + data['price'],
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF161614)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return UpdateCartPopup(
                                  cartId: data['cart_id'].toString(),
                                  categoryId: data['category_id'].toString(),
                                  notificationsCountFun_value: () =>
                                      widget.notificationsCountFun_value());
                            });
                      },
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Enter Quantity',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8D8D8D)),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            height: 30,
                            width: 85,
                            padding: EdgeInsets.only(top: 5, left: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: Text(data['qty']),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void deleteFunction(context, cart_id) {
    print(cart_id);
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
                title: Text('Are you sure do you want delete?',
                    style: GoogleFonts.baloo2(
                        textStyle: Theme.of(context).textTheme.displayMedium,
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        deleteItemFromCart(cart_id);
                      },
                      child: Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No'),
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

  Widget _applycoupon() {
    return Container(
      color: Colors.white,
      // height: 100,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Form(
              key: formkey,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: couponcontroller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Coupon Code',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Coupon code';
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Container(
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    applyenterCouponbtn();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.appThemeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: AppColor.appThemeColor)),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Center(
                    child: Text(
                      'APPLY',
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> applyenterCouponbtn() async {
    if (formkey.currentState!.validate()) {
      Map<String, dynamic> bodyData = {
        'user_token': user_token.toString(),
        'coupon_code': couponcontroller.text,
        'amount': total_mrp.toString()
      };
      print(bodyData);
      setState(() {
        isentercouponloader = true;
      });
      http.Response response = await http
          .post(Uri.parse(Constants.baseurl + "verify_coupon"), body: bodyData);

      if (response.statusCode == 200) {
        var result = convert.jsonDecode(response.body);
        print("print is.....${result}");
        setState(() {
          isentercouponloader = false;
        });
        if (result['status'] == 'success') {
          getcartList();
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
