// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manager_cart_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manager_drawer.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manager_notification_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manager_order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_home_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/menu_screen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;

int selectedIndex = 0;

class ManagerTabbarScreen extends StatefulWidget {
  int? index;
  ManagerTabbarScreen({Key? key, this.index}) : super(key: key);

  @override
  _ManagerTabbarScreenState createState() => _ManagerTabbarScreenState();
}

class _ManagerTabbarScreenState extends State<ManagerTabbarScreen>
    with SingleTickerProviderStateMixin {
  String? cartCount = '0';
  String? notiCount = '0';
  // Properties & Variables needed
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  bool showTabs = false;
  TabController? tabController;

  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: prefer_final_fields
  // List<Widget> _widgetOptions = <Widget>[
  //   HomeScreen(),
  //   CartScreen(),
  //   OrderScreen(),
  //   NotificationScreen(),
  //   MenuScreen()
  // ];
  int lastSelectedTab = 0;
  void _onItemTapped(int index) {
    // if (valu)
    setState(() {
      selectedIndex = index;
      lastSelectedTab = index;
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    setState(() {
      selectedIndex = widget.index ?? 0;
      tabController?.animateTo(widget.index ?? 0);
    });
    super.initState();
  }

  void notificationsCountFun() async {
    print("datadtatatataatatta");
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    print('gethomecarfffftData');
    http.Response response =
        await http.post(Uri.parse(Constants.baseurl + "home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        print(result['data']);
        setState(() {
          cartCount = result['data']['cart_count'].toString();
          notiCount = result['data']['unread_notifications'].toString();
        });

        print('cartcountffffff :$cartCount');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _key,
        endDrawer: ManagerNavDrawer(),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            ManagerHomeScreen(
                notificationsCountFun_value: () => notificationsCountFun()),
            ManagerCartScreen(
                notificationsCountFun_value: () => notificationsCountFun()),
            ManagerOrderScreen(isHomeScreen: false),
            ManagerNotificationScreen(),
            MenuScreen()
          ],
        ),
        bottomNavigationBar: Container(
          height: 60,
          child: TabBar(
            padding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            onTap: (value) {
              if (value == 4) {
                _key.currentState!.openEndDrawer();
                tabController?.animateTo(lastSelectedTab);
                setState(() {});
              } else {
                tabController?.animateTo(value);
                _onItemTapped(value);
              }
            },
            physics: NeverScrollableScrollPhysics(),
            indicatorColor: Colors.transparent,
            tabs: [
              Container(
                alignment: Alignment.center,
                color: selectedIndex == 0 ? Colors.black : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/home_menu.png",
                      height: 30,
                      color: selectedIndex == 0 ? Colors.white : Colors.black,
                    ),
                    Text(
                      'Home'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          color:
                              selectedIndex == 0 ? Colors.white : Colors.black),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: selectedIndex == 1 ? Colors.black : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    badges.Badge(
                      badgeContent: Text(
                        cartCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      child: Image.asset("assets/images/cart.png",
                          height: 30,
                          color:
                              selectedIndex == 1 ? Colors.white : Colors.black),
                    ),
                    Text(
                      'Cart'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          color:
                              selectedIndex == 1 ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: selectedIndex == 2 ? Colors.black : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/order.png",
                        height: 30,
                        color:
                            selectedIndex == 2 ? Colors.white : Colors.black),
                    Text(
                      'Order'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          color:
                              selectedIndex == 2 ? Colors.white : Colors.black),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: selectedIndex == 3 ? Colors.black : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    badges.Badge(
                      badgeContent: Text(
                        notiCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      child: Image.asset("assets/images/notifications.png",
                          height: 30,
                          color:
                              selectedIndex == 3 ? Colors.white : Colors.black),
                    ),
                    Text(
                      'Notification'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          color:
                              selectedIndex == 3 ? Colors.white : Colors.black),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: selectedIndex == 4 ? Colors.white : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/menu.png",
                        height: 30,
                        color:
                            selectedIndex == 4 ? Colors.black : Colors.black),
                    Text(
                      'Menu'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          color:
                              selectedIndex == 4 ? Colors.black : Colors.black),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
