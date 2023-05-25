import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

class TransHomePickUpOrderWidget extends StatelessWidget {
  final String orderId, time, dateTime, pickUpAddress, dropAddress;
  final VoidCallback tapOnReject, tapOnAccept, tapForView;

  const TransHomePickUpOrderWidget(
      {Key? key,
      required this.orderId,
      required this.time,
      required this.dateTime,
      required this.pickUpAddress,
      required this.dropAddress,
      required this.tapOnReject,
      required this.tapOnAccept,
      required this.tapForView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapForView,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: const Color(0xFF000000).withOpacity(0.25),
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFD0EFD2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Order Request',
                    style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF0093D1)),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Order ID: #$orderId',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF696969)),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Text(
                    'Pickup',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    pickUpAddress,
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF696969)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: tapOnReject,
                    child: Container(
                      height: 30,
                      width: 126,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.blackColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Reject Order'.toUpperCase(),
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
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time left to accept',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF696969)),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 16,
                        width: 77,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.appThemeColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          time,
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    dateTime,
                    style: GoogleFonts.roboto(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF696969)),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFFC4C4C4),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Delivery',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    dropAddress,
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF696969)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: tapOnAccept,
                    child: Container(
                      height: 30,
                      width: 126,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.appThemeColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Accept Order'.toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TransCurrentOrdersWidget extends StatelessWidget {
  final VoidCallback tapOnDeliveries, tapOnPickupB, tapOnDeliveryB;
  final String id, dateTime, pickUpAddress, dropAddress;

  const TransCurrentOrdersWidget(
      {Key? key,
      required this.tapOnDeliveries,
      required this.id,
      required this.dateTime,
      required this.pickUpAddress,
      required this.dropAddress,
      required this.tapOnPickupB,
      required this.tapOnDeliveryB})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: const Color(0xFF000000).withOpacity(0.25),
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFD0EFD2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$id',
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF696969)),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  dateTime,
                  style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF696969)),
                ),
                const SizedBox(
                  height: 81,
                ),
                GestureDetector(
                  onTap: () {
                    /* Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TranspoterDeliveriesScreen(),
                    ));*/
                    //TranspoterDeliveriesScreen
                  },
                  child: Container(
                    height: 30,
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
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    InkWell(
                      onTap: tapOnPickupB,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: const Color(0xFF000000).withOpacity(0.25),
                            offset: const Offset(0, 2),
                          ),
                        ], borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(
                          '${StringConstatnts.assets}Transpoter/pickup.png',
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  pickUpAddress,
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF696969)),
                ),
                const SizedBox(
                  height: 9,
                ),
                Container(
                  height: 1,
                  color: const Color(0xFFC4C4C4),
                  width: 109,
                ),
                const SizedBox(
                  height: 15,
                ),
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
                    ),
                    InkWell(
                      onTap: tapOnDeliveryB,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: const Color(0xFF000000).withOpacity(0.25),
                            offset: const Offset(0, 2),
                          ),
                        ], borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(
                          '${StringConstatnts.assets}Transpoter/pickup.png',
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  dropAddress,
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF696969)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TransHomeMyAvailabilityWidget extends StatelessWidget {
  final VoidCallback tapAvail, tapNotAvail;
  final Color textColor, buttonColor;
  final String dateData;

  const TransHomeMyAvailabilityWidget(
      {Key? key,
      required this.tapAvail,
      required this.tapNotAvail,
      required this.textColor,
      required this.buttonColor,
      required this.dateData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: const Color(0xFF000000).withOpacity(0.25),
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFD0EFD2),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 12, right: 10, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today $dateData',
              style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF606060)),
            ),
            const SizedBox(
              height: 11,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: tapAvail,
                  child: Container(
                    height: 30,
                    width: 145,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: buttonColor,
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
                              color: textColor),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset('${StringConstatnts.assets}correct.png')
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: tapNotAvail,
                  child: Container(
                    height: 30,
                    width: 145,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: buttonColor,
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
                              color: textColor),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset('${StringConstatnts.assets}correct.png')
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
  }
}

