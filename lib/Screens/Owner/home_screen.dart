// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/add_to_cart_popup.dart';
import 'package:owner_eqwi_petrol/Popup/select_location_popup.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/currentorderPayment.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/login_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/manager_verify_order.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/receive_new_order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/searchorderlist.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/today_price_screen.dart';
import 'package:http/http.dart' as http;
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/modals/currentordermodal.dart';
import 'dart:convert' as convert;

import 'package:owner_eqwi_petrol/modals/latestpriceslist.dart';
import 'package:owner_eqwi_petrol/modals/nearbystationsmodal.dart';
import 'package:owner_eqwi_petrol/modals/orderlistmodal.dart';

import '../../Common/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location_geocoder/location_geocoder.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  final Function notificationsCountFun_value;
  const HomeScreen({super.key, required this.notificationsCountFun_value});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // OwnerHomeScreenController ownerHomeScreenController =
  //     Get.put(OwnerHomeScreenController());

  static const String username = 'colourmoon';
  static const String password = 'cmoon@123';
  static String basicAuth =
      'Basic ${base64.encode(utf8.encode('$username:$password'))}';

  List<Homescreenpriceslist> prices = [];
  List<Currentordersmodal> currentorderslist = [];
  List<OrdersListModal> completeorderslist = [];
  List<dynamic> nearstations = [];
  var currentBackPressTime;
  bool isLoader = false;
  String? selectCatId;
  int stationsCount = 0;
  List<dynamic> stations = [];
  List<dynamic> stationslist = [];
  //final Set<Marker> markers = new Set();
  // List<Marker> _marker = [];

  // Future<void> getfffTodayprices() async {
  //   //print('real estare');
  //   setState(() {
  //     isLoader = true;
  //   });
  //   http.Response response = await http.get(
  //       Uri.parse("https://ready2host.in/cm-realestate/api/home-screen-banner"),
  //       headers: <String, String>{'authorization': basicAuth});

  //   //print('real estaresdfdf');
  //   if (response.statusCode == 200) {
  //     //   body = convert.jsonDecode(response.body);
  //     var result = convert.jsonDecode(response.body);
  //     //print('dadsfsdf');
  //     //print(result);
  //     // dart array
  //     // loaderIndicator = convert.jsonDecode(response.body);
  //     setState(() {
  //       isLoader = false;
  //     });
  //     if (result['status'] == 'success') {
  //       //print(result);
  //     } else {
  //       Constants.snackBar(context, '${result['message']}');
  //     }
  //   }
  // }
  var selectedData;
  late double data_latitude;
  late double data_longitude;
  String googleApikey = "AIzaSyANKvvGW7sjJjBs_VR2iaV87RPXYi0auLg";
  final LocatitonGeocoder geocoder =
      LocatitonGeocoder('AIzaSyANKvvGW7sjJjBs_VR2iaV87RPXYi0auLg');
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(87.99999, 78.99999), zoom: 14.5);
  GoogleMapController? mapController;
  // late LatLng latlong = LatLng(0.0, 0.0);
  late CameraPosition cameraPosition;
  //late GoogleMapController controller;
  bool data_loaded = false;
  var place_location;
  //Set<Marker> _markers = {};
  bool _mapLoading = false;
  bool selectFromPlace = false;
  //String location = "";
  late BitmapDescriptor icon;
  var startLocation;
  late LatLng showLocation;
  bool isLoading = true;
  List<dynamic> selected_data = [];
  ScrollController scrollController = ScrollController();
  String? user_token = Constants.prefs?.getString('user_token');
  List orders = [];
  int ordersCount = 0;
  int nearstationsCount = 0;
  var globalMarkers;
  final List<Marker> _markers = <Marker>[];
  late LatLng latlong = LatLng(0.0, 0.0);
  List<dynamic> searchResultService = [];
  bool searching = false;
  final List<LatLng> _latLen = <LatLng>[
    LatLng(17.7974883746824, 83.28544411808252),
    // LatLng(17.745819473183968, 83.28099399805069),
  ];

  var searchlist;
  // created list of coordinates of various locations
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());

  Uint8List? marketimages;
  List<String> images = [
    'assets/images/petrol_stations.png',
    'assets/images/petrol_stations.png',
    'assets/images/petrol_stations.png',
    'assets/images/petrol_stations.png',
    'assets/images/petrol_stations.png',
    'assets/images/petrol_stations.png',
  ];
  List stationnames = [];
  String? cartCount = '0';
  String? notificationCount = '0';
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    //print('user_token >>$user_token');
    getstationslist();
    getTodayprices();
    getcurrentorderslist();
    getorderslist();
    getnearBystations();
    gethomecartData();
    if (Constants.prefs?.getString('isFirstPopType') == 'true') {
      adds();
    }
    //print('ads');
    //print(Constants.prefs?.getString('isFirstPopType'));
    super.initState();
    transportHomeController.transportHomeFun(user_token!.toString());
    // getfffTodayprices();

    //print("Here i am");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.notificationsCountFun_value();
    });
  }

  adds() async {
    await transportHomeController.getAddsFun(user_token.toString());
    if (transportHomeController.addsFinalData.data.isNotEmpty) {
      Constants.prefs?.setString('isFirstPopType', 'false');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: 10, height: 0),
                      Text(
                        transportHomeController.addsFinalData.data[0].title
                            .toString(),
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.blackColor),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 19,
                          )),
                    ],
                  ),
                  Text(
                    transportHomeController.addsFinalData.data[0].description
                        .toString(),
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: Image.network(
                          transportHomeController
                              .addsFinalData.data[0].imagePath
                              .toString(),
                          scale: 1.0,
                          fit: BoxFit.fill,
                        )),
                  ),
                ],
              ),
            );
          });
    }
  }

  void notificationsCountFun() async {
    //print("datadtatatataatatta");
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    //print('gethomecarfffftData');
    http.Response response =
        await http.post(Uri.parse("${Constants.baseurl}home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        //print(result['data']);
        setState(() {
          cartCount = result['data']['cart_count'].toString();
        });

        //print('cartcountffffff :$cartCount');
      }
    }
  }

  Future<void> gethomecartData() async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    //print(bodyData);
    http.Response response =
        await http.post(Uri.parse("${Constants.baseurl}home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      //print("//print is.....${result}");

      if (result['status'] == 'success') {
        cartCount = result['data']['cart_count'].toString();
        notificationCount = result['data']['unread_notifications'].toString();
      } else if (result['status'] == 'error') {
        if (result['message'] == 'User token expired!') {
          // ignore: use_build_context_synchronously
          Constants.snackBar(context, 'User token expired!. Please Login ');
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
        }
      }
      // //print('cartCount : $cartCount');
    }
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapLoading = true;
    setState(() {
      startLocation = LatLng(position.latitude, position.longitude);

      // //print(startLocation);
      //   GetAddressFromLatLong(startLocation);
      // getIcons();
    });
    return await Geolocator.getCurrentPosition();
  }

  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markIcons = await getImages(images[i], 100);
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        icon: BitmapDescriptor.fromBytes(markIcons),
        position: _latLen[i],
        infoWindow: InfoWindow(
          title: stationnames[i],
        ),
      ));
      setState(() {});
    }
  }

  late BitmapDescriptor _markerDirection;

  Future<void> GetAddressFromLatLong(position) async {
    dynamic longitude = position.longitude.toString();
    dynamic latitude = position.latitude.toString();

    data_latitude = position.latitude;
    data_longitude = position.longitude;
    Constants.prefs?.setString('longitude', longitude);
    Constants.prefs?.setString('latitude', latitude);
    final coordinates = Coordinates(data_latitude, data_longitude);
    final addresses = await geocoder.findAddressesFromCoordinates(coordinates);
    //print('addresses');
    //print(addresses);
    // String addressLine = addresses.first.addressLine!;
    //  Constants.prefs?.setString('address', addressLine.toString());
    setState(() {
      _mapLoading = false;
      // startLocation = LatLng(data_latitude, data_longitude);
      // data_loaded = true;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //print('placemarks dafsdf');
    //print(placemarks);
    Placemark place = placemarks[0];
    // doornocontroller.text = '${place.street}';

    //  '${place.street},${place.subLocality},${place.locality},${place.country},${place.postalCode},${data_latitude.toString()},${data_longitude.toString()}';
  }

  Future<void> _checkAddress() async {
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          isLoading = !isLoading;
        }));
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
      prices.clear();
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        //   //print(result);
        result['data'].forEach((element) {
          setState(() {
            prices.add(Homescreenpriceslist.fromJson(element));
            //   //print(result);
          });
          //  //print(prices);
        });
      } else {
        //Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> getcurrentorderslist() async {
    //print('dsf');
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}current_order"), body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      currentorderslist.clear();
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      //print('current orders');
      //print(result);
      if (result['status'] == 'success') {
        result['data'].forEach((element) {
          setState(() {
            currentorderslist.add(Currentordersmodal.fromJson(element));
            //   //print(result);
          });
          //  //print('currentorderslist');
          //   //print(currentorderslist);
          //   //print(currentorderslist.length);
        });
      } else {
        //  Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> makePayment(order_id, amount) async {
    //print(order_id);
    //print(amount);
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': order_id.toString(),
      'amount': amount.toString(),
      'wallet_amount': '0',
      'is_wallet_used': '0'
    };
    //print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}make_payment"), body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      //  //print(result);
      if (result['status'] == 'success') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CurrentOrderPayment(
                payment_url: result['data']['payment_initiate_url'],
                paymentId: result['data']['transaction_id'].toString())));
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => OrderPaymentRequestScreen(
        //       orderNo: result['data']['order_no'],
        //       order_id: order_id.toString()),
        // ));
      } else {
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  Future<void> ownerverifyOrder(order_id) async {
    //print(order_id);
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_id': order_id.toString(),
      'payment_type': 'Upfront',
      'order_action': '1',
    };
    //print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}approve_order"), body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      //print(result);
      if (result['status'] == 'success') {
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
        getcurrentorderslist();
      } else {
        // ignore: use_build_context_synchronously
        Constants.snackBar(context, '${result['message']}');
      }
    }
  }

  selectCategoryprice(priceCatId) {
    selectCatId = priceCatId.toString();
  }

  String? selectStationId;
  String? stationId;
  String? stationName;
  String? selectedValue;

  Future<void> _refresh() async {
    refresh();
  }

  refresh() {
    setState(() {
      getTodayprices();
      getstationslist();
      getcurrentorderslist();
      getorderslist();
      getnearBystations();
    });
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

  Future<void> getstationslist() async {
    stationslist.clear();
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}stations"), body: bodyData);
    //print('body data');
    //print(bodyData);
    //print('isloader: $isLoader');
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      //  //print(result);
      if (result['status'] == 'success') {
        if (result['data'] == null ||
            result['data'] == '' ||
            result['data'].length == 0) {
          stationslist.clear();
        } else {
          stationslist.clear();
          setState(() {
            isLoader = false;
            stationslist = result['data'];
            selectedData = stationslist[0];
            selectStationId = stationslist[0]['station_id'];
            if (Constants.prefs?.getString('selectStationId') == null ||
                Constants.prefs?.getString('selectStationId') == '') {
              selectedData = stationslist[0];
              selectStationId = stationslist[0]['station_id'];
              Constants.prefs
                  ?.setString('selectStationId', stationslist[0]['station_id']);
              for (var i = 0; i < result['data'].length; i++) {
                if (selectStationId == result['data'][i]['station_id']) {
                  selectedData = result['data'][i];
                }
              }
            } else {
              print('station dta');
              // Constants.prefs
              //     ?.setString('selectStationId', stationslist[0]['station_id']);
              selectStationId = Constants.prefs?.getString('selectStationId');
              for (var i = 0; i < result['data'].length; i++) {
                if (selectStationId == result['data'][i]['station_id']) {
                  selectedData = result['data'][i];
                }
              }
            }
            // selectedData = stationslist[0];

            print(selectedData);
            stationsCount = result['data'].length;
            //   managersCount = result['data']['total_records_count'];
          });
          //print('selectedData');
          //    //print(selectedData);
        }
      } else if (result['status'] == 'error') {
        setState(() {
          isLoader = false;
          stationsCount = 0;
        });
      }
    }
  }

  Future<void> getorderslist() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'order_status': 'Completed',
      'page': '1'
    };
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}order_list"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      completeorderslist.clear();
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        orders.clear();
        result['data']['result'].forEach((element) {
          setState(() {
            completeorderslist.add(OrdersListModal.fromJson(element));
            //   //print(result);
          });
          ordersCount = result['data']['total_records_count'];
        });
      } else if (result['status'] == 'error') {
        orders.clear();
        setState(() {
          ordersCount = 0;
        });
        //print(ordersCount);
      }
    }
  }

  Future<void> getnearBystations() async {
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    // //print(bodyData);
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}nearby_stations"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      //print(result);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        nearstations = result['data'];
        //print('nearstations');
        //  //print(nearstations);
        //  //print(nearstations);

        result['data'].forEach((element) {
          //print(element);
          _latLen.add(LatLng(double.parse(element['latitude']),
              double.parse(element['longitude'])));
          stationnames.add(element['station_name']);
        });
        //print('_latLen.length');
        //print(stationnames);
        setState(() {
          nearstationsCount = 1;
        });
        _getGeoLocationPosition();
        loadData();
      } else if (result['status'] == 'error') {
        //print(ordersCount);
        _getGeoLocationPosition();
        setState(() {
          nearstationsCount = 0;
        });
      }
    }
  }

  final List<Marker> _list = const [
    // List of Markers Added on Google Map
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 80.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.appThemeColor,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  var selectedstation = await showDialog(
                      context: context,
                      builder: (context) {
                        return SelectLocationPopup();
                      });
                  //  //print(selectedstation);
                  if (selectedstation['station_id'] != null) {
                    setState(() {
                      selectedData = selectedstation;
                      selectStationId = selectedstation['station_id'];
                      Constants.prefs?.setString(
                          'selectStationId', selectStationId.toString());
                    });
                    //print('selected station :$selectStationId');
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 16),
                  width: 100,
                  height: 38,
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (stationsCount != 0)
                        Text(
                          selectedData['station_name'],
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColor.whiteColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Image.asset('${StringConstatnts.assets}dropDown.png')
                    ],
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchorderList(),
                  ));
                },
                child: Container(
                    color: AppColor.whiteColor,
                    margin: EdgeInsets.only(right: 2),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Search For Orders',
                            style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.search)
                      ],
                    )),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: isLoader == false
              ? RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Container(
                        //   height: 76,
                        //   color: AppColor.appThemeColor,
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       InkWell(
                        //         onTap: () async {
                        //           var selectedstation = await showDialog(
                        //               context: context,
                        //               builder: (context) {
                        //                 return SelectLocationPopup();
                        //               });
                        //           //  //print(selectedstation);
                        //           if (selectedstation['station_id'] != null) {
                        //             setState(() {
                        //               selectedData = selectedstation;
                        //               selectStationId =
                        //                   selectedstation['station_id'];
                        //             });
                        //           }
                        //           //print(selectStationId);
                        //         },
                        //         child: Container(
                        //           margin: EdgeInsets.only(left: 16),
                        //           width: 100,
                        //           height: 38,
                        //           child: Row(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               if (stationsCount != 0)
                        //                 Flexible(
                        //                   child: Text(
                        //                     selectedData['station_name'],
                        //                     style: GoogleFonts.roboto(
                        //                         fontSize: 13,
                        //                         fontWeight: FontWeight.w400,
                        //                         color: AppColor.whiteColor),
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                 ),
                        //               Image.asset(
                        //                   '${StringConstatnts.assets}dropDown.png')
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       Spacer(),
                        //       InkWell(
                        //         onTap: () {
                        //           Navigator.of(context).push(MaterialPageRoute(
                        //             builder: (context) => SearchorderList(),
                        //           ));
                        //         },
                        //         child: Container(
                        //             color: AppColor.whiteColor,
                        //             margin: EdgeInsets.only(right: 16),
                        //             width:
                        //                 MediaQuery.of(context).size.width / 1.7,
                        //             height: 40,
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: Text(
                        //                     'Search For Orders',
                        //                     style: GoogleFonts.roboto(
                        //                         fontSize: 13,
                        //                         fontWeight: FontWeight.w400,
                        //                         color: AppColor.blackColor),
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                 ),
                        //                 Icon(Icons.search)
                        //               ],
                        //             )),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 16, left: 16),
                          child: Text(
                            'Current Order',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        currentorderslist.length != 0
                            ? SizedBox(
                                height: 210,
                                child: ListView.builder(
                                  itemCount: currentorderslist.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 16, right: 16, bottom: 16),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColor.appThemeColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 13,
                                            bottom: 13,
                                            left: 12,
                                            right: 12),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'Order ID: ',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColor
                                                            .appColor9A9A9A),
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text: currentorderslist[
                                                                index]
                                                            .orderId,
                                                        style: GoogleFonts.roboto(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColor
                                                                .appColor5C5C5C),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 11,
                                            ),
                                            Row(
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    text: currentorderslist[
                                                                    index]
                                                                .displayStatus ==
                                                            'Make Payment'
                                                        ? 'Amount to Pay: '
                                                        : 'Order Quantity: ',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColor
                                                            .appColor9A9A9A),
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text: currentorderslist[
                                                                        index]
                                                                    .displayStatus ==
                                                                'Make Payment'
                                                            ? '${currentorderslist[index].currency} ${currentorderslist[index].totalAmount}'
                                                            : currentorderslist[
                                                                    index]
                                                                .totalQuantity,
                                                        style: GoogleFonts.roboto(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColor
                                                                .appColor5C5C5C),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (currentorderslist[index]
                                                            .displayStatus ==
                                                        'Make Payment') {
                                                      makePayment(
                                                          currentorderslist[
                                                                  index]
                                                              .id,
                                                          currentorderslist[
                                                                  index]
                                                              .RemainingAmount
                                                              .toString());
                                                    } else if (currentorderslist[
                                                                index]
                                                            .displayStatus ==
                                                        'Verify Order') {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            ManagerVerifyOrder(
                                                                order_id: currentorderslist[
                                                                        index]
                                                                    .id
                                                                    .toString()),
                                                      ));
                                                      // ownerverifyOrder(
                                                      //     currentorderslist[
                                                      //             index]
                                                      //         .id);
                                                    } else if (currentorderslist[
                                                                index]
                                                            .displayStatus ==
                                                        'Review Order') {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReceiveNewOrderScreen(
                                                                orderId: currentorderslist[
                                                                        index]
                                                                    .id
                                                                    .toString()),
                                                      ));
                                                    } else if (currentorderslist[
                                                                index]
                                                            .displayStatus ==
                                                        'Pending') {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderSummaryScreen(
                                                                name: 'Pending',
                                                                order_id: currentorderslist[
                                                                        index]
                                                                    .id
                                                                    .toString()),
                                                      ));
                                                    } else if (currentorderslist[
                                                                index]
                                                            .displayStatus ==
                                                        'Processing') {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderSummaryScreen(
                                                                name:
                                                                    'Processing',
                                                                order_id: currentorderslist[
                                                                        index]
                                                                    .id
                                                                    .toString()),
                                                      ));
                                                    }
                                                  },
                                                  child: Container(
                                                      height: 32,
                                                      width: 121,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColor.blackColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    32 / 2),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: AppColor
                                                                  .blackColor
                                                                  .withOpacity(
                                                                      0.25),
                                                              offset:
                                                                  Offset(0, 2),
                                                              blurRadius: 4),
                                                        ],
                                                      ), //#
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        currentorderslist[index]
                                                            .displayStatus,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColor
                                                                    .whiteColor),
                                                      )),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      '${StringConstatnts.assets}nodata.png',
                                      height: 150,
                                    ),
                                    Container(
                                      child: Text('No current orders'),
                                    ),
                                  ],
                                ),
                              ),
                        Container(
                          height: 1,
                          color: AppColor.appColorC4C4C4,
                          margin: EdgeInsets.only(left: 16, right: 16, top: 13),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 0, left: 0),
                                child: Text(
                                  "Make An Order",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TodayPriceScreen(
                                        notificationsCountFun_value: () =>
                                            notificationsCountFun()),
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(24 / 2),
                                  ), //#
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      'View All',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 9),
                          height: 150,
                          child: ListView.builder(
                            itemCount: prices.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                              height: 150,
                              width: 104,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFBCD84E),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          prices[index]
                                              .name
                                              .toString(), //Petrol
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.blackColor),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Image.network(
                                          prices[index].imagePath.toString(),
                                          height: 18,
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 114,
                                    width: 104,
                                    decoration: BoxDecoration(
                                      color: AppColor.blackColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Text(
                                          '${prices[index].currency} ${prices[index].price} / ${prices[index].measurement}',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.whiteColor),
                                        ),
                                        Spacer(),
                                        Spacer(),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            //print("here data");
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AddCartPopup(
                                                      categoryId: prices[index]
                                                          .categoryId
                                                          .toString(),
                                                      cartCount: () => widget
                                                          .notificationsCountFun_value());
                                                });
                                            setState(() {
                                              selectCatId = prices[index]
                                                  .categoryId
                                                  .toString();
                                            });

                                            selectCategoryprice(selectCatId);
                                          },
                                          child: selectCatId !=
                                                  prices[index]
                                                      .categoryId
                                                      .toString()
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  width: 90,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30 / 2),
                                                  ),
                                                  child: Text(
                                                    'buy now'.toUpperCase(),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xFFBCBCBC)),
                                                  ),
                                                )
                                              : Container(
                                                  alignment: Alignment.center,
                                                  width: 90,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFBCD84E),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30 / 2),
                                                  ),
                                                  child: Text(
                                                    'buy now'.toUpperCase(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColor.blackColor,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: AppColor.appColorC4C4C4,
                          margin: EdgeInsets.only(left: 16, right: 16, top: 13),
                        ),
                        // if (ordersCount != 0)
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 0, left: 0),
                                child: Text(
                                  "Recent Ordered Product",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => OrderScreen(
                                            isHomeScreen: true,
                                          )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(24 / 2),
                                  ), //#
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      'View All',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        completeorderslist.length != 0
                            ? Container(
                                margin: EdgeInsets.only(left: 16, top: 9),
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: completeorderslist.length,
                                  itemBuilder: (context, index) => Container(
                                    height: 150,
                                    width: 104,
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFBCD84E),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                completeorderslist[index]
                                                    .orderId,
                                                //Petrol
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.blackColor),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderSummaryScreen(
                                                      name: 'Write A Review',
                                                      order_id:
                                                          completeorderslist[
                                                                  index]
                                                              .id,
                                                    ),
                                                  ));
                                                },
                                                child: Container(
                                                  height: 18,
                                                  width: 18,

                                                  decoration: BoxDecoration(
                                                    color: AppColor.whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18 / 2),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: AppColor
                                                              .blackColor
                                                              .withOpacity(
                                                                  0.25),
                                                          offset: Offset(0, 2),
                                                          blurRadius: 4),
                                                    ],
                                                  ), //#
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: Image.asset(
                                                        '${StringConstatnts.assets}right.png'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Spacer(),
                                        Spacer(),
                                        Container(
                                          height: 68,
                                          width: 104,
                                          decoration: BoxDecoration(
                                            color: AppColor.blackColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            completeorderslist[index]
                                                .productName,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.whiteColor),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          completeorderslist[index].orderStatus,
                                          style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.blackColor),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      '${StringConstatnts.assets}nodata.png',
                                      height: 150,
                                    ),
                                    Container(
                                      child: Text('No Recent Orders'),
                                    ),
                                  ],
                                ),
                              ),
                        if (ordersCount != 0)
                          Container(
                            height: 1,
                            color: AppColor.appColorC4C4C4,
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 13),
                          ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Container(
                        //         alignment: Alignment.topLeft,
                        //         margin: EdgeInsets.only(top: 0, left: 0),
                        //         child: Text(
                        //           "Near by Stations",
                        //           style: GoogleFonts.roboto(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w400,
                        //               color: AppColor.blackColor),
                        //         ),
                        //       ),
                        //       Spacer(),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 8,
                        // ),
                        // _mapLoading == true
                        //     ? Container(
                        //         height: 250,
                        //         margin: EdgeInsets.all(10),
                        //         child: GoogleMap(
                        //           initialCameraPosition: CameraPosition(
                        //             target: startLocation,
                        //             zoom: 12.0,
                        //           ),
                        //           markers: Set<Marker>.of(_markers),
                        //           mapType: MapType.normal,
                        //           myLocationEnabled: true,
                        //           myLocationButtonEnabled: true,
                        //           compassEnabled: true,
                        //           onMapCreated:
                        //               (GoogleMapController controller) {
                        //             mapController = controller;
                        //           },
                        //         ))
                        //     : Center(
                        //         child: Container(
                        //           child: CircularProgressIndicator(
                        //               color: AppColor.appThemeColor,
                        //               strokeWidth: 3),
                        //         ),
                        //       ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    child: CircularProgressIndicator(
                        color: AppColor.appThemeColor, strokeWidth: 3),
                  ),
                ),
        ),
      ),
    );
  }
}

