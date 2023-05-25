import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';

import '../../Common/constants.dart';
import '../Attender/attender_tabbar_screen.dart';
import '../Manger/manger_tabbar_screen.dart';

class OrderGenerateScreen extends StatefulWidget {
  const OrderGenerateScreen({super.key});

  @override
  State<OrderGenerateScreen> createState() => _OrderGenerateScreenState();
}

String? user_type = Constants.prefs?.getString('user_type');

class _OrderGenerateScreenState extends State<OrderGenerateScreen> {
  Future<bool> onWillPop() {
    if (user_type == 'Owner') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TabbarScreen()));
      //Get.back();
    } else if (user_type == 'Manager') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
      //Get.back();
    } else if (user_type == 'Attendant') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AttenderTabbarScreen()));
      //Get.back();
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context,
            title: 'Order Generate', onTaped: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => TabbarScreen())));
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Center(
                  child: Image.asset(
                    '${StringConstatnts.assets}sucees.png',
                    height: 107,
                  ),
                ),
                // Text(
                //   'Money added Successfully.',
                //   style: GoogleFonts.roboto(
                //       fontSize: 24,
                //       fontWeight: FontWeight.w500,
                //       color: Color(0xFF2DBE7C)),
                // ),

                Text(
                  'Bill Generated Successfully.',
                  style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2DBE7C)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
