// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Attender/attender_tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/walk_through_screen.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_deliveries_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_pick_up_details_screen.dart';
import 'package:owner_eqwi_petrol/network_connectivity/network_controller.dart';
import 'package:owner_eqwi_petrol/utility/auth_service.dart';
import 'package:owner_eqwi_petrol/utility/notification.dart';
import 'Common/constants.dart';
import 'Screens/Manger/manger_tabbar_screen.dart';
import 'Screens/Transpoter/transpoter_home_screen.dart';
import 'network_connectivity/network_binding.dart';
import 'Common/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebadeMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase
      .initializeApp(); // options: DefaultFirebaseConfig.platformOptions
  print('Handling a background message ${message.messageId}');
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await FirebaseMessaging.instance.requestPermission();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColor.appThemeColor,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(
    GetMaterialApp(
      title: 'Eqwipetrol',
      initialBinding: NetworkBinding(),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NetworkController _networkController = Get.find<NetworkController>();
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());

  Future<void> intiPlatformState() async {
    print('firebase');
    var token = await FirebaseMessaging.instance.getToken();
    print("firebase token .......$token");
    Constants.prefs!.setString('deviceId', token.toString());
  }

  String? userToken = Constants.prefs?.getString('user_token');

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), (() {
      autoLogin();
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) {
      //     return WalkThroughScreen();
      //   },
      // ));
    }));
    super.initState();
    // print(Constants.prefs?.getString('user_id'));
    // print(Constants.prefs?.getString('user_type'));
    Constants.prefs?.setString('isFirstPopType', 'true');
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
    } else if (Constants.prefs?.getString('user_id') != null &&
        Constants.prefs?.getString('user_type') == 'Attendant') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AttenderTabbarScreen()));
    } else if (Constants.prefs?.getString('user_id') == null ||
        Constants.prefs?.getString('user_id') == '') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return WalkThroughScreen();
        },
      ));
    }
  }

  Future<void> retriveNotificationBackgroundState() async {
    final lastNotification =
        await FirebaseMessaging.instance.getInitialMessage();

    if (lastNotification != null) {
      notificationNavigator(message: lastNotification);
    }
  }

  Future<void> notificationNavigator({required RemoteMessage message}) async {
    final String orderId = message.data['order_id'] ?? "";
    if (orderId.isNotEmpty &&
        Constants.prefs?.getString('user_type') == 'Transporter' &&
        message.data['order_type'] == 'false') {
      print('HELLO IN******************************************************');
      //O00213
      print(message.data);
      print(orderId);

      print('HELLO IN');
      Get.to(() => TransportViewOrderDetailScreen(orderId: orderId),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 400));
      // transportHomeController.transportPickUpOrdersFun(
      //     userToken.toString(), 'Pending',
      //     isLoad: true);
    } else if (orderId.isNotEmpty &&
        Constants.prefs?.getString('user_type') == 'Transporter' &&
        message.data['order_type'] == 'true') {
      Get.to(() => TransporterDeliveriesScreen(orderId: orderId),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 400));
/*      transportHomeController.transportCurrentOrdersFun(
          userToken.toString(), 'Accept',
          isLoad: true);*/
    }
  }

  @override
  void didChangeDependencies() async {
    final notificationService =
        NotificationService(FlutterLocalNotificationsPlugin());
    await notificationService.initialize(context);
    print("*****************************");
    await intiPlatformState();
    print("*****************************");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        print('***@@@@@@@@@@@@@@@@@@@@@@@@@@**');
        print(message.data);
        print('***@@@@@@@@@@@@@@@@@@@@@**');
        //Notification Navigator
        //
        // print('Message also contained a notification: ${message.notification}');

        await notificationService.showNotification(
          androidNotificationDetails: const AndroidNotificationDetails(
            "firebase",
            "firebase",
            importance: Importance.high,
            playSound: true,
          ),
          showNotificationId: 128,
          title: message.notification?.title,
          body: message.notification?.body ?? "You received a notification",
          payload: message.data['body'].toString(),
        );
        await notificationNavigator(message: message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Fluttertoast.showToast(
        msg: 'Just received a notification when app is opened',
      );

      // showNotification(message, context);
      if (message.notification != null) {
        final String routeFromNotification =
            message.data["order_id"].toString();
        print('***** 4589');
        print(message.data);
        notificationNavigator(message: message);
        print('*****');
      }
    });
    await retriveNotificationBackgroundState();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    '${StringConstatnts.assets}Splash_eqwi_petrol.jpg',
                  ),
                  fit: BoxFit.fitWidth),
            ),
          ), //logo_eqwwi.png
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 77, right: 77, top: 168),
                child: Image.asset('${StringConstatnts.assets}logo_eqwwi.png'),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 11, right: 11, bottom: 20),
                child: Image.asset('${StringConstatnts.assets}flash_img.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
