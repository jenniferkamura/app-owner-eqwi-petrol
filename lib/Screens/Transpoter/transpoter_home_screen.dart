// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/reject_order_poupup.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/all_current_orders_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/selected_dates_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/today_route_plan_sceen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_profile/screens/transporter_notification_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_pick_up_details_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_deliveries_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_drawer.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_widgets/transpoter_home_page_widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:badges/badges.dart' as badges;

class TransporterHomeScreen extends StatefulWidget {
  TransporterHomeScreen({Key? key}) : super(key: key);

  @override
  State<TransporterHomeScreen> createState() => _TransporterHomeScreenState();
}

class _TransporterHomeScreenState extends State<TransporterHomeScreen> {
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ScrollController scrollController = ScrollController();
  String? userToken = Constants.prefs?.getString('user_token');

/*@override
  void initState() {
    print('*************');
    print('userToken --- $userToken');
    print('*************');
    if(Constants.prefs?.getString('isFirstPopType')=='true'){
      adds();

    }else {
      print('*************');
    }

    transportHomeController.transportPickUpOrdersFun(
        userToken!.toString(), 'Pending',
        isLoad: true);
    transportHomeController.transportCurrentOrdersFun(
        userToken!.toString(), 'Accept',
        isLoad: true);
    transportHomeController.transportHomeFun(userToken!.toString());
    super.initState();
  }*/

  @override
  Future<void> didChangeDependencies() async {
    if (Constants.prefs?.getString('isFirstPopType') == 'true') {
      adds();
    } else {
      print('*************');
    }

    await transportHomeController.transportPickUpOrdersFun(
        userToken.toString(), 'Pending',
        isLoad: false);
    await transportHomeController.transportCurrentOrdersFun(
        userToken.toString(), 'Accept',
        isLoad: false);
    await transportHomeController.transportHomeFun(userToken.toString());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final now = DateTime.now();

  adds() async {
    await transportHomeController.getAddsFun(userToken.toString());
    if (transportHomeController.addsFinalData.data.isNotEmpty) {
      Constants.prefs?.setString('isFirstPopType', 'false');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: 10, height: 0),
                      Text(
                        transportHomeController.addsFinalData.data[0].title
                            .toString(),
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.blackColor),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
/*setState(() {
                          Constants.prefs?.setString('isFirstPopType','false');
                        });*/
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 19,
                          )),
                    ],
                  ),
                  Text(
                    transportHomeController.addsFinalData.data[0].description
                        .toString(),
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  SizedBox(height: 5,width: 0),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: Image.network(
                            transportHomeController
                                .addsFinalData.data[0].imagePath
                                .toString(),scale: 1.0,fit: BoxFit.fill,)),
                  ),
                ],
              ),
            );
          });
    }
  }

  hello() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, i) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 10, height: 0),
                Text(
                  transportHomeController.addsFinalData.data[0].title
                      .toString(),
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor),
                ),
                IconButton(
                    onPressed: () {
/*setState(() {
                          Constants.prefs?.setString('isFirstPopType','false');
                        });*/
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 19,
                    )),
              ],
            ),
            Text(
              transportHomeController.addsFinalData.data[0].description
                  .toString(),
              style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500]),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  child: Image.network(
                      transportHomeController.addsFinalData.data[0].imagePath
                          .toString(),
                      height: 300)),
            ),
          ],
        );
      },
    );
  }

  refresh() {
    setState(() {
      transportHomeController.transportPickUpOrdersFun(
          userToken.toString(), 'Pending',
          isLoad: true);
      transportHomeController.transportCurrentOrdersFun(
          userToken.toString(), 'Accept',
          isLoad: true);
      transportHomeController.transportHomeFun(userToken.toString());
    });
  }

  Future<void> _refresh() async {
    refresh();
  }

