import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_deliveries_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_widgets/transpoter_home_page_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AllCurrentOrdersScreen extends StatefulWidget {
  const AllCurrentOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllCurrentOrdersScreen> createState() => _AllCurrentOrdersScreenState();
}

class _AllCurrentOrdersScreenState extends State<AllCurrentOrdersScreen> {
  String? userToken = Constants.prefs?.getString('user_token');
  int indexSelected = 0;
  List<String> nameType = [
    'Today Delivery',
    'Schedule Delivery',
  ];
  bool isLoader = false;
  List orders = [];
  int ordersCount = 0;
  @override
  void initState() {
    super.initState();
    getorderslist(nameType[indexSelected]);
  }

  Future<void> getorderslist(type) async {
    if (type == 'Today Delivery') {
      type = 0;
    }
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': userToken.toString(),
      'is_scheduled': type.toString(),
      //'page': '1'
    };
    //print(bodyData);
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}scheduled_order_list"),
        body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      print(result);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      if(mounted){
        setState(() {
          isLoader = false;
        });
      }
      if (result['status'] == 'success') {
        orders.clear();
        if(mounted){
          setState(() {
            ordersCount = result['data']['total_records_count'];
            orders = result['data']['result'];
          });
        }
       /* print(ordersCount);
        print(orders);*/
        // });
      } else if (result['status'] == 'error') {
        orders.clear();
        setState(() {
          ordersCount = 0;
        });
       // print(ordersCount);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
          Get.back();
        }, title: 'Current Orders'),
        body: SafeArea(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 37,
                    margin: const EdgeInsets.only(left: 17, top: 19),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: nameType.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              indexSelected = index;
                            });
                            if (nameType[indexSelected] == 'Today Delivery') {
                              getorderslist('0');
                            } else if (nameType[indexSelected] ==
                                'Schedule Delivery') {
                              getorderslist('1');
                            }
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 9),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFF8B8B8B)),
                                  color: indexSelected == index
                                      ? AppColor.appThemeColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(17)),
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
                                          : const Color(0xFF727272),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              )),
                        );
                      },
                    ),
                  ),
                  isLoader == false
                      ? Container(
                          child: (ordersCount != 0)
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: orders.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      orderstablist(
                                    nameType[indexSelected],
                                    orders[index],
                                  ),
                                )
                              : Center(
                                  child:  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset(
                                          '${StringConstatnts.assets}Transpoter/truck.json',
                                          height: 200,
                                          width: 300),
                                      const Text(
                                        'No orders found',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      : Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: AppColor.appThemeColor, strokeWidth: 3),
                          ),
                        ),
                ],
              )),
        ));
  }

  Widget orderstablist(name, data) {
    return SizedBox(
      height: 200,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: TransCurrentOrdersWidget(
          id: data['order_id'].toString(),
          dateTime: data['station_data']['delivery_date'].toString(),
          dropAddress: data['station_data']['address'].toString() +
              ',' +
              data['station_data']['city'].toString() +
              ',' +
              data['station_data']['state'].toString() +
              ',' +
              data['station_data']['pincode'].toString(),
          pickUpAddress: data['pickup_data']['address'].toString(),
          tapOnPickupB: () async {
            if (kDebugMode) {
              await MapLauncher.showMarker(
                mapType: MapType.google,
                coords: Coords(double.parse(data['pickup_data']['latitude']),
                    double.parse(data['pickup_data']['longitude'])),
                title: data['pickup_data']['address'],
              );
            }
          },
          tapOnDeliveryB: () async {
            if (kDebugMode) {
              await MapLauncher.showMarker(
                mapType: MapType.google,
                coords: Coords(double.parse(data['station_data']['latitude']),
                    double.parse(data['station_data']['longitude'])),
                title: data['station_data']['address'],
              );
            }
          },
          tapOnDeliveries: () {
            Get.to(() => TransporterDeliveriesScreen(orderId: data['order_id']),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 400));
          },
        ),
      ),
    );
  }
}


  //  GetX<TransportHomeController>(
        //   initState: (_) => TransportHomeController.to
        //       .transportCurrentOrdersFun(userToken!.toString(), 'Accept',isLoad: false),
        //   builder: (thc) => thc.currentOrdersFinalData.result.isEmpty
        //       ? const Center(child: Text('No orders found'))
        //       : ListView.builder(
        //       itemCount: thc.currentOrdersFinalData.result.length,
        //       clipBehavior: Clip.hardEdge,
        //       physics: const BouncingScrollPhysics(),
        //       scrollDirection: Axis.vertical,
        //       itemBuilder: (context, i) {
        //         return SizedBox(
        //           height: 200,
        //           child: TransCurrentOrdersWidget(
        //             id: thc.currentOrdersFinalData.result[i].orderId,
        //             dateTime: thc
        //                 .currentOrdersFinalData.result[i].assignDatetime
        //                 .toString(),
        //             dropAddress: thc.currentOrdersFinalData.result[i]
        //                 .stationData.address,
        //             pickUpAddress: thc.currentOrdersFinalData.result[i]
        //                 .vendorData.address,
        //             tapOnPickupB: () {
        //               if (kDebugMode) {
        //                 print('hello pickup');
        //               }
        //             },
        //             tapOnDeliveryB: () {
        //               if (kDebugMode) {
        //                 print('hello drop');
        //               }
        //             },
        //             tapOnDeliveries: () {
        //               Get.to(()=>TransporterDeliveriesScreen(orderId: thc.currentOrdersFinalData.result[i].orderId),
        //                   transition: Transition.rightToLeft,
        //                   duration: const Duration(milliseconds: 400));
        //             },
        //           ),
        //         );
        //       }),
        // )
        //