import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Popup/reject_order_poupup.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_widgets/transpoter_home_page_widgets.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_pick_up_details_screen.dart';

class AllPickUpOrdersScreen extends StatefulWidget {
  const AllPickUpOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllPickUpOrdersScreen> createState() => _AllPickUpOrdersScreenState();
}

class _AllPickUpOrdersScreenState extends State<AllPickUpOrdersScreen> {
  TransportHomeController transportHomeController =
  Get.put(TransportHomeController());
  String? userToken = Constants.prefs?.getString('user_token');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
        Get.back();
      }, title: 'PickUp Orders'),
      body: GetX<TransportHomeController>(
        initState: (_) => TransportHomeController.to
            .transportPickUpOrdersFun(
            userToken!.toString(), 'Pending',isLoad: false),
        builder: (thc) =>
        thc.pickUpOrdersFinalData.result.isEmpty
            ? const Center(child: Text('No orders found'))
            : ListView.builder(
            itemCount:
            thc.pickUpOrdersFinalData.result.length,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.hardEdge,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Obx(
                    () => TransHomePickUpOrderWidget(
                        orderId: thc.pickUpOrdersFinalData
                            .result[index].orderId,
                        time: DateTime.now(),
                        dateTime: thc.pickUpOrdersFinalData
                            .result[index].assignDatetime
                            .toString(),
                        pickUpAddress: thc
                            .pickUpOrdersFinalData
                            .result[index]
                            .vendorData
                            .address,
                        dropAddress: thc
                            .pickUpOrdersFinalData
                            .result[index]
                            .stationData
                            .address,
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
                        tapOnAccept:  () {
                          Get.to(()=>TransportViewOrderDetailScreen(orderId: thc
                              .pickUpOrdersFinalData
                              .result[index]
                              .orderId),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 400));
                          /*   transportHomeController
                                                        .transporterActionFun(
                                                            userToken!,
                                                            thc
                                                                .pickUpOrdersFinalData
                                                                .result[index]
                                                                .orderId,
                                                            thc
                                                                .pickUpOrdersFinalData
                                                                .result[index]
                                                                .id,
                                                            'Accept',
                                                            '',
                                                            '');
                                                    transportHomeController.transportPickUpOrdersFun(userToken!.toString(), 'Pending',isLoad: true);
                                                    transportHomeController.transportCurrentOrdersFun(userToken!.toString(), 'Accept',isLoad: true);*/
                        },orderType: 'Delivery Now Order Please Deliver ASAP Today',textColor: Colors.red,textFontWeight: FontWeight.bold,scheduledDate: '',isBlink: (thc
                        .pickUpOrdersFinalData
                        .result[index]
                        .isScheduleDelivery ==
                        '0')
                        ?'yes':'no'),
              );
            }),
      ),
    );
  }
}
