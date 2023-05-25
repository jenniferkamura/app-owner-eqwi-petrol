import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/notification_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_deliveries_screen.dart';

class TodayRoutePlanScreen extends StatefulWidget {
  const TodayRoutePlanScreen({Key? key}) : super(key: key);

  @override
  State<TodayRoutePlanScreen> createState() => _TodayRoutePlanScreenState();
}

class _TodayRoutePlanScreenState extends State<TodayRoutePlanScreen> {
  NotificationController notificationController =
      Get.put(NotificationController());

  String? userToken = Constants.prefs?.getString('user_token');

  @override
  void didChangeDependencies() {
    notificationController.todayRoutePlanFun(userToken.toString());
    super.didChangeDependencies();
    //print('${notificationController.todayRoutePlanFinalData.data}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appThemeColor,
        title: const Text('Route Plan For Today'),
      ),
      body: GetX<NotificationController>(
        initState: (_) =>
            NotificationController.to.todayRoutePlanFun(userToken.toString()),
        builder: (thc) {
          return notificationController.isTodayRouteLoad.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColor.appThemeColor,
                  strokeWidth: 2,
                ))
              : thc.todayRoutePlanFinalData.data.isEmpty
                  ? Center(
                      child: Text('No Data Founded',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor)))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: thc.todayRoutePlanFinalData.data.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      clipBehavior: Clip.hardEdge,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Card(
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 2,color: Colors.white,
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Order Id :${thc.todayRoutePlanFinalData.data[index].orderId}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.blackColor)),
                                   const Spacer(),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Pickup',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xFF696969)),
                                              ),
                                              const SizedBox(
                                                width: 19,
                                                height: 0,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await MapLauncher.showMarker(
                                                    mapType: MapType.google,
                                                    coords: Coords(
                                                        double.parse(thc
                                                            .todayRoutePlanFinalData
                                                            .data[index]
                                                            .pickupData
                                                            .latitude),
                                                        double.parse(thc
                                                            .todayRoutePlanFinalData
                                                            .data[index]
                                                            .pickupData
                                                            .longitude)),
                                                    title: thc.todayRoutePlanFinalData
                                                        .data[index].pickupData.address,
                                                  );
                                                },
                                                child: Container(
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 4,
                                                          color: const Color(0xFF000000)
                                                              .withOpacity(0.25),
                                                          offset: const Offset(0, 2),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(10)),
                                                  child: Image.asset(
                                                    '${StringConstatnts.assets}Transpoter/pickup.png',
                                                    height: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,width: 0,),
                                          Text(thc.todayRoutePlanFinalData.data[index].pickupData.address,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.blackColor)),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Assign DateTime',
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.blackColor)),
                                        Text(
                                            thc.todayRoutePlanFinalData.data[index].assignDatetime,
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.blackColor)),
                                      ],
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Delivery',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xFF696969)),
                                              ),
                                              const SizedBox(
                                                width: 19,
                                                height: 0,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await MapLauncher.showMarker(
                                                    mapType: MapType.google,
                                                    coords: Coords(
                                                        double.parse(thc
                                                            .todayRoutePlanFinalData
                                                            .data[index]
                                                            .stationData
                                                            .latitude),
                                                        double.parse(thc
                                                            .todayRoutePlanFinalData
                                                            .data[index]
                                                            .stationData
                                                            .longitude)),
                                                    title: thc.todayRoutePlanFinalData
                                                        .data[index].stationData.address,
                                                  );
                                                },
                                                child: Container(
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 4,
                                                          color: const Color(0xFF000000)
                                                              .withOpacity(0.25),
                                                          offset: const Offset(0, 2),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                      BorderRadius.circular(10)),
                                                  child: Image.asset(
                                                    '${StringConstatnts.assets}Transpoter/pickup.png',
                                                    height: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,width: 0,),
                                          Text(thc.todayRoutePlanFinalData.data[index].stationData.address,
                                            style: GoogleFonts.roboto(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.blackColor)),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,width: 0,),
                                InkWell(
                                  onTap: (){
                                    Get.to(
                                            () => TransporterDeliveriesScreen(
                                            orderId: thc
                                                .todayRoutePlanFinalData.data[index]
                                                .orderId
                                                .toString()),
                                        transition: Transition.rightToLeft,
                                        duration: const Duration(
                                            milliseconds: 400));
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 126,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColor.blackColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      'Deliveries'.toUpperCase(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
        },
      ),
    );
  }
}

