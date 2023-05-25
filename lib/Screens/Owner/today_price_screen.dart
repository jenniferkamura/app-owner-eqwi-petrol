// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/add_to_cart_popup.dart';
import 'package:http/http.dart' as http;
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:owner_eqwi_petrol/modals/latestpriceslist.dart';
import 'dart:convert' as convert;

import '../../Common/constants.dart';
import '../Attender/attender_tabbar_screen.dart';
import '../Manger/manger_tabbar_screen.dart';

class TodayPriceScreen extends StatefulWidget {
  final Function notificationsCountFun_value;
  const TodayPriceScreen(
      {super.key, required this.notificationsCountFun_value});

  @override
  State<TodayPriceScreen> createState() => _TodayPriceScreenState();
}

class _TodayPriceScreenState extends State<TodayPriceScreen> {
  List<Homescreenpriceslist> prices = [];
  bool isLoader = false;
  String? user_type = Constants.prefs?.getString('user_type');
  List<String> fuelName = [
    'Petrol',
    'Diesel',
    'Gas',
    'Kerosine',
    'Lubricants',
    'Lubricants',
    'Lubricants'
  ];
  List<String> fuelNameshort = [
    'Pms',
    'Ago',
    'Lpg Eqwipetrol',
    'IK',
    'Motor Cycle',
    'Motor Vehicle',
    'Saws'
  ];
  List<String> fuelImage = [
    'petorl_big.png',
    'diesel_big.png',
    'gas_big.png',
    'kerosine_big.png',
    'lubricants_big.png',
    'lubricants_bignew.png',
    'fire_big.png'
  ];
  @override
  void initState() {
    getTodayprices();
    super.initState();
  }

  Future<void> getTodayprices() async {
    setState(() {
      isLoader = true;
    });
    http.Response response =
        await http.get(Uri.parse("${Constants.baseurl}category_prices"));
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        print(result);
        result['data'].forEach((element) {
          setState(() {
            prices.add(Homescreenpriceslist.fromJson(element));
            //   print(result);
          });
          print(prices);
        });
      } else {
        // ignore: use_build_context_synchronously
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

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
        body: ListView(
          children: [
            Container(
              height: 76,
              color: AppColor.appThemeColor,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (user_type == 'Owner') {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TabbarScreen()));
                          //Get.back();
                        } else if (user_type == 'Manager') {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ManagerTabbarScreen()));
                          //Get.back();
                        } else if (user_type == 'Attendant') {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AttenderTabbarScreen()));
                          //Get.back();
                        }
                      },
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(24 / 2),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.blackColor.withOpacity(0.25),
                                offset: Offset(0, 4),
                                blurRadius: 4),
                          ],
                        ), //#
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child:
                              Image.asset('${StringConstatnts.assets}back.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Make An Order",
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColor.whiteColor),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 9),
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: prices.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xFFD3D3D3))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 66,
                        width: 144,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFFE8E8E8),
                        ),
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        child: Image.network(
                          prices[index].imagePath.toString(),
                          height: 41,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: prices[index].name.toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF161614)),
                                children: <InlineSpan>[
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: SizedBox(width: 7)),
                                  TextSpan(
                                    text: prices[index].type.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF787878)),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              '${prices[index].currency} ${prices[index].price} / ${prices[index].measurement}',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddCartPopup(
                                    categoryId:
                                        prices[index].categoryId.toString(),
                                    cartCount: () =>
                                        widget.notificationsCountFun_value());
                              });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 144,
                          height: 30,
                          decoration: BoxDecoration(
                              color: index == 0
                                  ? Color(0xFFBCD84E)
                                  : Color(0xFFBCD84E),
                              borderRadius: BorderRadius.circular(30 / 2),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 4,
                                    color: Color(0xFF000000).withOpacity(0.25))
                              ]),
                          child: Text(
                            'buy now'.toUpperCase(),
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: index == 0
                                    ? AppColor.blackColor
                                    : AppColor.blackColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
