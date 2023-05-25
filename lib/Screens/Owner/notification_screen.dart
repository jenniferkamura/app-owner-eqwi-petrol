// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:owner_eqwi_petrol/modals/notifcationmodal.dart';
import '../../Common/common_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  bool isLoader = false;
  String? notiCount;
  int notcount = 0;
  int start = 1;
  List<dynamic> notifcations = [];
  void initState() {
    getNotifications();
    notificationsCountFun();
  }

  Future<void> getNotifications() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'page': '1'
    };
    print(bodyData);

    http.Response response = await http.post(
        Uri.parse(Constants.baseurl + "get_notification"),
        body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      //  print(result);
      if (result['status'] == 'success') {
        setState(() {
          notifcations = result['data']['result'];
          notcount = 1;
        });
      } else {
        setState(() {
          notcount = 0;
        });
      }
    }
  }

  Future<void> notificationsCountFun() async {
    print("datadtatatataatatta");
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    print('gethomecarfffftData');
    http.Response response =
        await http.post(Uri.parse(Constants.baseurl + "home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        print(result['data']);
        setState(() {
          notiCount = result['data']['unread_notifications'].toString();
        });
      }
    }
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadMoreData();
    return false;
  }

  Future<void> loadMoreData() async {
    print('start: $start');
    start = 1;
    if (mounted) {
      setState(() {
        start = start + 1;
      });
    }
    // dynamic sliders = [];
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'page': '1'
    };
    print(bodyData);

    http.Response response = await http.post(
        Uri.parse(Constants.baseurl + "get_notification"),
        body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      print('loadmore');

      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        // orders.clear();
        setState(() {
          notcount = result['data']['total_records_count'];
          for (var i = 0; i < result['data']['result'].length; i++) {
            print('sdffff');
            notifcations = result['data']['result'];
          }
        });
        print('ordersCount');
      } else if (result['status'] == 'error') {
        notifcations.clear();
        setState(() {
          notcount = 0;
        });
        print(notcount);
      }
    }
    // print("serviceslist: $carservices");
  }

  Future<void> deleteAllNotifcations() async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token,
    };
    print(bodyData);
    setState(() {
      isLoader = true;
    });
    http.Response response = await http.post(
        Uri.parse(Constants.baseurl + "delete_all_notification"),
        body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array
      print(result);
      if (result['status'] == 'success') {
        // reidrect to login Page
        setState(() {
          isLoader = false;
        });
        //    Navigator.of(context).pop();
        getNotifications();
      } else {}
    }
  }

  Future<void> deleteItemFromCart(notification_id) async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token,
      'notification_id': notification_id.toString(),
    };
    print(bodyData);
    setState(() {
      isLoader = true;
    });
    http.Response response = await http.post(
        Uri.parse(Constants.baseurl + "delete_notification"),
        body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array
      print(result);
      if (result['status'] == 'success') {
        // reidrect to login Page
        setState(() {
          isLoader = false;
        });
        Navigator.of(context).pop();
        getNotifications();
      } else {}
    }
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    //Get.back();
    return Future.value(false);
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
            "Notifications",
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
          actions: [
            GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      deleteAllNotifcations();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.blackColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Text(
                      'Delete All',
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ))
          ],
        ),
        body: isLoader == false
            ? notcount != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notifcations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return noticationsLoad(notifcations[index]);
                    })
                : Center(
                    child: Column(
                      children: [
                        Image.asset(
                            '${StringConstatnts.assets}notificationssss.png'),
                        Text(
                          'No Notifcations Found',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                    color: AppColor.appThemeColor, strokeWidth: 3),
              ),
      ),
    );
  }

  Widget noticationsLoad(data) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => OrderSummaryScreen(name: 'MAKE PAYMENT'),
      //   ));
      // },
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [list(data)],
      ),
    );
  }

  void deleteFunction(context, notification_id) {
    print(notification_id);
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
                        deleteItemFromCart(notification_id);
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

  Widget list(data) {
    return Container(
      margin: EdgeInsets.only(right: 25, left: 25, top: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(26)),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          '${StringConstatnts.assets}sucees.png',
                          height: 29,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    // color: BLUECOLOR
                                  ),
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Text(
                                //       data['message'],
                                //       style: TextStyle(
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w500,
                                //         // color: BLUECOLOR
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                InkWell(
                                  onTap: () {
                                    deleteFunction(context, data['id']);
                                  },
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['message'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    // color: BLUECOLOR,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 2,
            color: Color(0xFFF0F0F0),
          )
          // SizedBox(
          //   height: 15,
          // ),
          // Container(
          //   height: 2,
          //   width: MediaQuery.of(context).size.width * 0.95,
          //   color: Color.fromARGB(255, 202, 199, 199),
          // )
        ],
      ),
    );
  }
}
