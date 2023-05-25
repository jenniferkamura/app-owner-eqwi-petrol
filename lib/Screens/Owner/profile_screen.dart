// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart' as geo;
//import 'package:location/location.dart ' as geo;
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/edit_profile_screen.dart';
import 'package:location_geocoder/location_geocoder.dart';
import '../../Common/constants.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';
import "dart:io";
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool locationloader = false;
  bool isloader = false;
  bool bodyLoader = false;
  late double data_latitude;
  late double data_longitude;
  String? addresstext;
  String? pincodetext;
  String? name;
  String? mobile;
  String? email;
  String? user_type;
  String? profile_picture;
  String? user_id = Constants.prefs?.getString('user_id');
  // late LatLng latlong = LatLng(0.0, 0.0);
  // late CameraPosition cameraPosition;
  String? user_token = Constants.prefs?.getString('user_token');
  String googleApikey = "AIzaSyANKvvGW7sjJjBs_VR2iaV87RPXYi0auLg";
  final LocatitonGeocoder geocoder =
      LocatitonGeocoder('AIzaSyANKvvGW7sjJjBs_VR2iaV87RPXYi0auLg');
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  //Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? mapController;
  late LatLng latlong = LatLng(0.0, 0.0);
  late CameraPosition cameraPosition;
  //late GoogleMapController controller;
  bool data_loaded = false;
  var place_location;
  Set<Marker> _markers = {};
  bool _mapLoading = false;
  bool selectFromPlace = false;
  //String location = "";
  late BitmapDescriptor icon;
  var startLocation;
  late LatLng showLocation;
  bool isLoading = true;
  List<dynamic> selected_data = [];
  ScrollController scrollController = ScrollController();

  ///google places

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(87.99999, 78.99999), zoom: 14.5);

  // Set<Marker> markersList = {};
  final Set<Marker> markers = new Set();
  // GoogleMapController? mapController;
  var first; //markers for google map
  // final Mode _mode = Mode.overlay;
  String location = "Search";
  String? address = '';
  var selectedaddress;
  String? pincode;

  bool mapLoading = false;
  @override
  void initState() {
    //  getUserLocation();
    getProfile();
    super.initState();
    //  _getGeoLocationPosition();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // getUserLocation() async {
  //   startLocation = await locateUser();
  //   print('startLocation $startLocation');
  //   setState(() {
  //     latlong = LatLng(startLocation.latitude, startLocation.longitude);
  //   });
  //   print('center $latlong');
  // }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
      // return Future.error('Location services are disabled.');
    }

    if (serviceEnabled == false) {
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

    setState(() {
      startLocation = LatLng(position.latitude, position.longitude);
      _mapLoading = true;
      print('startLocation $startLocation');

      // getIcons();
    });
    return await Geolocator.getCurrentPosition();
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
    // Constants.prefs?.setString('longitude', longitude);
    // Constants.prefs?.setString('latitude', latitude);
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
    address =
        '${place.street},${place.subLocality},${place.locality},${place.country},${place.postalCode}';
    pincode = '${place.postalCode}';

    //  '${place.street},${place.subLocality},${place.locality},${place.country},${place.postalCode},${data_latitude.toString()},${data_longitude.toString()}';
  }

  Future<void> _checkAddress() async {
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          isLoading = !isLoading;
        }));
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
        .post(Uri.parse(Constants.baseurl + "profile"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      print("print is.....${result}");
      setState(() {
        isloader = false;
      });
      if (result['status'] == 'success') {
        name = result['data']['name'];
        email = result['data']['email'];
        mobile = result['data']['mobile'];
        profile_picture = result['data']['profile_pic_url'];
        address = result['data']['address'];
        user_type = result['data']['user_type'];
        // dynamic latitude = '17.54657567';
        // dynamic longitude = '88.656757657';
        if (result['data']['latitude'] == '' &&
            result['data']['longitude'] == '') {
          _getGeoLocationPosition();
        } else {
          dynamic latitude = result['data']['latitude'];
          dynamic longitude = result['data']['longitude'];
          print(latitude);
          data_latitude = double.parse(latitude.toString());
          data_longitude = double.parse(longitude.toString());
        }

        print(data_latitude);
        startLocation = LatLng(data_latitude, data_longitude);
        //  GetAddressFromLatLong(startLocation);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isloader == false
          ? ListView(
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
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(24 / 2),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColor.blackColor.withOpacity(0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 4),
                              ],
                            ), //#
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Image.asset(
                                  '${StringConstatnts.assets}back.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Profile ',
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColor.whiteColor),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 48,
                            height: 32,
                            decoration: BoxDecoration(),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Edit',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.whiteColor),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 94,
                  color: AppColor.whiteColor,
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, top: 23),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 70,
                            imageUrl: profile_picture.toString(),
                            placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            )),
                          ),
                        ),
                        // Image.network(
                        //   profile_picture.toString(),
                        //   height: 85,
                        // ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF656565)),
                            ),
                            Text(
                              user_type.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF656565)),
                            ),
                            Text(
                              email.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF656565)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, top: 40, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF656565)),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Text(
                        name.toString(),
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 39,
                      ),
                      Text(
                        'Email id',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF656565)),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Text(
                        email.toString(),
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 39,
                      ),
                      Text(
                        'Phone Number',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF656565)),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Text(
                        mobile.toString(),
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 39,
                      ),
                      Container(
                        height: 1,
                        color: Color(0xFFC4C4C4),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Delivery Address',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF656565)),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 15,
                                offset: Offset(0, 1),
                                color: Colors.black.withOpacity(0.25))
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(top: 9, left: 16, right: 16),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 16, left: 11, right: 11, bottom: 16),
                        child: Column(
                          children: [
                            // _mapLoading == true
                            //     ?
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              color: Colors.white,
                              child: GoogleMap(
                                zoomControlsEnabled: true,
                                mapType: MapType.normal,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                initialCameraPosition: CameraPosition(
                                  target: startLocation,
                                  zoom: 12.0,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  mapController = controller;
                                },
                                markers: markers,
                              ),
                            ),
                            // : Center(
                            //     // top: 100,
                            //     // left: 50,
                            //     child: CircularProgressIndicator(
                            //     strokeWidth: 2,
                            //   )),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  '${StringConstatnts.assets}location_finder.png',
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Expanded(
                                  child: Text(
                                    address.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF656565)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 75,
                      right: 0,
                      left: 0,
                      child: Center(
                          child: Image(
                              width: 50,
                              image: AssetImage(
                                  '${StringConstatnts.assets}locationgreen.png'))),
                    ),
                    // Positioned(
                    //     bottom: 8,
                    //     right: 25,
                    //     child: Image.asset(
                    //       '${StringConstatnts.assets}add_loction.png',
                    //       height: 25,
                    //     )),
                  ],
                ),
              ],
            )
          : Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: AppColor.appThemeColor, strokeWidth: 3),
              ),
            ),
    );
  }
}
