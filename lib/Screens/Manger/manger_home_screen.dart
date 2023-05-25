// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Popup/add_to_cart_popup.dart';
import 'package:owner_eqwi_petrol/Popup/select_location_popup.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_payment_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/receive_new_order_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/today_price_screen.dart';
import 'package:http/http.dart' as http;
import 'package:owner_eqwi_petrol/modals/currentordermodal.dart';
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
import '../../Common/constants.dart';
import '../../modals/latestpriceslist.dart';
import 'package:owner_eqwi_petrol/modals/orderlistmodal.dart';
import 'dart:convert' as convert;
import '../Owner/searchorderlist.dart';

class ManagerHomeScreen extends StatefulWidget {
  final Function notificationsCountFun_value;
  const ManagerHomeScreen(
      {super.key, required this.notificationsCountFun_value});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  String? selectedValue;
  bool loader = false;
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
  String? user_token = Constants.prefs?.getString('user_token');

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
  List orders = [];
  int ordersCount = 0;
  var globalMarkers;
  final List<Marker> _markers = <Marker>[];
  late LatLng latlong = LatLng(0.0, 0.0);
  List<LatLng> _latLen = <LatLng>[
    // LatLng(17.7974883746824, 83.28544411808252),
    // LatLng(17.745819473183968, 83.28099399805069),
  ];
  // created list of coordinates of various locations

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

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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

