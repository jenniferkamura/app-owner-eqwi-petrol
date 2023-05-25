// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Popup/confirmation_popup.dart';
import 'package:owner_eqwi_petrol/Popup/transporter_conformation_popup.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/drawer_controller.dart';

class TransporterHelpRaiseTicketScreen extends StatelessWidget {
  TransporterHelpRaiseTicketScreen({Key? key}) : super(key: key);

  DrawerDataController drawerDataController = Get.put(DrawerDataController());

  String? userToken = Constants.prefs?.getString('user_token');

  raiseTicketFun(context) async {

    if(drawerDataController.helpController.text.isEmpty){
        Fluttertoast.showToast(
          msg: 'Please Enter Valid data',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }else{
  await drawerDataController.raiseTicketFun(
        userToken.toString(), drawerDataController.helpController.text);
    if(drawerDataController.raiseTicketFinalData.status == 'success'){
      showDialog(
        context: context,
        builder: (context) {
          return TransporterConfirmationPopup();
        });
      drawerDataController.helpController.clear();
    }else{
      Fluttertoast.showToast(
          msg: drawerDataController.raiseTicketFinalData.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    }
  

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
        Get.back();
      }, title: 'Help - Raise Ticket'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /* Container(
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
                        'Help - Raise Ticket',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor),
                      )
                    ],
                  ),
                ),
              ),*/
            /*Container(
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add query/ details',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF555561),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFC6C6C6),
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      height: 118,
                      child: TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20, top: 10),
                            hintText:
                                'Enter Something Here..',
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF808080))),
                      ),
                    )
                  ],
                ),
              ),*/
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add query/ details',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF555561),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 0,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFC6C6C6),
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  height: 118,
                  child: TextField(
                    maxLines: 5,
                    controller: drawerDataController.helpController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, top: 10),
                        hintText: 'Enter Something Here..',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF808080))),
                  ),
                ),
              ],
            ),
            Obx(() => CommonButton(
                buttonTitle: drawerDataController.raiseTicketLoading.value?SizedBox(
                  height: 15,width: 15,
                    child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)):Text('RAISE TICKET'),
                onTapped: () => raiseTicketFun(context))),
          ],
        ),
      ),
    );
  }
}
