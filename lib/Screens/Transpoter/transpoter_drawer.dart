// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/login_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/notification_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/today_route_plan_sceen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_contact_us_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_profile/screens/transporter_profile_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_feedback_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_help_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpotet_order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranspoterNavDrawer extends StatefulWidget {
  final String name;
  final String mailId;
  final String type;
  final String image;

  const TranspoterNavDrawer(
      {super.key,
      required this.name,
      required this.mailId,
      required this.type,
      required this.image});

  @override
  State<TranspoterNavDrawer> createState() => _TranspoterNavDrawerState();
}

class _TranspoterNavDrawerState extends State<TranspoterNavDrawer> {
  NotificationController notificationController =
      Get.put(NotificationController());

  String? userToken = Constants.prefs?.getString('user_token');

  List<String> menuList = [
    'Profile',
    'Home',
    'Order',
    'Feedback',
    'Today Route Plan',
    'Help',
    'Contact us',
    'Logout',
  ];

  List<String> menuIcon = [
    'profile_icon',
    'home_menu',
    'ordrr_menu',
    'feedback',
    'ordrr_menu',
    'help',
    'contact_us',
    'logout',
  ];

  logOut() async {
    await notificationController.logOutFun(userToken.toString());
    if (notificationController.logOutFinalData.data == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //  prefs.remove('DeviceId');
      prefs.remove('user_id');
      prefs.remove('user_type');
      prefs.remove('user_token');
      Get.offAll(() => LoginScreen());
    } else {
      print('kkkkk');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      Container(
        height: 94,
        color: AppColor.appThemeColor,
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 23),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.29),
                      offset: Offset(
                        0,
                        4,
                      ),
                    )
                  ],
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColor.whiteColor),
                  ),
                  Text(
                    widget.type,
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.whiteColor),
                  ),
                  Text(
                    widget.mailId,
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.whiteColor),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: menuList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: (() {
            if (menuList[index] == 'Profile') {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => TransporterProfileScreen(),
                  ))
                  .then((value) => Navigator.of(context).pop());
            } else if (menuList[index] == 'Home') {
              Navigator.of(context).pop();
            } else if (menuList[index] == 'Order') {
              Navigator.of(context).pop();
              Get.to(() => TransporterOrderScreen());
              /* Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => TransporterOrderScreen()))
                  .then((value) => Navigator.of(context).pop());*/
            } else if (menuList[index] == 'Feedback') {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => TranspoterFeedBackScreen(),
                  ))
                  .then((value) => Navigator.of(context).pop());
            }else if (menuList[index] == 'Today Route Plan') {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => TodayRoutePlanScreen(),
              ))
                  .then((value) => Navigator.of(context).pop());
            } else if (menuList[index] == 'Help') {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => TransporterHelpScreen(),
                  ))
                  .then((value) => Navigator.of(context).pop());
            } else if (menuList[index] == 'Contact us') {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => TransporterContactUsScreen(),
                  ))
                  .then((value) => Navigator.of(context).pop());
            } else if (menuList[index] == 'Logout') {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Do you want to logout?',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                              SizedBox(
                                height: 10,
                                width: 0,
                              ),
                              Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: notificationController
                                                .logOutLoad.value
                                            ? () {}
                                            : () {
                                                Get.back();
                                              },
                                        child: Text('NO'),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            textStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600))),
                                    SizedBox(
                                      width: 20,
                                      height: 0,
                                    ),
                                    ElevatedButton(
                                        onPressed: notificationController
                                                .logOutLoad.value
                                            ? () {}
                                            : () {
                                                logOut();
                                              },
                                        child: notificationController
                                                .logOutLoad.value
                                            ? SizedBox(
                                                height: 10,
                                                width: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ))
                                            : Text('YES'),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColor.appThemeColor,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            textStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
              /*Navigator.of(context).pushAndRemoveUntil(
         MaterialPageRoute(builder: (context) => LoginScreen()),
             (Route<dynamic> route) => false);*/
            }
          }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                      child: Image.asset(
                        '${StringConstatnts.assets}${menuIcon[index]}.png',
                        height: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        menuList[index],
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.blackColor),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 13),
                height: 0.5,
                color: Color(0xFFC8C8C8),
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
        ),
      ),
    ]));
  }
}
