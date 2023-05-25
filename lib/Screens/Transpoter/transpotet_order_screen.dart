// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/orders_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/deliver_order_view_details.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/pending_order_details%20screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_widgets/orders_widget.dart';

class TransporterOrderScreen extends StatefulWidget {
  const TransporterOrderScreen({super.key});

  @override
  State<TransporterOrderScreen> createState() => _TransporterOrderScreenState();
}

class _TransporterOrderScreenState extends State<TransporterOrderScreen>
    with SingleTickerProviderStateMixin {
  /* TransportHomeController transportHomeController = Get.put(TransportHomeController());
  DrawerDataController drawerDataController = Get.put(DrawerDataController());*/

  OrdersController ordersController = Get.put(OrdersController());
  int indexSelected = 0;
  List<String> nameType = [
    'Pending',
    'Delivered',
  ];
  String? userToken = Constants.prefs?.getString('user_token');

  @override
  initState() {
    ordersController.tabController = TabController(length: 2, vsync: this);
    super.initState();
    ordersController.ordersFun(userToken!.toString(), 'Accept', isLoad: true);

    ordersController.tabController.addListener(() {
      setState(() {});
    });
  }

  TabBar get _tabBar => TabBar(
    padding: EdgeInsets.only(top: 5),
        controller: ordersController.tabController,
        unselectedLabelColor: Colors.black,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        indicator: ShapeDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            color: AppColor.appThemeColor),
        onTap: (index) {
          if (index == 0) {
            ordersController.ordersFinalData.result.clear();
            ordersController.ordersFun(userToken.toString(), 'Accept',
                isLoad: true);
          } else if (index == 1) {
            ordersController.ordersFinalData.result.clear();
            ordersController.ordersFun(userToken.toString(), 'Delivered',
                isLoad: true);
          }
        },
        tabs: const [
          Tab(
            text: 'Pending',
          ),
          Tab(
            text: 'Delivered',
          ),
        ],
      );

  @override
  void dispose() {
    ordersController.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* return Scaffold(
      appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
        Get.back();
      }, title: 'Orders'),
      body: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          */ /* Container(
            height: 76,
            color: AppColor.appThemeColor,
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Order',
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColor.whiteColor),
                  ),
                  Spacer(),
                  if (indexSelected == 0)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TransporterDeliveriesScreen(),
                        ));
                        //TranspoterDeliveriesScreen
                      },
                      child: Container(
                        height: 30,
                        width: 87,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.blackColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Deliveries',
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),*/ /*
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
                      print(indexSelected);
                    });
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
            height: 8,
          ),
         Obx((){
           return  transportHomeController.isPickOrdersLoad.value
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
               : transportHomeController.pickUpOrdersFinalData.result.isEmpty
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
             itemCount: transportHomeController.pickUpOrdersFinalData.result.length,
             physics: NeverScrollableScrollPhysics(),
             shrinkWrap: true,
             itemBuilder: (context, index){
               return OrdersWidget(
                   indexSelected: indexSelected,
                   orderId: transportHomeController.pickUpOrdersFinalData
                       .result[index].orderId,
                   date: '23/02/2022',
                   productType: 'Petrol',
                   pickUpAddress:  'Vito Corleone #32, 6th main...',
                   deliveryAddress: 'A-654, Total Perol, Nairobi, Kenya,....',
                   pickLocationTap: () {},
                   deliveryLocationTap: () {},
                   viewDetailsTap: () {});
             },
           );
         }

         ),

        ],
      ),
    );*/
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:  AppColor.whiteColor,
        appBar: AppBar(

          elevation: 0,
          backgroundColor: AppColor.appThemeColor,
          title: Text('Orders'),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: AppColor.whiteColor,
              child: _tabBar,
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: ordersController.tabController,
          children: const [
            PendingOrdersTab(),
            DeliveredOrderTav(),
          ],
        ),
      ),
    );
  }
}

class PendingOrdersTab extends StatefulWidget {
  const PendingOrdersTab({Key? key}) : super(key: key);

  @override
  State<PendingOrdersTab> createState() => _PendingOrdersTabState();
}

