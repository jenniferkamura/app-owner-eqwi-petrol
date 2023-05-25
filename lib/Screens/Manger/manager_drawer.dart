// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/about_us_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/contact_us_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/login_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagerNavDrawer extends StatefulWidget {
  @override
  State<ManagerNavDrawer> createState() => _ManagerNavDrawerState();
}

class _ManagerNavDrawerState extends State<ManagerNavDrawer> {
  NotificationController notificationController =
      Get.put(NotificationController());
  String? name;
  String? mobile;
  String? email;
  String? user_type;
  String? user_token = Constants.prefs?.getString('user_token');
  String? profile_picture;
  bool isloader = false;

  List<String> menuList = [
    'Profile',
    'Home',
    'Order',
    'About us',
    'Contact us',
    'Logout',
  ];

  List<String> menuIcon = [
    'profile_icon',
    'home_menu',
    'ordrr_menu',
    'about_us',
    'contact_us',
    'logout',
  ];

  logOut() async {
    await notificationController.logOutFun(user_token.toString());
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
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    setState(() {
      isloader = true;
    });
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}profile"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // print("print is.....${result}");
      setState(() {
        isloader = false;
      });
      if (result['status'] == 'success') {
        name = result['data']['name'];
        mobile = result['data']['mobile'];
        email = result['data']['email'];
        user_type = result['data']['user_type'];
        profile_picture = result['data']['profile_pic_url'];
      }
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
          child: isloader == false
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        imageUrl: profile_picture.toString(),
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        )),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColor.whiteColor),
                        ),
                        Text(
                          user_type.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.whiteColor),
                        ),
                        Text(
                          email.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColor.whiteColor),
                        ),
                      ],
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3),
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
                    builder: (context) => ProfileScreen(),
                  ))
                  .then((value) => Navigator.of(context).pop());
            } else if (menuList[index] == 'Home') {
              Navigator.of(context)
                  .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ManagerTabbarScreen(
                                index: 0,
                              )),
                      (Route<dynamic> route) => false)
                  .then((value) => Navigator.of(context).pop());
            } else if (menuList[index] == 'Order') {
              Navigator.of(context)
                  .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ManagerTabbarScreen(
                                index: 2,
                              )),
                      (Route<dynamic> route) => false)
                  .then((value) => Navigator.of(context).pop());
            } else if (menuList[index] == 'About us') {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => AboutUsScreen(),
                  ))
                  .then((value) => Navigator.of(context).pop());
            } else if (menuList[index] == 'Contact us') {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => ContactUsScreen(),
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