// void upDateDates(List dates) async{
//   transportHomeController.transportAvailDatesFun(userToken.toString(), '0', dates);
// }

  var currentBackPressTime;

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

  maps() async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(37.759392, -122.5107336),
      title: "Location",
    );
  }

  double salePotential = 0; // Variable name should start with small letter

  @override
  Widget build(BuildContext context) {
    DateTime internetTime = DateTime.now();
    DateTime date =
        DateTime(internetTime.year, internetTime.month, internetTime.day);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _key,
        drawer: GetX<TransportHomeController>(
          initState: (_) => TransportHomeController.to
              .initStateHomeData(userToken.toString()),
          builder: (thc) {
            return TranspoterNavDrawer(
                name: '${thc.transportHomeSuccessData.name}',
                type: '${thc.transportHomeSuccessData.userType}',
                mailId: '${thc.transportHomeSuccessData.email}',
                image: '${thc.transportHomeSuccessData.profilePicUrl}');
          },
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColor.appThemeColor,
          titleSpacing: 0,
          title: GetX<TransportHomeController>(
            didChangeDependencies: (_) async {
              await TransportHomeController.to
                  .initStateHomeData(userToken.toString());
            },
            builder: (thc) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    thc.isHomeLoading.value
                        ? 'Hello,....'
                        : 'Hello,${thc.transportHomeSuccessData.name}',
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.whiteColor),
                  ),
                  // thc.isHomeLoading.value?RatingBar.builder(
                  //   itemSize: 14,
                  //   updateOnDrag: false,
                  //   tapOnlyMode: false,
                  //   ignoreGestures: true,
                  //   initialRating: 1,
                  //   minRating: 1,
                  //   direction: Axis.horizontal,
                  //   allowHalfRating: true,
                  //   itemCount: 5,
                  //   itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  //   itemBuilder: (context, _) => Icon(
                  //     Icons.star,
                  //     color: Colors.white,
                  //   ),
                  //   onRatingUpdate: (val) {},
                  // ): RatingBar.builder(
                  //   itemSize: 14,
                  //   updateOnDrag: false,
                  //   tapOnlyMode: false,
                  //   ignoreGestures: true,
                  //   initialRating: rate ?? 1,
                  //   minRating: 1,
                  //   direction: Axis.horizontal,
                  //   allowHalfRating: true,
                  //   itemCount: 5,
                  //   itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  //   itemBuilder: (context, _) => Icon(
                  //     Icons.star,
                  //     color: Colors.white,
                  //   ),
                  //   onRatingUpdate: (val) {},
                  // ),
                  /*Obx(()=>
                       SizedBox(
                        height: 10,
                        width: 80,
                        child: thc.isHomeLoading.value?Text('Please wait..'):ListView.builder(
                            itemCount: thc.isHomeLoading.value? 1 :int.tryParse(thc.transportHomeSuccessData.rating.toString()),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Icon(Icons.star,size: 13,color: Colors.white,);
                            }),
                      ),
                    ),*/
                  Obx(
                    () => thc.isHomeLoading.value
                        ? Text('Please wait..')
                        : Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: int.tryParse(thc
                                            .transportHomeSuccessData.rating
                                            .toString())! >=
                                        1
                                    ? Colors.white
                                    : Colors.grey[600],
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: int.tryParse(thc
                                            .transportHomeSuccessData.rating
                                            .toString())! >=
                                        2
                                    ? Colors.white
                                    : Colors.grey[600],
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: int.tryParse(thc
                                            .transportHomeSuccessData.rating
                                            .toString())! >=
                                        3
                                    ? Colors.white
                                    : Colors.grey[600],
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: int.tryParse(thc
                                            .transportHomeSuccessData.rating
                                            .toString())! >=
                                        4
                                    ? Colors.white
                                    : Colors.grey[600],
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: int.tryParse(thc
                                            .transportHomeSuccessData.rating
                                            .toString())! >=
                                        5
                                    ? Colors.white
                                    : Colors.grey[600],
                                size: 15,
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: GetX<TransportHomeController>(
                initState: (_) => TransportHomeController.to
                    .initStateHomeData(userToken.toString()),
                builder: (thc) => (IconButton(
                  onPressed: () {
                    Get.to(() => TransporterNotificationScreen(),
                        duration: Duration(microseconds: 400));
                  },
                  icon: badges.Badge(
                    badgeContent: Text(
                        thc.transportHomeSuccessData.unreadNotifications
                            .toString(),
                        style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColor.whiteColor)),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            scrollDirection: Axis.vertical,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Orders for Pickup ',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor),
                      ),
/*  InkWell(
                          onTap: () {
                            Get.to(() => AllPickUpOrdersScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 400));
                          },
                          child: Text(
                            'View All',
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue[900]),
                          ),
                        ),*/
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 235,
                  child: GetX<TransportHomeController>(
                    initState: (_) => TransportHomeController.to
                        .transportPickUpOrdersFun(
                            userToken.toString(), 'Pending',
                            isLoad: true),
                    builder: (thc) => thc.isPickOrdersLoad.value
                        ? SizedBox(
                            height: 235,
                            child: Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColor.appThemeColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        : thc.pickUpOrdersFinalData.result.isEmpty
                            ? Center(
                                child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Lottie.asset(
                                      '${StringConstatnts.assets}Transpoter/truck.json',
                                      height: 200,
                                      width: 300),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No Orders Found',
                                      style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                ],
                              ))
                            : ListView.builder(
                                itemCount:
                                    thc.pickUpOrdersFinalData.result.length,
                                clipBehavior: Clip.hardEdge,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Obx(
                                    () => TransHomePickUpOrderWidget(
                                        orderId: thc.pickUpOrdersFinalData
                                            .result[index].orderId,
                                        time: thc.pickUpOrdersFinalData
                                            .result[index].displayTime,
                                        dateTime: thc.pickUpOrdersFinalData
                                            .result[index].assignDatetime
                                            .toString(),
                                        pickUpAddress: thc.pickUpOrdersFinalData
                                            .result[index].vendorData.address,
                                        dropAddress: thc.pickUpOrdersFinalData
                                            .result[index].stationData.address,
                                        tapForView: () {},
                                        acceptOrderBText: 'VIEW ORDER',
                                        tapOnReject: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return RejectOrderPopup(
                                                  orderId: thc
                                                      .pickUpOrdersFinalData
                                                      .result[index]
                                                      .orderId,
                                                  userToken:
                                                      userToken.toString(),
                                                  assignOrderId: thc
                                                      .pickUpOrdersFinalData
                                                      .result[index]
                                                      .id,
                                                );
                                              });
                                        },
                                        tapOnAccept: () {
                                          Get.to(
                                              () =>
                                                  TransportViewOrderDetailScreen(
                                                      orderId: thc
                                                          .pickUpOrdersFinalData
                                                          .result[index]
                                                          .orderId
                                                          .toString()),
                                              transition:
                                                  Transition.rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 400));
                                        },
                                        orderType: (thc.pickUpOrdersFinalData.result[index].isScheduleDelivery == '0')
                                            ? 'Delivery Now'
                                            : 'This is scheduled order delivery date',
                                        textColor: (thc.pickUpOrdersFinalData.result[index].isScheduleDelivery == '0')
                                            ? Colors.red
                                            : Colors.black,
                                        textFontWeight: (thc
                                                    .pickUpOrdersFinalData
                                                    .result[index]
                                                    .isScheduleDelivery ==
                                                '0')
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                        scheduledDate: (thc
                                                    .pickUpOrdersFinalData
                                                    .result[index]
                                                    .isScheduleDelivery ==
                                                '0')
                                            ? ''
                                            : '${thc.pickUpOrdersFinalData.result[index].deliveryDate} and time:${thc.pickUpOrdersFinalData.result[index].deliveryTime}',
                                        isBlink: (thc.pickUpOrdersFinalData.result[index].isScheduleDelivery == '0') ? 'yes' : 'no'),
                                  );
                                }),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Container(
                    height: 10,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Orders',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => AllCurrentOrdersScreen(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 400));
                        },
                        child: Text(
                          'View All',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: GetX<TransportHomeController>(
                    initState: (_) => TransportHomeController.to
                        .transportCurrentOrdersFun(
                            userToken.toString(), 'Accept',
                            isLoad: true),
                    builder: (thc) => thc.isCurrentOrdersLoad.value
                        ? SizedBox(
                            height: 235,
                            child: Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColor.appThemeColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        : thc.currentOrdersFinalData.result.isEmpty
                            ? Center(
                                child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Lottie.asset(
                                      '${StringConstatnts.assets}Transpoter/truck.json',
                                      height: 200,
                                      width: 300),
                                  Text(
                                    'No Orders Found',
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue[900]),
                                  )
                                ],
                              ))
                            : ListView.builder(
                                itemCount:
                                    thc.currentOrdersFinalData.result.length,
                                clipBehavior: Clip.hardEdge,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return TransCurrentOrdersWidget(
                                    id: thc.currentOrdersFinalData.result[i]
                                        .orderNo,
                                    dateTime: thc.currentOrdersFinalData
                                        .result[i].assignDatetime
                                        .toString(),
                                    dropAddress: thc.currentOrdersFinalData
                                        .result[i].stationData.address,
                                    pickUpAddress: thc.currentOrdersFinalData
                                        .result[i].vendorData.address,
                                    tapOnPickupB: () async {
/*  if (kDebugMode) {
                                          print('hello pickup');
                                          print('${thc.currentOrdersFinalData
                                              .result[i].stationData.latitude} ${thc.currentOrdersFinalData
                                              .result[i].stationData.longitude}');
                                          print('hello pickup');
                                        }*/
//  maps();
                                      await MapLauncher.showMarker(
                                        mapType: MapType.google,
                                        coords: Coords(
                                            double.parse(thc
                                                .currentOrdersFinalData
                                                .result[i]
                                                .vendorData
                                                .latitude),
                                            double.parse(thc
                                                .currentOrdersFinalData
                                                .result[i]
                                                .vendorData
                                                .longitude)),
                                        title: thc.currentOrdersFinalData
                                            .result[i].vendorData.address,
                                      );
                                    },
                                    tapOnDeliveryB: () async {
/*  if (kDebugMode) {
                                  print('hello drop');
                                  print(
                                      '${thc.currentOrdersFinalData.result[i].vendorData.latitude} ${thc.currentOrdersFinalData.result[i].vendorData.longitude}');
                                }*/
                                      await MapLauncher.showMarker(
                                        mapType: MapType.google,
                                        coords: Coords(
                                            double.parse(thc
                                                .currentOrdersFinalData
                                                .result[i]
                                                .stationData
                                                .latitude),
                                            double.parse(thc
                                                .currentOrdersFinalData
                                                .result[i]
                                                .stationData
                                                .longitude)),
                                        title: thc.currentOrdersFinalData
                                            .result[i].vendorData.address,
                                      );
                                    },
                                    tapOnDeliveries: () {
                                      if (kDebugMode) {
                                        print(thc
                                          .currentOrdersFinalData
                                          .result[i]
                                          .orderId
                                          .toString());
                                      }
                                      Get.to(
                                          () => TransporterDeliveriesScreen(
                                              orderId: thc
                                                  .currentOrdersFinalData
                                                  .result[i]
                                                  .orderId
                                                  .toString()),
                                          transition: Transition.rightToLeft,
                                          duration: const Duration(
                                              milliseconds: 400));
                                    },
                                  );
                                }),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Container(
                    height: 10,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Route Plan For Today',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor),
                      ),
                      /* InkWell(
                        onTap: (){
                          Get.to(
                                  () => TodayRoutePlanScreen(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(
                                  milliseconds: 400));
                        },
                        child: BlinkText(
                            'Check Here',
                            style: TextStyle(fontSize: 16.0, color: Colors.blue[900],fontWeight: FontWeight.bold),
                            beginColor: Colors.blue[900],
                            endColor: AppColor.appThemeColor,
                            duration: const Duration(milliseconds: 700)
                        ),
                      )*/
                      TextButton(
                          onPressed: () {
                            Get.to(() => TodayRoutePlanScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 400));
                          },
                          child: Text('Click Here',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(
                    'My Availability',
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor),
                  ),
                ),
              ),
              Obx(
                () => SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 16, top: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0xFF000000).withOpacity(0.25),
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Color(0xFFD0EFD2),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 12, right: 10, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today ${date.toString().replaceAll("00:00:00.00", "")}',
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF606060)),
                              ),
                              transportHomeController.isAvailLoading.value
                                  ? Text(
                                      'Please wait..',
                                      style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    )
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap:
                                    transportHomeController.isAvailLoading.value
                                        ? null
                                        : () {
                                            transportHomeController
                                                .transportAvailFun(
                                                    userToken.toString(), '1',date.toString().replaceAll(" 00:00:00.000",""));
                                          },
                                child: Container(
                                  height: 30,
                                  width: 145,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: transportHomeController
                                                .transportHomeSuccessData
                                                .transporterAvailable ==
                                            '1'
                                        ? AppColor.appThemeColor
                                        : AppColor.blackColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'available'.toUpperCase(),
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      if (transportHomeController
                                              .transportHomeSuccessData
                                              .transporterAvailable ==
                                          '1') ...[
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                            '${StringConstatnts.assets}correct.png')
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap:
                                    transportHomeController.isAvailLoading.value
                                        ? null
                                        : () {
                                            transportHomeController
                                                  .transportAvailFun(
                                                    userToken.toString(), '0',date.toString().replaceAll(" 00:00:00.000",""));
                                          },
                                child: Container(
                                  height: 30,
                                  width: 145,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: transportHomeController
                                                .transportHomeSuccessData
                                                .transporterAvailable ==
                                            '0'
                                        ? AppColor.appThemeColor
                                        : AppColor.blackColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'not available'.toUpperCase(),
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      if (transportHomeController
                                              .transportHomeSuccessData
                                              .transporterAvailable ==
                                          '0') ...[
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                            '${StringConstatnts.assets}correct.png'),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select your not available dates here!',
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor)),
                      TextButton(
                          onPressed: () {
                            Get.offAll(() => const SelectedDatesScreen(),
                                duration: const Duration(milliseconds: 400),
                                transition: Transition.rightToLeft);
                          },
                          child: Text('Leaves',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[900])))
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(
                  () => transportHomeController.isDatesAvalbleLoad.value
                      ? CircularProgressIndicator()
                      : SfDateRangePicker(
// onSelectionChanged: _onSelectionChanged,
                          toggleDaySelection: true,
                          view: DateRangePickerView.month,
                          selectionMode: DateRangePickerSelectionMode.multiple,
                          showActionButtons: true,
                          enablePastDates: false,
                          todayHighlightColor: AppColor.appThemeColor,
                          onSubmit: (Object? val) async {
                            if(val == null){
                              Fluttertoast.showToast(
                                  msg: 'Select your date',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 12.0);
                            }else{
                              transportHomeController.dateListData = val as List;
                              for (var i = 0;
                              i < transportHomeController.dateListData.length;
                              i++) {
                                String fromDate = transportHomeController
                                    .dateListData[i]
                                    .toString()
                                    .substring(
                                    0,
                                    transportHomeController.dateListData[i]
                                        .toString()
                                        .length -
                                        13);
                                transportHomeController.selectedData
                                    .add(fromDate);
                              }
                              await transportHomeController
                                  .transporterAvailableDateFun(
                                  userToken.toString(),
                                  '0',
                                  transportHomeController.selectedData);
// upDateDates(selectedData);
                            }

                          },
                          selectionColor: AppColor.appThemeColor,
                          onCancel: () {
                            transportHomeController
                                .dateRangePickerController.selectedDates = null;
                          },
// initialSelectedDate:DateTime(now.year, now.month, now.day),
                          minDate: DateTime.now().add(const Duration(days: 1)),
// monthViewSettings: DateRangePickerMonthViewSettings(),
// initialSelectedRange: PickerDateRange(
//     DateTime.now().subtract(const Duration(days: 4)),
//     DateTime.now().add(const Duration(days: 3))),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*Widget test(){
  return Container(
    margin: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: Color(0xFF000000).withOpacity(0.25),
          offset: Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: Color(0xFFD0EFD2),
      ),
    ),
    child: Container(
      margin: EdgeInsets.only(top: 10, left: 12, right: 10, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today 10/02/2022',
            style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF606060)),
          ),
          SizedBox(
            height: 11,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      isavailable = true;
                    });
                  }
                },
                child: Container(
                  height: 30,
                  width: 145,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isavailable
                        ? AppColor.appThemeColor
                        : AppColor.blackColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'available'.toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      if (isavailable) ...[
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                            '${StringConstatnts.assets}correct.png')
                      ]
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      isavailable = false;
                    });
                  }
                },
                child: Container(
                  height: 30,
                  width: 145,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isavailable
                        ? AppColor.blackColor
                        : AppColor.appThemeColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'not available'.toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      if (!isavailable) ...[
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                            '${StringConstatnts.assets}correct.png')
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}*/
