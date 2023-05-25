// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Global/Global.dart';
import 'package:owner_eqwi_petrol/Screens/Attender/attender_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/requested_by_manager_order_screen.dart';
import 'package:owner_eqwi_petrol/widget/Owner/pending_order_card_design.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Common/constants.dart';
import '../Owner/processing_order_detail_screen.dart';

class AttenderOrderScreen extends StatefulWidget {
  bool isHomeScreen;
  AttenderOrderScreen({super.key, required this.isHomeScreen});

  @override
  State<AttenderOrderScreen> createState() => _AttenderOrderScreenState();
}

class _AttenderOrderScreenState extends State<AttenderOrderScreen> {
  int indexSelected = 0;
  String? user_token = Constants.prefs?.getString('user_token');
  List<String> nameType = [
    'Pending',
    'Processing',
    'Delivered',
    'Completed',
    'Cancelled'
  ];
  bool isRequestedByManger = false;
  bool isLoader = false;
  List orders = [];
  int ordersCount = 0;
  void initState() {
    print(nameType[indexSelected]);
    getorderslist(nameType[indexSelected]);
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
    // Get.back();
    return Future.value(false);
  }

  Future<void> getorderslist(type) async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_status': type.toString(),
      //'page': '1'
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "order_list"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      print(result);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        orders.clear();
        setState(() {
          ordersCount = result['data']['total_records_count'];
          orders = result['data']['result'];
        });
        print(ordersCount);
        print(orders);
        // });
      } else if (result['status'] == 'error') {
        orders.clear();
        setState(() {
          ordersCount = 0;
        });
        print(ordersCount);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context, title: 'My Orders',
            onTaped: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AttenderTabbarScreen()));
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 37,
                  margin: EdgeInsets.only(left: 17, top: 19),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: nameType.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            indexSelected = index;
                          });
                          if (nameType[indexSelected] == 'Pending') {
                            getorderslist('Pending');
                          } else if (nameType[indexSelected] == 'Processing') {
                            getorderslist('Processing');
                          } else if (nameType[indexSelected] == 'Delivered') {
                            getorderslist('Delivered');
                          } else if (nameType[indexSelected] == 'Completed') {
                            getorderslist('Completed');
                          } else if (nameType[indexSelected] == 'Cancelled') {
                            getorderslist('Cancelled');
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 9),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 23, right: 23, top: 8, bottom: 8),
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                nameType[index],
                                style: GoogleFonts.roboto(
                                    color: indexSelected == index
                                        ? AppColor.whiteColor
                                        : Color(0xFF727272),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF8B8B8B)),
                                color: indexSelected == index
                                    ? AppColor.appThemeColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(17))),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                isLoader == false
                    ? Container(
                        child: (ordersCount != 0)
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: orders.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => orderstablist(
                                  nameType[indexSelected],
                                  orders[index],
                                ),
                              )
                            : Center(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          '${StringConstatnts.assets}nodata.png'),
                                      Text(
                                        'No orders found',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      )
                    : Center(
                        child: Container(
                          child: CircularProgressIndicator(
                              color: AppColor.appThemeColor, strokeWidth: 3),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orderstablist(name, data) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 20, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFFD4D4D4),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 11, right: 10, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Order ID:  ',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFA0A0A0)),
                        children: <InlineSpan>[
                          TextSpan(
                            text: data['order_id'],
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blackColor),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        if (name.toString() == 'Processing')
                          GestureDetector(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => OrderSummaryScreen(
                              //     name: 'Processing',
                              //     order_id: data['id'],
                              //   ),
                              // ));
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProcessingOrderDetailScreen(
                                        order_id: data['id']),
                              ));
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          AppColor.blackColor.withOpacity(0.25),
                                      offset: Offset(0, 2),
                                      blurRadius: 4),
                                ],
                              ), //#
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                    '${StringConstatnts.assets}truck.png'),
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            if (name == 'Processing') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderSummaryScreen(
                                  name: 'Processing',
                                  order_id: data['id'],
                                ),
                              ));
                            } else if (name == 'Pending') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderSummaryScreen(
                                    name: 'Pending', order_id: data['id']),
                              ));
                            } else if (name == 'Completed') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderSummaryScreen(
                                  name: 'Completed',
                                  order_id: data['id'],
                                ),
                              ));
                            }
                          },
                          child: Container(
                            height: 24,
                            width: 24,

                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(24 / 2),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColor.blackColor.withOpacity(0.25),
                                    offset: Offset(0, 2),
                                    blurRadius: 4),
                              ],
                            ), //#
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Image.asset(
                                  '${StringConstatnts.assets}right.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      data['delivery_date'],
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF929292)),
                    ),
                    Spacer(),
                    Text(
                      name == 'Delivered' ? '' : 'Requested By:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF929292)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    // Text(
                    //   'Petrol (Pms)',
                    //   style: GoogleFonts.roboto(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //     color: Color(0xFF5C5C5C),
                    //   ),
                    // ),
                    Spacer(),
                    Text(
                      name == 'Delivered'
                          ? ''
                          : data['contact_person'] + ',' + data['station_name'],
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5C5C5C),
                      ),
                    ),
                  ],
                ),
                if (name == 'Delivered')
                  SizedBox(
                    height: 8,
                  ),
                if (name == 'Delivered')
                  Row(
                    children: [
                      // Text.rich(
                      //   TextSpan(
                      //     text: 'Quantity: ',
                      //     style: GoogleFonts.roboto(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w400,
                      //         color: Color(0xFFA0A0A0)),
                      //     children: <InlineSpan>[
                      //       TextSpan(
                      //         text: '2,000 Ltr',
                      //         style: GoogleFonts.roboto(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w500,
                      //             color: AppColor.blackColor),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          text: 'Total Amount: ',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA0A0A0)),
                          children: <InlineSpan>[
                            TextSpan(
                              text:
                                  data['currency'] + ' ' + data['total_amount'],
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color(0xFFDBDBDB),
          ),
          //   if (name == 'Pending' || accountName == 'Manager')
          if (name == 'Pending')
            Container(
              margin: EdgeInsets.only(
                  top: 10,
                  left: 11,
                  right: 10,
                  bottom: name == 'Processing' ? 0 : 10),
              child: Row(
                children: [
                  // Text.rich(
                  //   TextSpan(
                  //     text: 'Quantity: ',
                  //     style: GoogleFonts.roboto(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w400,
                  //         color: Color(0xFFA0A0A0)),
                  //     children: <InlineSpan>[
                  //       TextSpan(
                  //         text: '2,000 Ltr',
                  //         style: GoogleFonts.roboto(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //             color: AppColor.blackColor),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Spacer(),
                  Text.rich(
                    TextSpan(
                      text: 'Total Amount: ',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA0A0A0)),
                      children: <InlineSpan>[
                        TextSpan(
                          text: data['currency'] + ' ' + data['total_amount'],
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.blackColor),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (name == 'Processing')
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 8, left: 11, right: 10, bottom: 10),
              child: Text.rich(
                TextSpan(
                  text: 'Payment Term: ',
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA0A0A0)),
                  children: <InlineSpan>[
                    TextSpan(
                      text: data['payment_type'],
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    )
                  ],
                ),
              ),
            ),
          if (name == 'Completed')
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 8, left: 11, right: 10, bottom: 10),
              child: Row(children: [
                Text.rich(
                  TextSpan(
                    text: 'Rating',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA0A0A0)),
                  ),
                ),
                RatingBar.builder(
                  itemSize: 16,
                  initialRating: data['rating'] == null
                      ? double.parse("0")
                      : double.parse(data['rating']),
                  minRating: data['rating'] == null
                      ? double.parse("0")
                      : double.parse(data['rating']),
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  tapOnlyMode: false,
                  updateOnDrag: false,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    //  print(rating);
                  },
                ),
                Spacer(),
                if (data['rating'] == null)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderSummaryScreen(
                            name: 'Write A Review', order_id: data['id']),
                      ));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) =>
                      //       OrderSummaryScreen(name: 'Write A Review'),
                      // ));
                    },
                    child: Container(
                      child: Text.rich(
                        TextSpan(
                          text: 'Write a review',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF89A619)),
                        ),
                      ),
                    ),
                  ),
              ]),
            ),
        ],
      ),
    );
  }
}


//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   height: 37,
//                   margin: EdgeInsets.only(left: 17, top: 19),
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: nameType.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             indexSelected = index;
//                           });
//                         },
//                         child: Container(
//                             margin: EdgeInsets.only(right: 9),
//                             alignment: Alignment.center,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 23, right: 23, top: 8, bottom: 8),
//                               child: Text(
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.center,
//                                 nameType[index],
//                                 style: GoogleFonts.roboto(
//                                     color: indexSelected == index
//                                         ? AppColor.whiteColor
//                                         : Color(0xFF727272),
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14),
//                               ),
//                             ),
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Color(0xFF8B8B8B)),
//                                 color: indexSelected == index
//                                     ? AppColor.appThemeColor
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(17))),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 ListView.builder(
//                   itemCount: indexSelected == 0
//                       ? 10
//                       : indexSelected == 1
//                           ? 1
//                           : 3,
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) => indexSelected == 3
//                       ? Container()
//                       : PendingOrderCardDesign(
//                           name: nameType[indexSelected],
//                           accountName: 'Manager'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