// Container(
//   margin: EdgeInsets.only(left: 16, top: 9),
//   height: 150,
//   child: Obx(
//     () => ownerHomeScreenController
//             .currentOrderFinalData.isEmpty
//         ? Text('No Data Found')
//         : ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: ownerHomeScreenController
//                 .currentOrderFinalData.length,
//             itemBuilder: (context, index) => Container(
//               height: 150,
//               width: 104,
//               margin: EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(
//                 color: Color(0xFFBCD84E),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.only(top: 8),
//                     child: Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           index == 0
//                               ? ownerHomeScreenController
//                                   .currentOrderFinalData[
//                                       index]
//                                   .orderId
//                               : index == 1
//                                   ? ownerHomeScreenController
//                                       .currentOrderFinalData[
//                                           index]
//                                       .orderId
//                                   : ownerHomeScreenController
//                                       .currentOrderFinalData[
//                                           index]
//                                       .orderId, //Petrol
//                           style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: AppColor.blackColor),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context)
//                                 .push(MaterialPageRoute(
//                               builder: (context) =>
//                                   OrderSummaryScreen(
//                                 name:
//                                     'Recent Ordered Product',
//                                 order_id:
//                                     ownerHomeScreenController
//                                         .currentOrderFinalData[
//                                             index]
//                                         .id,
//                               ),
//                             ));
//                           },
//                           child: Container(
//                             height: 18,
//                             width: 18,

