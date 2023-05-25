// // ignore_for_file: prefer_const_constructors
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:owner_eqwi_petrol/Common/app_color.dart';
// import 'package:owner_eqwi_petrol/Common/string_constants.dart';
// import 'package:owner_eqwi_petrol/Screens/Manger/manager_driver_order_complete_screen.dart';
// import 'package:owner_eqwi_petrol/Screens/Manger/manager_order_payment_request_screen.dart';
// import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
//
// class TranspoterNotificationScreen extends StatefulWidget {
//   const TranspoterNotificationScreen({super.key});
//
//   @override
//   State<TranspoterNotificationScreen> createState() =>
//       _TranspoterNotificationScreenState();
// }
//
// class _TranspoterNotificationScreenState
//     extends State<TranspoterNotificationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ListView(
//         children: [
//           Container(
//             height: 76,
//             color: AppColor.appThemeColor,
//             width: MediaQuery.of(context).size.width,
//             child: Container(
//               margin: EdgeInsets.only(left: 16, right: 16),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(0),
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Text(
//                     'Notification',
//                     style: GoogleFonts.roboto(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: AppColor.whiteColor),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 24,
//           ),
//           GestureDetector(
//             onTap: () {},
//             child: Column(
//               children: [
//                 Container(
//                   height: 59,
//                   margin: EdgeInsets.only(left: 16, right: 16),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.asset(
//                         '${StringConstatnts.assets}profile_.png',
//                         height: 29,
//                       ),
//                       SizedBox(
//                         width: 14,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 'Lexo Station Ngong road',
//                                 style: GoogleFonts.roboto(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     color: AppColor.blackColor),
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width / 6,
//                               ),
//                               Icon(
//                                 Icons.access_time,
//                                 size: 13,
//                               ),
//                               Text(
//                                 '2 H ago',
//                                 style: GoogleFonts.roboto(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w400,
//                                     color: Color(0xFF878787)),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Image.asset(
//                                   '${StringConstatnts.assets}delete_.png')
//                             ],
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                             'Payment for order QZXD89745, consectetur\nadipiscing elit.',
//                             style: GoogleFonts.roboto(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 color: AppColor.appThemeColor),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           ListView.builder(
//             itemCount: 10,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) => GestureDetector(
//               onTap: () {},
//               child: Column(
//                 children: [
//                   Container(
//                     height: 59,
//                     margin: EdgeInsets.only(left: 16, right: 16, bottom: 24),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset(
//                           '${StringConstatnts.assets}profile_.png',
//                           height: 29,
//                         ),
//                         SizedBox(
//                           width: 14,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   'Lexo Station Ngong road',
//                                   style: GoogleFonts.roboto(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       color: AppColor.blackColor),
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width / 6,
//                                 ),
//                                 Icon(
//                                   Icons.access_time,
//                                   size: 13,
//                                 ),
//                                 Text(
//                                   '2 H ago',
//                                   style: GoogleFonts.roboto(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w400,
//                                       color: Color(0xFF878787)),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Image.asset(
//                                     '${StringConstatnts.assets}delete_.png')
//                               ],
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'The driver completed the delivery of Order\nID: #ZXCFG1239',
//                               style: GoogleFonts.roboto(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                   color: Color(0xFF555561)),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