//         ListView(
//           physics: NeverScrollableScrollPhysics(),
//           children: [
//             Text(
//               'OrderId',
//               style: GoogleFonts.roboto(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xFF696969)),
//             ),
//             Text(
//               '#${thc.todayRoutePlanFinalData.data[index].orderId}',
//               style: GoogleFonts.roboto(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black),
//             ),
//             const SizedBox(
//               height: 10,width: 0,
//             ),
//             Text(
//               'Assign Date Time',
//               style: GoogleFonts.roboto(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xFF696969)),
//             ),
//             const SizedBox(
//               height: 3,width: 0,
//             ),
//             Text(
//               thc.todayRoutePlanFinalData.data[index].assignDatetime,
//               style: GoogleFonts.roboto(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black),
//             ),
//             const Spacer(),
//             InkWell(
//               onTap: (){},
//               /* () {
//   */ /* Navigator.of(context).push(MaterialPageRoute(
//     builder: (context) => TranspoterDeliveriesScreen(),
//   ));*/ /*
//   //TranspoterDeliveriesScreen
// },*/
//               child: Container(
//                 height: 30,
//                 width: 126,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: AppColor.blackColor,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Text(
//                   'Deliveries'.toUpperCase(),
//                   style: GoogleFonts.roboto(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         ListView(
//           physics: NeverScrollableScrollPhysics(),
//
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Pickup',
//                   style: GoogleFonts.roboto(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xFF696969)),
//                 ),
//                 const SizedBox(
//                   width: 19,height: 0,
//                 ),
//                 InkWell(
//                   onTap: ()async {
//                     await MapLauncher.showMarker(
//                       mapType: MapType.google,
//                       coords: Coords(
//                           double.parse(thc
//                               .todayRoutePlanFinalData.data[index]
//                               .stationData
//                               .latitude),
//                           double.parse(thc
//                               .todayRoutePlanFinalData.data[index]
//                               .stationData
//                               .longitude)),
//                       title: thc.todayRoutePlanFinalData.data[index]
//                           .stationData.address,
//                     );
//                   },
//                   child: Container(
//                     height: 25,
//                     decoration: BoxDecoration(boxShadow: [
//                       BoxShadow(
//                         blurRadius: 4,
//                         color: const Color(0xFF000000).withOpacity(0.25),
//                         offset: const Offset(0, 2),
//                       ),
//                     ], borderRadius: BorderRadius.circular(10)),
//                     child: Image.asset(
//                       '${StringConstatnts.assets}Transpoter/pickup.png',
//                       height: 25,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 3,
//             ),
//             Text(
//               thc.todayRoutePlanFinalData.data[index].id,
//               style: GoogleFonts.roboto(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xFF696969)),
//             ),
//             const SizedBox(
//               height: 9,
//             ),
//             Container(
//               height: 1,
//               color: const Color(0xFFC4C4C4),
//               width: 109,
//             ),
//             const SizedBox(
//               height: 10,width: 0,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Delivery',
//                   style: GoogleFonts.roboto(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xFF696969)),
//                 ),
//                 const SizedBox(
//                   width: 19,height: 0,
//                 ),
//                 InkWell(
//                   onTap: ()async {
//                     await MapLauncher.showMarker(
//                       mapType: MapType.google,
//                       coords: Coords(
//                           double.parse(thc
//                               .todayRoutePlanFinalData.data[index].pickupData
//                               .latitude),
//                           double.parse(thc
//                               .todayRoutePlanFinalData.data[index]
//                               .pickupData
//                               .longitude)),
//                       title: thc.todayRoutePlanFinalData.data[index]
//                           .pickupData.address,
//                     );
//                   },
//                   child: Container(
//                     height: 25,
//                     decoration: BoxDecoration(boxShadow: [
//                       BoxShadow(
//                         blurRadius: 4,
//                         color: const Color(0xFF000000).withOpacity(0.25),
//                         offset: const Offset(0, 2),
//                       ),
//                     ], borderRadius: BorderRadius.circular(10)),
//                     child: Image.asset(
//                       '${StringConstatnts.assets}Transpoter/pickup.png',
//                       height: 25,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 3,
//             ),
//             Text(
//               thc.todayRoutePlanFinalData.data[index].id,
//               style: GoogleFonts.roboto(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xFF696969)),
//             ),
//           ],
//         )