//                             decoration: BoxDecoration(
//                               color: AppColor.whiteColor,
//                               borderRadius:
//                                   BorderRadius.circular(
//                                       18 / 2),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: AppColor
//                                         .blackColor
//                                         .withOpacity(
//                                             0.25),
//                                     offset: Offset(0, 2),
//                                     blurRadius: 4),
//                               ],
//                             ), //#
//                             alignment: Alignment.center,
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.all(0),
//                               child: Image.asset(
//                                   '${StringConstatnts.assets}right.png'),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   Spacer(),
//                   Spacer(),
//                   Container(
//                     height: 68,
//                     width: 104,
//                     decoration: BoxDecoration(
//                       color: AppColor.blackColor,
//                       borderRadius:
//                           BorderRadius.circular(15),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       index == 0
//                           ? ownerHomeScreenController
//                               .currentOrderFinalData[
//                                   index]
//                               .productName
//                           : index == 1
//                               ? ownerHomeScreenController
//                                   .currentOrderFinalData[
//                                       index]
//                                   .productName
//                               : ownerHomeScreenController
//                                   .currentOrderFinalData[
//                                       index]
//                                   .productName,
//                       style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           color: AppColor.whiteColor),
//                     ),
//                   ),
//                   Spacer(),
//                   Text(
//                     ownerHomeScreenController
//                         .currentOrderFinalData[index]
//                         .orderStatus,
//                     style: GoogleFonts.poppins(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w400,
//                         color: AppColor.blackColor),
//                   ),
//                   Spacer(),
//                 ],
//               ),
//             ),
//           ),
//   ),
// ),
