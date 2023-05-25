// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loadmore/loadmore.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/processing_order_detail_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/requested_by_attender_order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/requested_by_manager_order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Common/common_widgets/common_text_field_widget.dart';

// ignore: must_be_immutable
class OrderScreen extends StatefulWidget {
  bool isHomeScreen;
  OrderScreen({super.key, required this.isHomeScreen});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int indexSelected = 0;
  // ignore: non_constant_identifier_names
  String? user_token = Constants.prefs?.getString('user_token');
  List<String> nameType = [
    'Pending',
    'Processing',
    // 'Delivered',
    'Completed',
    'Cancelled'
  ];
  bool isRequestedByManger = false;
  bool isLoader = false;
  List<dynamic> orders = [];
  List requestorders = [];
  int requestordersCount = 0;
  int requestattendersordersCount = 0;
  int ordersCount = 0;
  int? start = 1;
  String? fromDate;
  String? toDate;
  DateTime dateTime = DateTime.now();

  TextEditingController fromdateController = TextEditingController();
  TextEditingController todateController = TextEditingController();
  // ignore: non_constant_identifier_names
  bool is_scroll_load = false;
  final now = DateTime.now();
  @override
  void initState() {
    super.initState();
    getorderslist(nameType[indexSelected]);
    getrequestedbymangerorderslist();
    getrequestedbyattendersorderslist();
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    // Get.back();
    return Future.value(false);
  }

