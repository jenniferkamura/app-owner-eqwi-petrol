import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

class DeliveriesDataWidget extends StatelessWidget {
  final String dateType,address,productType,productQty,orderId,type;
  final VoidCallback tapOnLocationB,tapOnViewDetailsB,tapOnCallB,tapOnDelivered,tapOnChatB;
  const DeliveriesDataWidget({Key? key, required this.dateType, required this.address, required this.productType, required this.productQty, required this.tapOnLocationB, required this.tapOnViewDetailsB, required this.tapOnCallB, required this.tapOnDelivered, required this.tapOnChatB, required this.orderId, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                dateType,
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF696969)),
              ),
              const SizedBox(
                width: 10,
                height: 0,
              ),
               GestureDetector(
                onTap: tapOnLocationB/*() {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => TransporterNavigationMapScreen(),
                  // ));
                }*/,
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
              type == 'yes'? GestureDetector(
                onTap: tapOnViewDetailsB,
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
              ):const SizedBox(height: 0,width: 0,),
            ],
          ),
          const SizedBox(height: 15,width: 0,),
          type == 'yes'? Text('Order ID: $orderId',style: GoogleFonts.roboto(
          fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF828282),)):const SizedBox(height: 0,width: 0,),
          const SizedBox(height: 15,width: 0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text('Delivery Address:',style: GoogleFonts.roboto(
               fontSize: 14,
               fontWeight: FontWeight.w400,
               color: const Color(0xFF828282),)),
              const Spacer(),
               Expanded(
                  child: Text(address,style: GoogleFonts.roboto(
                  fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF828282),))),
            ],
          ),
          const SizedBox(height: 15,width: 0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text('Pickup Product   ',style: GoogleFonts.roboto(
               fontSize: 14,
               fontWeight: FontWeight.w400,
               color: const Color(0xFF828282),)),
              const Spacer(),
              Expanded(
                  child: Text(
                      productType,style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF828282),))),
            ],
          ),
          const SizedBox(height: 15,width: 0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text('Pickup Qty:           ',style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF828282),)),
              const Spacer(),
              Expanded(
                  child: Text(
                      productQty,style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF828282),))),
            ],
          ),
          const SizedBox(height: 15,width: 0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 32,
                width: 100,
                child: CommonIconButton(
                    tapIconButton: tapOnCallB,
                    buttonColor:  AppColor.appThemeColor,
                    buttonText: 'Call',
                    iconDataD: Icons.call,
                    textColorData: Colors.white),
              ),
              type == 'yes'?  SizedBox(
                height: 32,
                width: 110,
                child: CommonIconButton(
                    tapIconButton: tapOnDelivered,
                    buttonColor:  AppColor.appThemeColor,
                    buttonText: 'Delivered',
                    iconDataD: Icons.delivery_dining_outlined,
                    textColorData: Colors.white),
              ):const SizedBox(height: 0,width: 0,),
              SizedBox(
                height: 32,
                width: 100,
                child: CommonIconButton(
                    tapIconButton: tapOnChatB,
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
        ],
      ),
    );
  }
}
