import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import '../Common/constants.dart';
import '../Screens/Owner/tabbar_screen.dart';
import '../Screens/Owner/walk_through_screen.dart';
import '../Screens/Transpoter/transpoter_home_screen.dart';
import 'network_controller.dart';

class NoInternetConnection extends StatefulWidget {
  @override
  _NoInternetConnectionState createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  final NetworkController _networkController = Get.find<NetworkController>();

  // CategoryController _netWorkController = Get.find<CategoryController>();

  // final Connectivity _connectivity = Connectivity();

  // StreamSubscription _streamSubscription;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  callbackmethod() {
    if (_networkController.connectionStatus.value != 0) {
      // Get.to(() => VendorLoginPage());
      //   Navigator.pop(context);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      autoLogin();
    }
  }

  autoLogin() {
    if (Constants.prefs?.getString('user_id') != null &&
        Constants.prefs?.getString('user_type') == 'Owner') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    } else if (Constants.prefs?.getString('user_id') != null &&
        Constants.prefs?.getString('user_type') == 'Manager') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
    } else if (Constants.prefs?.getString('user_id') != null &&
        Constants.prefs?.getString('user_type') == 'Transporter') {
      Get.to(() => TransporterHomeScreen(),
          duration: Duration(milliseconds: 400),
          transition: Transition.rightToLeft);
      /*  Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => TranspoterHomeScreen()));*/
    } else if (Constants.prefs?.getString('user_id') == null ||
        Constants.prefs?.getString('user_id') == '') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return WalkThroughScreen();
        },
      ));
    }
  }

  overlayCheckFun() async {
    // dynamic res = await ;
    // print("overlay res......$res");

    // print("overlay condition is.....${await OverlayState()}");
    // OverlayState();
    // OverlayState;
  }

  var currentBackPressTime;
  var orderid;
  @override
  void initState() {
    super.initState();

    overlayCheckFun();

    // if (orderid != null) {
    // if(OverlaySupportEntry.of(context).isBlank == true){

    // OverlaySupportEntry.of(context)!.dismiss();
    // }

    // }

    callbackmethod();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(callbackmethod());
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
    //     overlays: [SystemUiOverlay.top]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // callbackmethod();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(callbackmethod());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    width: 160,
                    child: Image(
                      image: AssetImage("assets/images/nointernet.png"),
                    )),
              ),
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text("Oops!",
                      style: TextStyle(color: Colors.black, fontSize: 30))),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "NO ",
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    ),
                    TextSpan(
                      text: "INTERNET",
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.green;
                      return Colors.red; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  )),
                ),
                onPressed: () => {
                  callbackmethod(),
                }, //set both onPressed and onLongPressed to null to see the disabled properties
                child: Text(
                  'Try again',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Tap back again to leave');

      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
}