  Future<void> getorderslist(type) async {
    print('teser');
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_status': type.toString(),
      'page': '1',
      'from_date': fromdateController.text,
      'to_date': todateController.text
    };
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}order_list"), body: bodyData);

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
        //    orders.clear();
        setState(() {
          ordersCount = result['data']['total_records_count'];
          orders = result['data']['result'];
        });
      } else if (result['status'] == 'error') {
        orders.clear();
        setState(() {
          ordersCount = 0;
        });
        // print(ordersCount);
      }
    }
  }

  Future<void> getselectorderslist(type) async {
    print('teser');
    if (fromdateController.text == '') {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please select From Date",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (todateController.text == '') {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please select To Date",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        isLoader = true;
      });
      Map<String, dynamic> bodyData = {
        'user_token': user_token.toString(),
        'order_status': type.toString(),
        'page': '1',
        'from_date': fromdateController.text,
        'to_date': todateController.text
      };
      print(bodyData);
      http.Response response = await http
          .post(Uri.parse("${Constants.baseurl}order_list"), body: bodyData);

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
          //    orders.clear();
          setState(() {
            ordersCount = result['data']['total_records_count'];
            orders = result['data']['result'];
          });
        } else if (result['status'] == 'error') {
          orders.clear();
          setState(() {
            ordersCount = 0;
          });
          // print(ordersCount);
        }
      }
    }
  }

  Future<void> getrequestedbymangerorderslist() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'user_type': 'Manager'
    };
    //  print(bodyData);
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}requested_orders"),
        body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // print(result);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        setState(() {
          requestordersCount = result['data']['total_records_count'];
          requestorders = result['data']['result'];
        });
        //   print(requestordersCount);
        // });
      } else if (result['status'] == 'error') {
        requestorders.clear();
        setState(() {
          requestordersCount = 0;
        });
        print(requestordersCount);
      }
    }
  }

  Future<void> getrequestedbyattendersorderslist() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'user_type': 'Attendant'
    };
    print(bodyData);
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}requested_orders"),
        body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // print(result);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        setState(() {
          requestattendersordersCount = result['data']['total_records_count'];
          requestorders = result['data']['result'];
        });
        print(requestattendersordersCount);
        // });
      } else if (result['status'] == 'error') {
        requestorders.clear();
        setState(() {
          requestattendersordersCount = 0;
        });
        print(requestordersCount);
      }
    }
  }

  Future<bool> _loadMore() async {
    // print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadMoreData();
    return false;
  }

  Future<void> loadMoreData() async {
    //   print('start: $start');
    start = 1;
    if (mounted) {
      setState(() {
        start = start! + 1;
      });
    }
    // dynamic sliders = [];
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_status': nameType[indexSelected].toString(),
      'page': start.toString()
    };
    // print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}order_list"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);

      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        // orders.clear();
        setState(() {
          ordersCount = result['data']['total_records_count'];
          for (var i = 0; i < result['data']['result'].length; i++) {
            //  print(result['data']['result'][i]);
            orders.add(result['data']['result'][i]);
            //  print(orders);
          }
          //  orders = result['data']['result'];
        });
        //   print(orders);
        // });
      } else if (result['status'] == 'error') {
        orders.clear();
        setState(() {
          ordersCount = 0;
        });
      }
    }
    // print("serviceslist: $carservices");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leadingWidth: 50,
            backgroundColor: AppColor.appThemeColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'My Orders',
              style: CustomTextWhiteStyle.textStyleWhite(
                  context, 18, FontWeight.w600),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TabbarScreen()));
                },
                color: Colors.white,
                textColor: Colors.white,
                padding: const EdgeInsets.all(8),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 3,
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                  onBackground: Colors.white,
                                  primary: AppColor.appThemeColor,
                                )),
                                child: DateTimePicker(
                                  controller: fromdateController,
                                  enableInteractiveSelection: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: 'From Date',
                                    hintStyle: TextStyle(color: Colors.white),
                                    focusColor: Colors.white,
                                    suffixIcon: Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  type: DateTimePickerType.date,
                                  dateMask: 'yyyy-MM-dd',
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime.now(),
                                  // initialDate: DateTime.now(),
                                  // firstDate: DateTime.now()
                                  //     .subtract(Duration(days: 0)),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please select date';
                                    }
                                  },
                                  onChanged: (val) {
                                    print('val:$val');
                                    setState(() {
                                      fromdateController.text = val;
                                      //  DateTime fromdate = val as DateTime;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 3,
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                  onBackground: Colors.white,
                                  primary: AppColor.appThemeColor,
                                )),
                                child: DateTimePicker(
                                  controller: todateController,
                                  enableInteractiveSelection: true,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: 'To Date',
                                    hintStyle: TextStyle(color: Colors.white),
                                    suffixIcon: Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  type: DateTimePickerType.date,
                                  dateMask: 'yyyy-MM-dd',
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime.now(),
                                  //  initialDate: DateTime.now(),
                                  // firstDate: DateTime.now()
                                  //     .subtract(Duration(days: 0)),
                                  selectableDayPredicate: (date) {
                                    return true;
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please select date';
                                    } // return null;
                                  },
                                  onChanged: (val) {
                                    //  print('val:$val');
                                    setState(() {
                                      todateController.text = val;
                                    });
                                  },
                                  onSaved: (value) {
                                    debugPrint(value.toString());
                                  },
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  getselectorderslist(nameType[indexSelected]);
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontFamily: "ROBOTO",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.blackColor,
                                  fixedSize: Size(100, 46),
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))),
        // appBar: AppBarCustom.commonAppBarCustom(context, title: 'My Orders',
        //     onTaped: () {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => TabbarScreen()));
        // }),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                            setState(() {
                              todateController.text = '';
                              fromdateController.text = '';
                            });
                            getorderslist('Pending');
                          } else if (nameType[indexSelected] == 'Processing') {
                            setState(() {
                              todateController.text = '';
                              fromdateController.text = '';
                            });
                            getorderslist('Processing');
                          }
                          //  else if (nameType[indexSelected] == 'Delivered') {
                          //   getorderslist('Delivered');
                          // }
                          else if (nameType[indexSelected] == 'Completed') {
                            setState(() {
                              todateController.text = '';
                              fromdateController.text = '';
                            });
                            getorderslist('Completed');
                          } else if (nameType[indexSelected] == 'Cancelled') {
                            setState(() {
                              todateController.text = '';
                              fromdateController.text = '';
                            });
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
                Row(
                  children: [
                    if (requestordersCount > 0)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RequestedByManagerScreen(),
                          ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 17, top: 10),
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 40,
                            width: 170,
                            alignment: Alignment.center,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              'Requested by Manager',
                              style: GoogleFonts.roboto(
                                  color: Color(0xFF727272),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF8B8B8B)),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                    if (requestattendersordersCount > 0)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RequestedByAttender(),
                          ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 7, top: 10),
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 40,
                            width: 170,
                            alignment: Alignment.center,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              'Requested by Attender',
                              style: GoogleFonts.roboto(
                                  color: Color(0xFF727272),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF8B8B8B)),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                isLoader == false
                    ? Container(
                        child: (ordersCount != 0)
                            ? LoadMore(
                                textBuilder: DefaultLoadMoreTextBuilder.english,
                                isFinish: orders.length >=
                                    int.parse(ordersCount.toString()),
                                onLoadMore: _loadMore,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: orders.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      orderstablist(
                                    nameType[indexSelected],
                                    orders[index],
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        '${StringConstatnts.assets}nodata.png',
                                      ),
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
                                  name: 'Write A Review',
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
                          : '${data['contact_person']},${data['station_name']}',
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
                              text: data['total_amount'],
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
                          text: data['total_amount'],
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
          // if (name == 'Completed')
          //   Container(
          //     alignment: Alignment.topLeft,
          //     margin: EdgeInsets.only(top: 8, left: 11, right: 10, bottom: 10),
          //     child: Row(children: [
          //       Text.rich(
          //         TextSpan(
          //           text: 'Rating',
          //           style: GoogleFonts.roboto(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w400,
          //               color: Color(0xFFA0A0A0)),
          //         ),
          //       ),
          //       RatingBar.builder(
          //         itemSize: 16,
          //         initialRating: data['rating'] == null
          //             ? double.parse("0")
          //             : double.parse(data['rating']),
          //         minRating: data['rating'] == null
          //             ? double.parse("0")
          //             : double.parse(data['rating']),
          //         direction: Axis.horizontal,
          //         allowHalfRating: true,
          //         itemCount: 5,
          //         tapOnlyMode: false,
          //         updateOnDrag: false,
          //         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          //         itemBuilder: (context, _) => Icon(
          //           Icons.star,
          //           color: Colors.amber,
          //         ),
          //         onRatingUpdate: (rating) {
          //           //  print(rating);
          //         },
          //       ),
          //       Spacer(),
          //       if (data['rating'] == null)
          //         GestureDetector(
          //           onTap: () {
          //             Navigator.of(context).push(MaterialPageRoute(
          //               builder: (context) => OrderSummaryScreen(
          //                   name: 'Write A Review', order_id: data['id']),
          //             ));

          //           },
          //           child: Text.rich(
          //             TextSpan(
          //               text: 'Write a review',
          //               style: GoogleFonts.roboto(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.w400,
          //                   color: Color(0xFF89A619)),
          //             ),
          //           ),
          //         ),
          //     ]),
          //   ),
        ],
      ),
    );
  }
}