      // print(startLocation);
      //   GetAddressFromLatLong(startLocation);
      // getIcons();
    });
    return await Geolocator.getCurrentPosition();
  }

  loadData() async {
    print('loaddata');

    for (int i = 0; i < images.length; i++) {
      print(images.length);
      final Uint8List markIcons = await getImages(images[i], 100);
      // print(_latLen[i]);
      // makers added according to index
      _markers.add(Marker(
        // given marker id
        markerId: MarkerId(i.toString()),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(markIcons),
        // given position
        position: _latLen[i],
        infoWindow: InfoWindow(
          // given title for marker
          title: stationnames[i],
        ),
      ));
      setState(() {});
    }
  }

  late BitmapDescriptor _markerDirection;

  Future<void> GetAddressFromLatLong(position) async {
    print('address');
    print(position);

    dynamic longitude = position.longitude.toString();
    dynamic latitude = position.latitude.toString();
    print(latitude);
    print(longitude);
    data_latitude = position.latitude;
    data_longitude = position.longitude;
    Constants.prefs?.setString('longitude', longitude);
    Constants.prefs?.setString('latitude', latitude);
    final coordinates = new Coordinates(data_latitude, data_longitude);
    final addresses = await geocoder.findAddressesFromCoordinates(coordinates);
    print('addresses');
    print(addresses);
    // String addressLine = addresses.first.addressLine!;
    //  Constants.prefs?.setString('address', addressLine.toString());
    setState(() {
      _mapLoading = false;
      // startLocation = LatLng(data_latitude, data_longitude);
      // data_loaded = true;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print('placemarks dafsdf');
    print(placemarks);
    Placemark place = placemarks[0];
    // doornocontroller.text = '${place.street}';

    //  '${place.street},${place.subLocality},${place.locality},${place.country},${place.postalCode},${data_latitude.toString()},${data_longitude.toString()}';
  }

  Future<void> _checkAddress() async {
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          isLoading = !isLoading;
        }));
  }

  void initState() {
    getTodayprices();
    getstationslist();
    getcurrentorderslist();
    getnearBystations();
  }

  selectCategoryprice(priceCatId) {
    selectCatId = priceCatId.toString();
  }

  String? selectStationId;
  String? stationId;
  String? stationName;

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

  Future<void> getcurrentorderslist() async {
    print('dsf');
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "current_order"), body: bodyData);
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      //  print(result);
      if (result['status'] == 'success') {
        result['data'].forEach((element) {
          setState(() {
            currentorderslist.add(Currentordersmodal.fromJson(element));
            //   print(result);
          });
          //  print('currentorderslist');
          //   print(currentorderslist);
          //   print(currentorderslist.length);
        });
      } else {
        Constants.snackBar(context, '${result['message']}');
      }
    }
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

  Future<void> _refresh() async {
    refresh();
  }

  refresh() {
    setState(() {
      getTodayprices();
      getstationslist();
      getcurrentorderslist();
      getnearBystations();
    });
  }

  Future<void> getTodayprices() async {
    // dynamic sliders = [];
    // Map<String, dynamic> bodyData = {'user_access_token': token};
    setState(() {
      loader = true;
    });
    http.Response response =
        await http.get(Uri.parse(Constants.baseurl + "category_prices"));
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        loader = false;
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
        Constants.snackBar(context, '${result['message']}');
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
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "nearby_stations"), body: bodyData);

    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body);
      print(result);
      // dart array
      // loaderIndicator = convert.jsonDecode(response.body);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        nearstations = result['data'];
        print('nearstations');
        //  print(nearstations);
        //  print(nearstations);

        result['data'].forEach((element) {
          print(element);
          _latLen.add(LatLng(double.parse(element['latitude']),
                  double.parse(element['longitude']))
              // stationName: element['station_name']
              );
          stationnames.add(element['station_name']);
        });
        print('_latLen.length');
        print(stationnames);
        _getGeoLocationPosition();
        loadData();
      } else if (result['status'] == 'error') {
        print(ordersCount);
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
                  //  print(selectedstation);
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
                    child: Column(
                      children: [
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
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  thickness: 12,
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
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 13,
                                                  bottom: 13,
                                                  left: 12,
                                                  right: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text.rich(
                                                        TextSpan(
                                                          text: 'Order ID: ',
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColor
                                                                  .appColor9A9A9A),
                                                          children: <
                                                              InlineSpan>[
                                                            TextSpan(
                                                              text:
                                                                  currentorderslist[
                                                                          index]
                                                                      .orderId,
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: AppColor
                                                                      .appColor5C5C5C),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      if (currentorderslist[
                                                                  index]
                                                              .displayStatus ==
                                                          'Review Order')
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (currentorderslist[
                                                                        index]
                                                                    .displayStatus ==
                                                                'Review Order') {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ReceiveNewOrderScreen(
                                                                        orderId: currentorderslist[index]
                                                                            .id
                                                                            .toString()),
                                                              ));
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 24,
                                                            width: 24,

                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColor
                                                                  .whiteColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24 /
                                                                              2),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: AppColor
                                                                        .blackColor
                                                                        .withOpacity(
                                                                            0.25),
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                    blurRadius:
                                                                        4),
                                                              ],
                                                            ), //#
                                                            alignment: Alignment
                                                                .center,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child: Image.asset(
                                                                  '${StringConstatnts.assets}right.png'),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'Order Date: ',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColor
                                                              .appColor9A9A9A),
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text:
                                                              currentorderslist[
                                                                      index]
                                                                  .orderDate,
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColor
                                                                  .appColor5C5C5C),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'Order Status: ',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColor
                                                              .appColor9A9A9A),
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text:
                                                              currentorderslist[
                                                                      index]
                                                                  .orderStatus,
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColor
                                                                  .appColor5C5C5C),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: Color(0xFFD3D3D3),
                                              height: 1,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 13,
                                                  bottom: 13,
                                                  left: 12,
                                                  right: 12),
                                              child: Row(
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'Quantity: ',
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
                                                                  .totalQuantity +
                                                              ' ' +
                                                              currentorderslist[
                                                                      index]
                                                                  .measurment,
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColor
                                                                  .blackColor),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'Total Amount: ',
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
                                                                  .currency +
                                                              ' ' +
                                                              currentorderslist[
                                                                      index]
                                                                  .totalAmount,
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColor
                                                                  .blackColor),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
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
                              // GestureDetector(
                              //   onTap: () {
                              //     // Navigator.of(context).push(MaterialPageRoute(
                              //     //   builder: (context) => TodayPriceScreen(),
                              //     // ));
                              //   },
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color: Color(0xFFF2F2F2),
                              //       borderRadius: BorderRadius.circular(24 / 2),
                              //     ), //#
                              //     alignment: Alignment.center,
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(6),
                              //       child: Text(
                              //         'View All',
                              //         style: GoogleFonts.roboto(
                              //             fontSize: 12,
                              //             fontWeight: FontWeight.w400,
                              //             color: AppColor.blackColor),
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
                                      children: [
                                        Spacer(),
                                        Text(
                                          '${prices[index].currency} ${prices[index].price} / Litr',
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
                                  )
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
                        // Container(
                        //   margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Container(
                        //         alignment: Alignment.topLeft,
                        //         margin: EdgeInsets.only(top: 0, left: 0),
                        //         child: Text(
                        //           "Nearby Stations",
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
                        //         ),
                        //       )
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
