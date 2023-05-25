import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/verify_mobile_otp_screen.dart';

import '../Common/constants.dart';
import '../Screens/Owner/add_station_screen.dart';
import '../Screens/Owner/tabbar_screen.dart';
import '../Screens/Owner/verify_otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

String? deviceId = Constants.prefs?.getString('deviceId');

class AuthServices {
  //Google sign in
  signInWithGoogle() async {
    print('Hello Google');
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    dogmailLogin(gUser.displayName, gUser.email, gUser.id, gUser.photoUrl);

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

Future<void> dogmailLogin(name, email, authid, photoUrl) async {
  Map<String, dynamic> bodyData = {
    'name': name.toString(),
    'email': email.toString(),
    'auth_id': authid.toString(),
    'auth_provider': 'Google',
    'photourl': photoUrl.toString(),
    'device_id': deviceId.toString(),
    'platform_type': "android"
  };
  http.Response response = await http
      .post(Uri.parse("${Constants.baseurl}social_login"), body: bodyData);
  //   print(bodyData);
  if (response.statusCode == 200) {
    var result = convert.jsonDecode(response.body);
    // dart array

    print(result);
    if (result['status'] == 'success') {
      // reidrect to login Page
      //  print(result['data']['user_id']);
      Constants.prefs?.setString('user_id', result['data']['user_id']);
      Constants.prefs?.setString('user_type', result['data']['user_type']);
      Constants.prefs?.setString('user_token', result['data']['user_token']);

      // print(result['data']['user_token']);

      if (result['data']['user_type'] == 'Owner') {
        if (result['data']['station_count'] == 0) {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "You have no petrol Station.Please add",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // ignore: use_build_context_synchronously
          Get.offAll(() => const AddStationScreen(),
              duration: const Duration(milliseconds: 400),
              transition: Transition.leftToRight);
        } else if (result['data']['station_count'] > 0) {
          // ignore: use_build_context_synchronously
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => TabbarScreen()));
          Get.offAll(() => TabbarScreen(),
              duration: const Duration(milliseconds: 400),
              transition: Transition.leftToRight);
        }
      }
    } else if (result['status'] == 'error') {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "${result['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      if (result['data']['mobile_verified'] == 0) {
        //  showmobilenumberwidget = true;
        // ignore: use_build_context_synchronously
        Get.offAll(
            () => VerifyMobileOtp(
                  token: result['data']['token'],
                ),
            duration: const Duration(milliseconds: 400),
            transition: Transition.leftToRight);

        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => VerifyMobileOtp()));
      }
    }
  }
}

// class GoogleSignInProvider extends ChangeNotifier {
//   final googleSignIn = GoogleSignIn();
//   GoogleSignInAccount? _user;
//
//   GoogleSignInAccount get user => _user!;
//
//   Future googleLogin() async {
//     final googleUser = await googleSignIn.signIn();
//     if(googleUser == null) return;
//     _user = googleUser;
//
//     final googleAuth = await googleUser.authentication;
//
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     await FirebaseAuth.instance.signInWithCredential(credential);
//
//     notifyListeners();
//   }
//
// }