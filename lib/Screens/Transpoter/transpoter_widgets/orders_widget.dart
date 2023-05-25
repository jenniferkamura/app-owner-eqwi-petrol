import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_navigation_map_screen.dart';

class OrdersWidget extends StatelessWidget {
  final int indexSelected;
  final String orderId, date, productType, pickUpAddress, deliveryAddress;
  final VoidCallback pickLocationTap, deliveryLocationTap, viewDetailsTap;

  const OrdersWidget(
      {Key? key,
      required this.indexSelected,
      required this.orderId,
      required this.date,
      required this.productType,
      required this.pickUpAddress,
      required this.deliveryAddress,
      required this.pickLocationTap,
      required this.deliveryLocationTap,
      required this.viewDetailsTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFDADADA),
            ),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 8, bottom: 4, left: 16, right: 16),
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(top: 10, left: 10, right: 12, bottom: 17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFFE8E8E8),
                    ),
                    child: Image.asset('assets/images/Transpoter/prt_colour.png'),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Order ID: ',
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFA0A0A0)),
                          children: <InlineSpan>[
                            TextSpan(
                              text: orderId,
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor),
                            )
                          ],
                        ),
                      ),
                      Text(
                        date,
                        style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFA0A0A0)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    productType,
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF5C5C5C)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 12, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex:5,
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
                              width: 19,height: 0,
                            ),
                            if (indexSelected == 0)
                              InkWell(
                                onTap: pickLocationTap,
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
                      ],
                    ),
                  ),
                  Expanded(
                    flex:5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            ),
                            if (indexSelected == 0)
                              GestureDetector(
                                onTap: deliveryLocationTap,
                                // onTap: () {
                                //   Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const TransporterNavigationMapScreen(),
                                //   ));
                                // },
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color:
                                          const Color(0xFF000000).withOpacity(0.25),
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
                          deliveryAddress,
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
            ),
            Container(
              height: 1,
              color: const Color(0xFFBDBDBD),
            ),
            GestureDetector(
              /*onTap: () {
                *//*  if (indexSelected == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TransporterAcceptOrderScreenD(orderId: 'ZtC'),
                  ));
                } else if (indexSelected == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TranspoterDeliveredScreen(name: 'Delivered'),
                  ));
                }*//*
              },*/
              onTap: ()=>viewDetailsTap(),
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 6, left: 10, bottom: 6),
                child: Text(
                  'View Details',
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF787878)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
