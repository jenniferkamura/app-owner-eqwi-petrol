import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_widgets/transpoter_home_page_widgets.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_order_details_screen.dart';

class TransporterAcceptOrderScreenD extends StatefulWidget {
  final String orderId;

  const TransporterAcceptOrderScreenD({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<TransporterAcceptOrderScreenD> createState() =>
      _TransporterAcceptOrderScreenDState();
}

class _TransporterAcceptOrderScreenDState
    extends State<TransporterAcceptOrderScreenD> {
  TransportHomeController transportHomeController =
  Get.put(TransportHomeController());
  String? userToken = Constants.prefs?.getString('user_token');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
        Get.back();
      }, title: 'Order ID: #${widget.orderId}'),
      backgroundColor: Colors.white,
      body: GetX<TransportHomeController>(
        initState: (_) =>
            TransportHomeController.to.initStateOrderDetails(userToken!.toString(),widget.orderId),
        builder: (thc) => TransOrderViewHomePageWidget(
          tapOnPickupL: () {

          },
          tapOnDeliveryL: () {

          },
          tapPickUpCall: () {

          },
          tapPickUpChat: () {},
          tapDelCall: () {},
          tapDelChart: () {},
          tapOnDeliveredB: () {},tapOnViewAll: () {},tapOnViewDetails: (){
          Get.to(()=>TranspoterDeliveredScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 400));
        },
          contactPerson: 'kkk',deliveryAddress: 'H-365, Shell Perol, Nairobi, Kenya, 456781',
          pickUpAddress:
          thc.acceptOrderDetailsFinalData.stationData!.address.toString(),
          productType: 'Petrol',
          productQty: '4000 Ltr',
        ),
      ),
    );
  }
}
