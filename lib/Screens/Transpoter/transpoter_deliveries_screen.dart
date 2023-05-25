// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/delivery_conformation_popup.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_pop_up/confirm_pop_up.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_pop_up/payment_pending_pop.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_order_details_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_navigation_map_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_widgets/add_fuel_b_sheet_widget.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class TransporterDeliveriesScreen extends StatefulWidget {
  String? orderId;

  TransporterDeliveriesScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<TransporterDeliveriesScreen> createState() =>
      _TransporterDeliveriesScreenState();
}

class _TransporterDeliveriesScreenState
    extends State<TransporterDeliveriesScreen> {
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());
  String? userToken = Constants.prefs?.getString('user_token');

/*
  @override
  void initState() {
    if (kDebugMode) {
      print('orderId>> ${widget.orderId}');
      print('hello >>');
    }
    transportHomeController.acceptOrderDetailsFun(userToken!, widget.orderId,
        isLoad: true);
    super.initState();
  }
*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transportHomeController.getCompartmentsFun(userToken!);
  }

  @override
  Future<void> didChangeDependencies() async {
    // if (kDebugMode) {
    //   print('widget.orderId >> ${widget.orderId}');
    //   print('userToken >> $userToken');
    // }
    await transportHomeController
        .acceptOrderDetailsFun(userToken!, widget.orderId, isLoad: true);
    super.didChangeDependencies();
  }

  tapOnReached() async {
    await showDialog(
        context: context,
        builder: (_) {
          return ConfirmPopUpTransporter(
              tapAction: () async {
                await transportHomeController.reachButtonOrderActionFun(
                  userToken.toString(),
                  widget.orderId,
                  transportHomeController.acceptOrderDetailsFinalData.id
                      .toString(),
                  'Reach',
                );
              },
              type: 'Reach');
        });


  }

  addFuelButton(String? catId) async {
    print('0000000000');
    print(catId);
    print('999999999');
    await showModalBottomSheet(
        context: context,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              /* return Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Select Compartments',
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transportHomeController
                          .getCompartmentData.data.length,
                      itemBuilder: (context, index) {
                        String item = transportHomeController
                            .getCompartmentData.data[index].compartmentNo;
                        return CheckboxListTile(
                          activeColor: AppColor.appThemeColor,
                          title: Text('Compartment No :$item',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          value: transportHomeController.selectedItems
                              .contains(item),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                transportHomeController.selectedItems.add(item);
                                print(transportHomeController.selectedItems);
                                num sum = 0;
                                sum = transportHomeController
                                    .getCompartmentData.data
                                    .fold(
                                        0,
                                        (previous, current) =>
                                            previous +
                                            int.parse(transportHomeController
                                                .getCompartmentData
                                                .data[index]
                                                .compartmentCapacity));

                                print(sum);
                                // for(var i=0;i<transportHomeController.getCompartmentData.data.length;i++){
                                //   sum = int.parse(transportHomeController.getCompartmentData.data[i].compartmentCapacity);
                                //
                                // }
                              } else {
                                transportHomeController.selectedItems
                                    .remove(item);
                              }
                            });
                            // transportHomeController.compartmentTextData.value = value.obs.string;// Use GetX update function to update the UI
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (transportHomeController.selectedItems.isEmpty) {
                          Fluttertoast.showToast(
                              msg:
                                  'please select how many compartments do you using',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 12.0);
                        } else {
                          transportHomeController.addFuelFun(
                              userToken!,
                              widget.orderId.toString(),
                              transportHomeController.selectedItems);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.appThemeColor,
                          padding:
                              EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      child: Text('Submit'),
                    ),
                    SizedBox(
                      height: 10,
                      width: 0,
                    ),
                  ],
                ),
              );*/

              return Obx(() => AddFuelBSheetWidget(
                    widget: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transportHomeController
                          .getCompartmentData.data.length,
                      itemBuilder: (context, index) {
                        String item = transportHomeController
                            .getCompartmentData.data[index].compartmentNo;
                        return CheckboxListTile(
                          activeColor: AppColor.appThemeColor,
                          title: Text('Compartment No :$item',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          value: transportHomeController.selectedItems
                              .contains(item.toString()),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                transportHomeController.selectedItems.add(item.toString());
                                print(transportHomeController.selectedItems);
                                /*num sum = 0;
                                sum = transportHomeController
                                    .getCompartmentData.data
                                    .fold(
                                        0,
                                        (previous, current) =>
                                            previous +
                                            int.parse(transportHomeController
                                                .getCompartmentData
                                                .data[index]
                                                .compartmentCapacity));

                                print(sum);*/
                                // for(var i=0;i<transportHomeController.getCompartmentData.data.length;i++){
                                //   sum = int.parse(transportHomeController.getCompartmentData.data[i].compartmentCapacity);
                                //
                                // }
                              } else {
                                transportHomeController.selectedItems
                                    .remove(item.toString());
                              }
                            });
                            // transportHomeController.compartmentTextData.value = value.obs.string;// Use GetX update function to update the UI
                          },
                        );
                      },
                    ),
                    onPressed: () {
                      if (transportHomeController.selectedItems.isEmpty) {
                        Fluttertoast.showToast(
                            msg:
                            'please select how many compartments do you using',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 12.0);
                      } else {
                        transportHomeController.addFuelFun(
                            userToken!,
                            widget.orderId.toString(),
                            transportHomeController.selectedItems,catId.toString()
                            );
                      }
                    },
                    onPressedBack: () {
                      Get.back();
                      transportHomeController.selectedItems = [].obs;
                    },isLoad: transportHomeController.addFuelLoad.value,
                  ));
            },
          );
        });
  }

  tapOnLoaded() async {
    print(transportHomeController.acceptOrderDetailsFinalData.orderData?.isAddFuel);
    if(transportHomeController.acceptOrderDetailsFinalData.orderData?.isAddFuel == 0){
      Fluttertoast.showToast(
          msg: 'Please First Select Which Compartment Do You Want To Fill',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }else{
      await showDialog(
          context: context,
          builder: (_) {
            return ConfirmPopUpTransporter(
                tapAction: () async {
                  await transportHomeController.reachOrderActionFun(
                      userToken!,
                      widget.orderId,
                      transportHomeController.acceptOrderDetailsFinalData.id
                          .toString(),
                      'Loaded',
                      '',
                      '',
                      '',
                      '',
                      '');
                },
                type: 'Loaded');
          });
    }

  }

  // tapOnLoaded() {
  //   print('hello');
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return DeliveryConformationPopup();
  //       });
  // }

  deliveredOnTap() async {
    await transportHomeController.deliveryActionFun(
        userToken!,
        widget.orderId,
        transportHomeController.acceptOrderDetailsFinalData.id.toString(),
        'Delivered',
        '',
        '',
        '',
        '',
        '');
    transportHomeController.finalDeliveryData.paymentPending == 1
        ? showDialog(
            context: context,
            builder: (_) {
              return PaymentPendingPopUp(
                currency: transportHomeController.finalDeliveryData.currency
                    .toString(),
                amount: transportHomeController.finalDeliveryData.pendingAmount
                    .toString(),
                orderId: widget.orderId.toString(),
                assignOrderId: transportHomeController
                    .acceptOrderDetailsFinalData.id
                    .toString(),
              );
            })
        : showDialog(
            context: context,
            builder: (_) {
              return DeliveryConformationPopup(
                  userToken: userToken!,
                  orderId: widget.orderId.toString(),
                  assignOrderId: transportHomeController
                      .acceptOrderDetailsFinalData.id
                      .toString(),
                  orderStatus: 'Delivered',
                  reasonTitle: '',
                  reasonDescription: '',
                  orderDetailsId: '',
                  otp: '',
                  signatureFile: '');
            });
  }

  // final Uri phoneNumber = Uri.parse('tel:+919676941819');
  //final Uri whatsApp = Uri.parse('https://wa.me/19676941819');

  void _launchWhatsapp(number, text) async {
    var whatsappAndroid = Uri.parse("https://wa.me/+919098576433");
    // Uri.parse("whatsapp://send?phone='+91'+$number&text=$text");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(
          Uri.parse('whatsapp://send?phone=+91' + number + '&text=$text'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  launchWhatsApp() async {
    /*final link = WhatsAppUnilink(
      phoneNumber: '+91${9999999999}',
      text: "Hello Sir",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');*/
  }

  Future<bool> _willPopCallback() async {
    await transportHomeController.transportPickUpOrdersFun(
        userToken.toString(), 'Pending',
        isLoad: true);
    await transportHomeController.transportCurrentOrdersFun(
        userToken.toString(), 'Accept',
        isLoad: true);
    await transportHomeController.transportHomeFun(userToken.toString());
    // await showDialog or Show add banners or whatever
    // then
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
          _willPopCallback();
          Get.back();
        }, title: 'Order Id: ${widget.orderId}'),
        /*body: ListView.builder(
            itemCount: deliveriesDataModel.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DeliveriesDataWidget(
                  type: deliveriesDataModel[index].type.toString(),
                  dateType: deliveriesDataModel[index].dataType.toString(),
                  orderId: deliveriesDataModel[index].orderId.toString(),
                  address: deliveriesDataModel[index].address.toString(),
                  productType: deliveriesDataModel[index].productType.toString(),
                  productQty: deliveriesDataModel[index].productQty.toString(),
                  tapOnLocationB: () {},
                  tapOnViewDetailsB: () {
                    Get.to(TranspoterDeliveredScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 400));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => TranspoterDeliveredScreen(),
                    // ));
                  },
                  tapOnDelivered: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DeliveryConformationPopup();
                        });
                  },
                  tapOnCallB: () {},
                  tapOnChatB: () {},
                ),
              );
            }),*/
        body: Obx(
          () => transportHomeController.isAcceptOrderDetailsLoad.value
              ? Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColor.appThemeColor))
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  physics: BouncingScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Text(
                          'Pickup',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF696969)),
                        ),
                        SizedBox(
                          width: 19,
                        ),
                        InkWell(
                          onTap: () async {
                            await MapLauncher.showMarker(
                              mapType: MapType.google,
                              coords: Coords(
                                  double.parse(
                                      '${transportHomeController.acceptOrderDetailsFinalData.vendorData?.latitude.toString()}'),
                                  double.parse(
                                      '${transportHomeController.acceptOrderDetailsFinalData.vendorData?.longitude.toString()}')),
                              title:
                                  '${transportHomeController.acceptOrderDetailsFinalData.vendorData?.address.toString()}',
                            );
                          },
                          child: Container(
                            height: 26,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0xFF000000).withOpacity(0.25),
                                offset: Offset(0, 4),
                              ),
                            ], borderRadius: BorderRadius.circular(10)),
                            child: Image.asset(
                              '${StringConstatnts.assets}Transpoter/pickup.png',
                              height: 26,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                      width: 0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pickup Address:',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        Spacer(),
                        Expanded(
                          child: Text(
                            '${transportHomeController.acceptOrderDetailsFinalData.vendorData?.address}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF828282)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                      width: 0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 32,
                          width: 100,
                          child: CommonIconButton(
                              tapIconButton: () async {
                                await launchUrl(Uri.parse(
                                    'tel:${transportHomeController.acceptOrderDetailsFinalData.vendorData?.contactNo}'));
                              },
                              buttonColor: AppColor.appThemeColor,
                              buttonText: 'Call',
                              iconDataD: Icons.call,
                              textColorData: Colors.white),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 32,
                          width: 100,
                          child: CommonIconButton(
                              tapIconButton: () async {
                                _launchWhatsapp(
                                    transportHomeController
                                        .acceptOrderDetailsFinalData
                                        .vendorData
                                        ?.contactNo,
                                    'hello');
                              },
                              buttonColor: AppColor.blackColor,
                              buttonText: 'Chat',
                              iconDataD: Icons.chat_outlined,
                              textColorData: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      height: 8,
                      color: Color(0xFFF3F3F3),
                    ),
                    Row(
                      children: [
                        Text(
                          'Delivery',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 19,
                        ),
                        GestureDetector(
                          onTap: () async {
                            /*  Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  TransporterNavigationMapScreen(),
                            ));*/
                            await MapLauncher.showMarker(
                              mapType: MapType.google,
                              coords: Coords(
                                  double.parse(
                                      '${transportHomeController.acceptOrderDetailsFinalData.stationData?.latitude.toString()}'),
                                  double.parse(
                                      '${transportHomeController.acceptOrderDetailsFinalData.stationData?.longitude.toString()}')),
                              title:
                                  '${transportHomeController.acceptOrderDetailsFinalData.stationData?.address.toString()}',
                            );
                          },
                          child: Container(
                            height: 26,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0xFF000000).withOpacity(0.25),
                                offset: Offset(0, 4),
                              ),
                            ], borderRadius: BorderRadius.circular(10)),
                            child: Image.asset(
                              '${StringConstatnts.assets}Transpoter/pickup.png',
                              height: 26,
                            ),
                          ),
                        ),
                        Spacer(), //TranspoterDeliveredScreen
                        /* GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TranspoterDeliveredScreen(),
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Text(
                              'View Details',
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF696969)),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    SizedBox(
                      height: 15,
                      width: 0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Order ID: #KJGFU25499
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Address:',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Expanded(
                              child: Text(
                                  '${transportHomeController.acceptOrderDetailsFinalData.stationData?.address}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF828282))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                          width: 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ContactPerson',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Expanded(
                              child: Text(
                                  '${transportHomeController.acceptOrderDetailsFinalData.stationData?.contactPerson}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 6,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF828282))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                          width: 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'StationName',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Expanded(
                              child: Text(
                                  '${transportHomeController.acceptOrderDetailsFinalData.stationData?.stationName}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF828282))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                          width: 0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                      width: 0,
                    ),
                    ListView.builder(
                        itemCount: transportHomeController
                            .acceptOrderDetailsFinalData
                            .orderData
                            ?.orderDetails
                            ?.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        clipBehavior: Clip.hardEdge,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {

                          return Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.appThemeColor, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Product',
                                        style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                    Text(
                                        '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].name.toString()}',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF828282))),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                  width: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Order Date',
                                        style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                    Text(
                                        '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].cartCreated.toString()}',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF828282))),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                  width: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Product Qty',
                                        style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                    Text(
                                        '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].qty.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].measurement.toString()}',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF828282))),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                  width: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Price',
                                        style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                    Text(
                                        '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].price.toString()}',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF828282))),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                  width: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Price',
                                        style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                    Text(
                                        '${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].totalPrice.toString()}',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.green)),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                  width: 0,
                                ),
                                ElevatedButton(
                                  onPressed: transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].addFuel == 0?() {

                                    print(transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].addFuel);
                                    addFuelButton(
                                        transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].categoryId.toString());
                                  }:(){
                                    print(transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].addFuel);

                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: transportHomeController.acceptOrderDetailsFinalData.orderData?.orderDetails?[index].addFuel == 0?AppColor.appThemeColor:Colors.grey.shade300,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 0),
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  child: Text('Add Fuel'),
                                ),
                              ],
                            ),
                          );
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Amount',
                            style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        Text(
                            '${transportHomeController.acceptOrderDetailsFinalData.orderData?.currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.amount.toString()}',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF828282))),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                      width: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tax',
                            style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        Text(
                            '${transportHomeController.acceptOrderDetailsFinalData.orderData?.currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.tax.toString()}',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF828282))),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                      width: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Charge',
                            style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        Text(
                            '${transportHomeController.acceptOrderDetailsFinalData.orderData?.currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.shippingCharge.toString()}',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF828282))),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                      width: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount',
                            style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        Text(
                            '${transportHomeController.acceptOrderDetailsFinalData.orderData?.currency.toString()} ${transportHomeController.acceptOrderDetailsFinalData.orderData?.totalAmount.toString()}',
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.green)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                      width: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 32,
                          width: 100,
                          child: CommonIconButton(
                              tapIconButton: () async {
                                await launchUrl(Uri.parse(
                                    'tel:${transportHomeController.acceptOrderDetailsFinalData.orderData?.contactNumber}'));
                              },
                              buttonColor: AppColor.appThemeColor,
                              buttonText: 'Call',
                              iconDataD: Icons.call,
                              textColorData: Colors.white),
                        ),
                        SizedBox(
                          height: 32,
                          width: 110,
                          child: Obx(
                            () {
                              return /* (transportHomeController.isReachLoad.value ||
                                  transportHomeController
                                      .isDeliveryActionLoad.value)
                                  ? SizedBox(
                                height: 32,
                                width: 110,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: AppColor.appThemeColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 30),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                                  :*/

                                  CommonIconButton(
                                      tapIconButton: (transportHomeController
                                                  .acceptOrderDetailsFinalData
                                                  .orderData
                                                  ?.displayStatus
                                                  .toString() ==
                                              'Reach')
                                          ? tapOnReached
                                          : (transportHomeController
                                                      .acceptOrderDetailsFinalData
                                                      .orderData
                                                      ?.displayStatus
                                                      .toString() ==
                                                  'Loaded')
                                              ? tapOnLoaded
                                              : deliveredOnTap,
                                      buttonColor: AppColor.appThemeColor,
                                      buttonText: (transportHomeController
                                                  .acceptOrderDetailsFinalData
                                                  .orderData
                                                  ?.displayStatus
                                                  .toString() ==
                                              'Reach')
                                          ? 'Reached'
                                          : (transportHomeController
                                                      .acceptOrderDetailsFinalData
                                                      .orderData
                                                      ?.displayStatus
                                                      .toString() ==
                                                  'Loaded')
                                              ? 'Loaded'
                                              : 'Delivered',
                                      iconDataD: Icons.fire_truck_outlined,
                                      textColorData: Colors.white);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          width: 100,
                          child: CommonIconButton(
                              tapIconButton: () async {
                                _launchWhatsapp(
                                    transportHomeController
                                        .acceptOrderDetailsFinalData
                                        .orderData
                                        ?.contactNumber,
                                    'hello');
                              },
                              buttonColor: AppColor.blackColor,
                              buttonText: 'Chat',
                              iconDataD: Icons.chat_outlined,
                              textColorData: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
