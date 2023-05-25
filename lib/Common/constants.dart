import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;

class Constants {
  static SharedPreferences? prefs;
  static var baseurl = 'https://colormoon.in/eqwi_petrol/api/V1/';
  static var cartCount = '0';
  String? user_token = Constants.prefs?.getString('user_token');
  final Rx<String> _cartCount = "0".obs;

//  String? notificationCount;
  // static var baseurl = 'https://colormoon.in/gp/insta_clean/api/';
  static snackBar(context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "Close",
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static capitalize(String s) {
    return (s != null && s.length > 1)
        ? s[0].toUpperCase() + s.substring(1)
        : s != null
            ? s.toUpperCase()
            : null;
  }

  static gethomecartData() async {
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    print('gethomecartData');
    //  print(bodyData);
    http.Response response =
        await http.post(Uri.parse(Constants.baseurl + "home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      print('home cart update');
      //  print("print is.....${result}");

      if (result['status'] == 'success') {
        await Future.delayed(Duration(seconds: 2));
        cartCount = result['data']['cart_count'].toString();
        Constants.prefs?.setString('cartCount', cartCount);
        //  print(Constants.prefs!.getString('cartCount').toString());
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => TabbarScreen()));
        // notificationCount = result['data']['unread_notifications'];
      }
      print('cartCount : $cartCount');
    }
  }
}
