import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

class ContactUsWidget extends StatelessWidget {
  final String imageUrl,
      siteName,
      description,
      connectLink,
      connectLinkText,
      mobileNumber,
      secondNumber;
  final VoidCallback onTapOnLink;
  final VoidCallback tapONLandMobile;
  final VoidCallback tapONMobile;
  final VoidCallback tapOnEmail;

  const ContactUsWidget(
      {Key? key,
      required this.imageUrl,
      required this.siteName,
      required this.description,
      required this.connectLink,
      required this.mobileNumber,
      required this.secondNumber,
      required this.connectLinkText,
      required this.onTapOnLink,required this.tapONLandMobile,required this.tapONMobile,required this.tapOnEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                imageUrl,
                height: 150,
              ),
            ),
            Container(
              height: 32,
              margin: const EdgeInsets.only(left: 16, top: 28),
              child: Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                        color: AppColor.appThemeColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ]),
                    child: Image.asset('${StringConstatnts.assets}web.png'),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    siteName,
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.blackColor),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16, right: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                        color: AppColor.appThemeColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ]),
                    child: Image.asset('${StringConstatnts.assets}web.png'),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Text(
                      description,
                      maxLines: 6,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.blackColor),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 60),
              child: InkWell(
                onTap: onTapOnLink,
                child: Text(connectLink,
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF0063D7))),
              ),
            ),
            Container(
              height: 32,
              margin: const EdgeInsets.only(left: 16, top: 28),
              child: InkWell(
                onTap: tapONLandMobile,
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          color: AppColor.appThemeColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          '${StringConstatnts.assets}mobile.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      mobileNumber,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 32,
              margin: const EdgeInsets.only(left: 16, top: 28),
              child: InkWell(
                onTap: tapOnEmail,
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          color: AppColor.appThemeColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2))
                          ]),
                      child: Image.asset(
                        '${StringConstatnts.assets}mail.png',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      connectLinkText,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 32,
              margin: const EdgeInsets.only(left: 16, top: 28),
              child: InkWell(
                onTap: tapONMobile,
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          color: AppColor.appThemeColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          '${StringConstatnts.assets}mobile.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      secondNumber,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
