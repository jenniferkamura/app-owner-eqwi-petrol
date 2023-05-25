import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loadmore/loadmore.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';

import '../../controllers/notification_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TransporterNotificationScreen extends StatefulWidget {
  const TransporterNotificationScreen({Key? key}) : super(key: key);

  @override
  State<TransporterNotificationScreen> createState() =>
      _TransporterNotificationScreenState();
}

class _TransporterNotificationScreenState
    extends State<TransporterNotificationScreen> {
  String? userToken = Constants.prefs?.getString('user_token');

  NotificationController notificationController =
      Get.put(NotificationController());

  int notcount = 0;
  int start = 1;
  List<dynamic> notifcations = [];
  bool isLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();
    // print(userToken);
    // notificationController.transporterNotificationsFun(
    //     userToken.toString(), currentPage.toString(),isLoad: false);
  }

  deleteNotification(String userToken, notificationId) async {
    await notificationController.deleteNotificationFun(
        userToken, notificationId);

    if (notificationController.deleteNotificationFinalData.data == true) {
      getNotifications();
      // notificationController.transporterNotificationsFun(
      //     userToken.toString(), currentPage.toString());
    }
  }

  deleteAllNotifications() async {
    await notificationController.deleteAllNotificationFun(userToken.toString());
    if (notificationController.deleteAllNotificationFinalData.data == true) {
      getNotifications();
      // notificationController.transporterNotificationsFun(
      //     userToken.toString(), currentPage.toString());
    }
  }

  int currentPage = 1;
  // Future<bool> _loadMore() async {
  //   print("onLoadMore");
  //   //await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
  //   await notificationController.loadMore(
  //       userToken.toString());
  //   return true;
  // }

  Future<void> getNotifications() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': userToken.toString(),
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
      if(mounted){
        setState(() {
          isLoader = false;
        });
      }
      //  print(result);
      if (result['status'] == 'success') {
       if(mounted){
         setState(() {
           notcount = result['data']['total_records_count'];
           notifcations = result['data']['result'];
         });
       }

      } else {
        if(mounted){
          setState(() {
            notcount = 0;
          });
        }
      }
    }
  }

  Future<bool> _loadMore() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    loadMoreData();
    return false;
  }

  Future<void> loadMoreData() async {
    if (mounted) {
      setState(() {
        start = start + 1;
      });
    }
    // dynamic sliders = [];
    Map<String, dynamic> bodyData = {
      'user_token': userToken.toString(),
      'page': start.toString()
    };


    http.Response response = await http.post(
        Uri.parse(Constants.baseurl + "get_notification"),
        body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);

      // setState(() {
      //   isLoader = false;
      // });
      if (result['status'] == 'success') {
        // orders.clear();
        if(mounted){ setState(() {
          for (var i = 0; i < result['data']['result'].length; i++) {

            //  print(result['data']['result'][i]);
            notifcations.add(result['data']['result'][i]);
            //  print(orders);
          }
        });}



      } else if (result['status'] == 'error') {
        // notifcations.clear();

        print(notcount);
      }
    }
    // print("serviceslist: $carservices");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appThemeColor,
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.white,
            )),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 200),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Do you want to delete notification?'),
                            const SizedBox(
                              height: 10,
                              width: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('No')),
                                Obx(() => notificationController
                                        .isNotificationDeleteAllLoad.value
                                    ? const SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator(
                                          color: Colors.green,
                                          strokeWidth: 2,
                                        ))
                                    : TextButton(
                                        onPressed: () {
                                          deleteAllNotifications();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes'))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Delete All',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )),
        ],
      ),
      body: isLoader == true
          ? Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColor.appThemeColor,
                  strokeWidth: 2,
                ),
              ),
            )
          // : ncd.getNotificationFinalData.result.isEmpty
          //     ? Center(
          //         child: Text(
          //           'No Notifications Found',
          //           style: GoogleFonts.roboto(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w700,
          //               color: AppColor.blackColor),
          //         ),
          //       )
          : Container(
              child: LoadMore(
                textBuilder: DefaultLoadMoreTextBuilder.english,
                isFinish: notifcations.length >= int.parse(notcount.toString()),
                onLoadMore: _loadMore,
                child: ListView.builder(
                  itemCount: notifcations.length,
                  itemBuilder: (context, index) {
                    return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        color: Colors.transparent,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.grey[100],
                                  backgroundImage: AssetImage(
                                    '${StringConstatnts.assets}sucees.png',
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notifcations[index]['title'].toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      notifcations[index]['message'].toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  notifcations[index]['display_time']
                                      .toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return Scaffold(
                                            backgroundColor: Colors.transparent,
                                            body: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 200),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                      'Do you want to delete notification?'),
                                                  const SizedBox(
                                                    height: 10,
                                                    width: 0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              const Text('No')),
                                                      Obx(() => notificationController
                                                              .isNotificationDeleteLoad
                                                              .value
                                                          ? const SizedBox(
                                                              height: 10,
                                                              width: 10,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .green,
                                                                strokeWidth: 2,
                                                              ))
                                                          : TextButton(
                                                              onPressed: () {
                                                                deleteNotification(
                                                                    userToken
                                                                        .toString(),
                                                                    notifcations[index]
                                                                            [
                                                                            'id']
                                                                        .toString());
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Yes'))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 14,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ),
            ),
      /*NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification sc){
            if(sc is ScrollUpdateNotification && sc.metrics.pixels == sc.metrics.maxScrollExtent){
              notificationController.loadMore(userToken.toString(),'');
            }
            return true;
          },
                  child: ,
                )*/
    );
  }
}
