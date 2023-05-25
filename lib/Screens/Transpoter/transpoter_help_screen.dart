// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/drawer_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_contact_us_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_help_raise_ticker_screen.dart';

class TransporterHelpScreen extends StatelessWidget {
  TransporterHelpScreen({Key? key}) : super(key: key);

  final String? userToken = Constants.prefs?.getString('user_token');
  DrawerDataController drawerDataController =  Get.put(DrawerDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leadingWidth: 50,
        titleSpacing: 1,
        backgroundColor: AppColor.appThemeColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Help',
          style:
              CustomTextWhiteStyle.textStyleWhite(context, 18, FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.white,
            )),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: CommonButton(buttonTitle: Text('RAISE TICKET',style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.whiteColor)), onTapped: () async {
                  await  Get.to(()=>TransporterHelpRaiseTicketScreen(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 400));
                },)),
                SizedBox(width: 10,height: 0,),
                Expanded(child: CommonButton(buttonTitle: Text('CONTACT ADMIN',style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.whiteColor)), onTapped: () async{
                 await Get.to(()=>TransporterContactUsScreen(),transition: Transition.rightToLeft,duration: Duration(milliseconds: 400));
                },)),
              ],
            ),
          ),
        ),
      ),
      body: GetBuilder<DrawerDataController>(
        initState: (_) => DrawerDataController.to.initStateHelpQData(userToken.toString(),''),
        builder: (value) => ListView(
          children: [
         /*   Container(
              margin: EdgeInsets.only(top: 0, left: 16, right: 16),
              child: SizedBox(
                height: 48,
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE5E5E5), width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Search Issues',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                            '${StringConstatnts.assets}search_home.png'),
                      ),
                      hintStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFAAAAAA))),
                ),
              ),
            ),*/
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 1,
              color: Color(0xFFEAEBED),
            ),
            Obx(()=>
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: value.helpAndSupportQFinalData.data.length,
                itemBuilder: (context, index) =>  ExpansionTile(
                  title: Text(value.helpAndSupportQFinalData.data[index].question.toString(),style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor)),
                  children: [
                    Container(
                      padding:EdgeInsets.all(20),
                      width: double.infinity,
                      child:  Text(value.helpAndSupportQFinalData.data[index].answer.toString()),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