class TransOrderViewHomePageWidget extends StatelessWidget {
  final VoidCallback tapOnPickupL,
      tapOnDeliveryL,
      tapPickUpCall,
      tapPickUpChat,
      tapDelCall,
      tapDelChart,
      tapOnDeliveredB,
      tapOnViewAll,tapOnViewDetails;
  final String pickUpAddress, productType, productQty,contactPerson,deliveryAddress;

  const TransOrderViewHomePageWidget(
      {Key? key,
      required this.tapOnPickupL,
      required this.tapOnDeliveryL,
      required this.pickUpAddress,
      required this.productType,
      required this.productQty,
      required this.tapPickUpCall,
      required this.tapPickUpChat,
      required this.tapDelCall,
      required this.tapDelChart,
      required this.tapOnDeliveredB,
      required this.tapOnViewAll, required this.tapOnViewDetails, required this.contactPerson, required this.deliveryAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, top: 23),
          child: Row(
            children: [
              Text(
                'Pickup',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF696969)),
              ),
              const SizedBox(
                width: 19,
              ),
              InkWell(
                onTap: tapOnPickupL,
                child: Container(
                  height: 26,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: const Color(0xFF000000).withOpacity(0.25),
                      offset: const Offset(0, 4),
                    ),
                  ], borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    '${StringConstatnts.assets}Transpoter/pickup.png',
                    height: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(left: 16, right: 18, top: 10, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup Address:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: 57,
                    ),
                    Text(
                      'Pickup Product:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Product Qty:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickUpAddress,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      productType,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      productQty,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: 100,
                child: CommonIconButton(
                    tapIconButton: tapPickUpCall,
                    buttonColor: AppColor.appThemeColor,
                    buttonText: 'Call',
                    iconDataD: Icons.call,
                    textColorData: Colors.white),
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                width: 100,
                child: CommonIconButton(
                    tapIconButton: tapPickUpChat,
                    buttonColor: AppColor.blackColor,
                    buttonText: 'Chat',
                    iconDataD: Icons.chat_outlined,
                    textColorData: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16),
          height: 8,
          color: const Color(0xFFF3F3F3),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, top: 23),
          child: Row(
            children: [
              Text(
                'Delivery ',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF696969)),
              ),
              const SizedBox(
                width: 19,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => TransporterNavigationMapScreen(),
                  // ));
                },
                child: Container(
                  height: 26,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: const Color(0xFF000000).withOpacity(0.25),
                      offset: const Offset(0, 4),
                    ),
                  ], borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    '${StringConstatnts.assets}Transpoter/pickup.png',
                    height: 26,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: tapOnViewDetails,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF696969)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(left: 16, right: 18, top: 10, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: 57,
                    ),
                    Text(
                      'Product Qty:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Contact Person:',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryAddress,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      productQty,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      contactPerson,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF828282)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 32,
                width: 100,
                child: CommonIconButton(
                    tapIconButton: tapDelCall,
                    buttonColor:  AppColor.appThemeColor,
                    buttonText: 'Call',
                    iconDataD: Icons.call,
                    textColorData: Colors.white),
              ),
              SizedBox(
                height: 32,
                width: 110,
                child: CommonIconButton(
                    tapIconButton: tapOnDeliveredB,
                    buttonColor:  AppColor.appThemeColor,
                    buttonText: 'Delivered',
                    iconDataD: Icons.delivery_dining_outlined,
                    textColorData: Colors.white),
              ),
              SizedBox(
                height: 32,
                width: 100,
                child: CommonIconButton(
                    tapIconButton: tapDelChart,
                    buttonColor: AppColor.blackColor,
                    buttonText: 'Chat',
                    iconDataD: Icons.chat_outlined,
                    textColorData: Colors.white),
              ),
            /*  Container(
                height: 32,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.appThemeColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      '${StringConstatnts.assets}Transpoter/call_black.png',
                      height: 20,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Call',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  *//*  showDialog(
                      context: context,
                      builder: (context) {
                        return DeliveryConformationPopup();
                      });*//*
                },
                child: Container(
                  height: 32,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.appThemeColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Delivered',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 32,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.blackColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      '${StringConstatnts.assets}Transpoter/chat.png',
                      height: 20,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Chat',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16),
          height: 8,
          color: const Color(0xFFF3F3F3),
        ),
      ],
    );
  }
}