class _PendingOrdersTabState extends State<PendingOrdersTab>
    with SingleTickerProviderStateMixin {
  OrdersController ordersController = Get.put(OrdersController());

//tabController = TabController(vsync: this, length: 2);
  @override
  initState() {
    super.initState();
    ordersController.tabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    /* return Container(
      child: Obx(
          () => Text((ordersController.isLoading) ? 'Loading' : 'Not Loading')),
    );*/
    return Obx(
      () => ordersController.isLoading
          ? CircularProgressIndicator()
          : ordersController.ordersFinalData.result.isEmpty
              ? Center(
                  child: Column(
                  children: [
                    Lottie.asset(
                        '${StringConstatnts.assets}Transpoter/truck.json',
                        height: 200,
                        width: 300),
                    Text('No Data Found'),
                  ],
                ))
              : ListView.builder(
                  itemCount: ordersController.ordersFinalData.result.length,
                  itemBuilder: (context, index) {
                    return OrdersWidget(
                        indexSelected: 0,
                        orderId: ordersController
                            .ordersFinalData.result[index].orderNo,
                        date: '23/02/2022',
                        productType: '',
                        pickUpAddress: ordersController
                            .ordersFinalData.result[index].vendorData.address,
                        deliveryAddress: ordersController
                            .ordersFinalData.result[index].stationData.address,
                        pickLocationTap: () async {
                          await MapLauncher.showMarker(
                            mapType: MapType.google,
                            coords: Coords(
                                double.parse(ordersController.ordersFinalData
                                    .result[index].vendorData.latitude),
                                double.parse(ordersController.ordersFinalData
                                    .result[index].vendorData.longitude)),
                            title: ordersController.ordersFinalData
                                .result[index].vendorData.address,
                          );
                        },
                        deliveryLocationTap: () async {
                          await MapLauncher.showMarker(
                            mapType: MapType.google,
                            coords: Coords(
                                double.parse(ordersController.ordersFinalData
                                    .result[index].stationData.latitude),
                                double.parse(ordersController.ordersFinalData
                                    .result[index].stationData.longitude)),
                            title: ordersController.ordersFinalData
                                .result[index].stationData.address,
                          );
                        },
                        viewDetailsTap: () {

                          Get.to(
                                  () => PendingOrderDetailsScreen(
                                  orderId: ordersController
                                      .ordersFinalData.result[index].orderId
                                      .toString()),
                              transition: Transition.rightToLeft,
                              duration: const Duration(
                                  milliseconds: 400));

                        });
                  }),
    );
  }
}

class DeliveredOrderTav extends StatefulWidget {
  const DeliveredOrderTav({Key? key}) : super(key: key);

  @override
  State<DeliveredOrderTav> createState() => _DeliveredOrderTavState();
}

class _DeliveredOrderTavState extends State<DeliveredOrderTav> {
  OrdersController ordersController = Get.put(OrdersController());

//tabController = TabController(vsync: this, length: 2);
  @override
  initState() {
    super.initState();
    ordersController.tabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ordersController.isLoading
          ? CircularProgressIndicator()
          : ordersController.ordersFinalData.result.isEmpty
              ? Center(
                  child: Column(
                  children: [
                    Lottie.asset(
                        '${StringConstatnts.assets}Transpoter/truck.json',
                        height: 200,
                        width: 300),
                    Text('No Data Found'),
                  ],
                ))
              : ListView.builder(
                  itemCount: ordersController.ordersFinalData.result.length,
                  itemBuilder: (context, index) {
                    /* return Container(
            child:
                Text(ordersController.ordersFinalData.result.length.toString()),
          );*/
                    return OrdersWidget(
                        indexSelected: 1,
                        orderId: ordersController
                            .ordersFinalData.result[index].orderNo,
                        date: ordersController
                            .ordersFinalData.result[index].deliveryDate,
                        productType: '',
                        pickUpAddress: ordersController
                            .ordersFinalData.result[index].vendorData.address,
                        deliveryAddress: ordersController
                            .ordersFinalData.result[index].stationData.address,
                        pickLocationTap: () {},
                        deliveryLocationTap: () {},
                        viewDetailsTap: () {
                          Get.to(
                                  () => DeliveredOrderDetailsScreen(
                                  orderId: ordersController
                                      .ordersFinalData.result[index].orderId
                                      .toString()),
                              transition: Transition.rightToLeft,
                              duration: const Duration(
                                  milliseconds: 400));
                          // print('hello ${ordersController
                          //     .ordersFinalData.result[index].id}');
                        });
                  }),
    );
  }
}
