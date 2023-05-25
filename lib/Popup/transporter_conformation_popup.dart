// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

class TransporterConfirmationPopup extends StatelessWidget {
  const TransporterConfirmationPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 140,
          margin: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF89A619),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      'Confirmation',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.whiteColor),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {                       
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        '${StringConstatnts.assets}wrong.png',
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 11,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Your Request Is Sent To Admin',
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D6168)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Successfully.Admin Will Contact Soon',
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5D6168)),
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
