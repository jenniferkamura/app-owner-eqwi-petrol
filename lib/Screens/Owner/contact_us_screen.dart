// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/drawer_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Transpoter/common/trans_common_app_bar.dart';
import '../Transpoter/transpoter_home_widgets/contact_us_widget.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  DrawerDataController drawerDataController = Get.put(DrawerDataController());

  Future<void> _sendMail(String mailId) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: mailId,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TransAppBarCustom.commonAppBarCustom(onTaped: () {
        Navigator.pop(context);
      }, title: 'Contact Us', context),
      body: GetX<DrawerDataController>(
        initState: (_) => DrawerDataController.to.contactUsFun(),
        builder: (ddc) => ddc.contactUsLoad.value
            ? Center(
                child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.appThemeColor,
              ))
            : ContactUsWidget(
                imageUrl: '${StringConstatnts.assets}contaus.png',
                siteName: '${ddc.contactUsFinalData.contactEmail}',
                description: 'Visit our website here',
                connectLink: '${ddc.contactUsFinalData.contactWebsiteUrl}',
            tapONMobile: () async {
              await launchUrl(Uri.parse(
                  'tel:${ddc.contactUsFinalData.contactMobileNo}'));
            },
            tapONLandMobile: () async {
              await launchUrl(Uri.parse(
                  'tel:${ddc.contactUsFinalData.contactLandlineNo}'));
            },
            tapOnEmail: () {
              _sendMail(ddc.contactUsFinalData.contactEmail.toString());
            },
                onTapOnLink: () async {
                  if (await launchUrl(Uri.parse(
                      '${ddc.contactUsFinalData.contactWebsiteUrl}'))) {
                    await launchUrl(Uri.parse(
                        '${ddc.contactUsFinalData.contactWebsiteUrl}'));
                  } else {
                    throw 'Could not launch ${Uri.parse('${ddc.contactUsFinalData.contactWebsiteUrl}')}';
                  }
                },
                connectLinkText: '${ddc.contactUsFinalData.contactEmail}',
                mobileNumber: '${ddc.contactUsFinalData.contactLandlineNo}',
                secondNumber: '${ddc.contactUsFinalData.contactMobileNo}'),
      ),
    );
  }
}
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: SafeArea(
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Container(
  //               height: 76,
  //               color: AppColor.appThemeColor,
  //               width: MediaQuery.of(context).size.width,
  //               child: Container(
  //                 margin: EdgeInsets.only(left: 16, right: 16),
  //                 child: Row(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Container(
  //                         height: 24,
  //                         decoration: BoxDecoration(
  //                           color: AppColor.whiteColor,
  //                           borderRadius: BorderRadius.circular(24 / 2),
  //                           boxShadow: [
  //                             BoxShadow(
  //                                 color: AppColor.blackColor.withOpacity(0.25),
  //                                 offset: Offset(0, 4),
  //                                 blurRadius: 4),
  //                           ],
  //                         ), //#
  //                         alignment: Alignment.center,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(0),
  //                           child: Image.asset(
  //                               '${StringConstatnts.assets}back.png'),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 16,
  //                     ),
  //                     Text(
  //                       'Contact Us',
  //                       style: GoogleFonts.roboto(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w500,
  //                           color: AppColor.whiteColor),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Center(
  //               child: Image.asset(
  //                 '${StringConstatnts.assets}contaus.png',
  //                 height: 150,
  //               ),
  //             ),
  //             Container(
  //               height: 32,
  //               margin: EdgeInsets.only(left: 16, top: 28),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     height: 32,
  //                     width: 32,
  //                     decoration: BoxDecoration(
  //                         color: AppColor.appThemeColor,
  //                         borderRadius: BorderRadius.circular(5),
  //                         boxShadow: [
  //                           BoxShadow(
  //                               color: Colors.black.withOpacity(0.25),
  //                               blurRadius: 4,
  //                               offset: Offset(0, 2))
  //                         ]),
  //                     child: Image.asset('${StringConstatnts.assets}web.png'),
  //                   ),
  //                   SizedBox(
  //                     width: 12,
  //                   ),
  //                   Text(
  //                     'www.eqwi.com',
  //                     style: GoogleFonts.roboto(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                         color: AppColor.blackColor),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(left: 16, top: 16, right: 25),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     height: 32,
  //                     width: 32,
  //                     decoration: BoxDecoration(
  //                         color: AppColor.appThemeColor,
  //                         borderRadius: BorderRadius.circular(5),
  //                         boxShadow: [
  //                           BoxShadow(
  //                               color: Colors.black.withOpacity(0.25),
  //                               blurRadius: 4,
  //                               offset: Offset(0, 2))
  //                         ]),
  //                     child: Image.asset('${StringConstatnts.assets}web.png'),
  //                   ),
  //                   SizedBox(
  //                     width: 12,
  //                   ),
  //                   Text(
  //                     'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Morbi tincidunt auctor\niaculis. Nulla vitae tempus tortor. Aenean\nsit amet dolor urna. Nam aliquam velit\neros, ac ultricies tortor ultricies accumsan.',
  //                     maxLines: 6,
  //                     style: GoogleFonts.roboto(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w400,
  //                         color: AppColor.blackColor),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               alignment: Alignment.topLeft,
  //               margin: EdgeInsets.only(left: 60),
  //               child: Text(
  //                 'connect@eqwi.com',
  //                 style: GoogleFonts.roboto(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w400,
  //                     color: Color(0xFF0063D7)),
  //               ),
  //             ),
  //             Container(
  //               height: 32,
  //               margin: EdgeInsets.only(left: 16, top: 28),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     height: 32,
  //                     width: 32,
  //                     decoration: BoxDecoration(
  //                         color: AppColor.appThemeColor,
  //                         borderRadius: BorderRadius.circular(5),
  //                         boxShadow: [
  //                           BoxShadow(
  //                               color: Colors.black.withOpacity(0.25),
  //                               blurRadius: 4,
  //                               offset: Offset(0, 2))
  //                         ]),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: Image.asset(
  //                         '${StringConstatnts.assets}mobile.png',
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 12,
  //                   ),
  //                   Text(
  //                     '00-1236565665',
  //                     style: GoogleFonts.roboto(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                         color: AppColor.blackColor),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               height: 32,
  //               margin: EdgeInsets.only(left: 16, top: 28),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     height: 32,
  //                     width: 32,
  //                     decoration: BoxDecoration(
  //                         color: AppColor.appThemeColor,
  //                         borderRadius: BorderRadius.circular(5),
  //                         boxShadow: [
  //                           BoxShadow(
  //                               color: Colors.black.withOpacity(0.25),
  //                               blurRadius: 4,
  //                               offset: Offset(0, 2))
  //                         ]),
  //                     child: Image.asset(
  //                       '${StringConstatnts.assets}mail.png',
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 12,
  //                   ),
  //                   Text(
  //                     'connect@eqwi.com',
  //                     style: GoogleFonts.roboto(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                         color: AppColor.blackColor),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               height: 32,
  //               margin: EdgeInsets.only(left: 16, top: 28),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     height: 32,
  //                     width: 32,
  //                     decoration: BoxDecoration(
  //                         color: AppColor.appThemeColor,
  //                         borderRadius: BorderRadius.circular(5),
  //                         boxShadow: [
  //                           BoxShadow(
  //                               color: Colors.black.withOpacity(0.25),
  //                               blurRadius: 4,
  //                               offset: Offset(0, 2))
  //                         ]),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: Image.asset(
  //                         '${StringConstatnts.assets}mobile.png',
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 12,
  //                   ),
  //                   Text(
  //                     '00-9874562365',
  //                     style: GoogleFonts.roboto(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                         color: AppColor.blackColor),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

