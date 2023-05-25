// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/profile_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/web_services_owner/profilemap_selection.dart';
//import 'package:location_geocoder/location_geocoder.dart';
import '../../Common/constants.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;
//import 'package:geocoder/geocoder.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/location_geocoder.dart';
//import 'package:location/location.dart';
import "dart:io";
import 'dart:async';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? user_id = Constants.prefs?.getString('user_id');
  String? user_token = Constants.prefs?.getString('user_token');
  bool isloader = false;
  bool isloading = false;
  late double data_latitude;
  late double data_longitude;
  String? addresstext;
  String? pincodetext;
  final picker = ImagePicker();
  XFile? _profileImage;
  XFile? picimage;
  late String baseUploadImage;
  String? user_type;
  String? latitude;
  String? longitude;
  String? profile_picture;
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
    getProfile();
    super.initState();
    // _getGeoLocationPosition();
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  //TextEditingController vehicletypecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();

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
        .post(Uri.parse("${Constants.baseurl}profile"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      print("print is.....${result}");
      setState(() {
        isloader = false;
      });
      if (result['status'] == 'success') {
        namecontroller.text = result['data']['name'];
        emailcontroller.text = result['data']['email'];
        mobilecontroller.text = result['data']['mobile'];
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

          data_latitude = double.parse(latitude.toString());
          data_longitude = double.parse(longitude.toString());
        }

        startLocation = LatLng(data_latitude, data_longitude);
        //  GetAddressFromLatLong(startLocation);
      }
    }
  }

  Future<void> updateProfile() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
        // ignore: avoid_print
        print(isloading);
      });
      Map<String, dynamic> bodyData = {
        'user_token': user_token.toString(),
        'name': namecontroller.text,
        'email': emailcontroller.text,
        'mobile': mobilecontroller.text,
        'address': address.toString(),
        'latitude': data_latitude.toString(),
        'longitude': data_longitude.toString()
      };
      print(bodyData);
      http.Response response = await http.post(
          Uri.parse("${Constants.baseurl}profile_update"),
          body: bodyData);

      if (response.statusCode == 200) {
        var result = convert.jsonDecode(response.body);
        setState(() {
          isloading = false;
        });
        if (result['status'] == 'success') {
          // reidrect to login Page
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ProfileScreen()));
        } else {
          // print("existing mobilenumber");
          // invalid
          final snackBar = SnackBar(
            content: Text("${result['message']}"),
            action: SnackBarAction(
              label: "Close",
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  Future pickProfileImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      picimage = XFile(pickedFile.path);
      _profileImage = XFile(pickedFile.path);
      Dio d = Dio();
      FormData formData = dio.FormData.fromMap({
        'profile_pic': _profileImage != null
            ? await dio.MultipartFile.fromFile(_profileImage!.path,
                filename: 'image.jpg')
            : " ",
        'user_token': user_token.toString(),
      });
      print(formData.fields);
      var response = d
          .post("https://colormoon.in/eqwi_petrol/api/V1/update_profile_pic",
              data: formData)
          .then((result) {
        final jsonResponse = (result.data);
        print("respons${result}");
        if (jsonResponse['status'] == 'success') {
          print(jsonResponse['data']);
          setState(() {
            profile_picture = jsonResponse['data']['profile_pic_url'];
          });
        } else {
          profile_picture = '';
        }
      }).catchError((e) {
        print('fdfdg');
        print(e);
      });
    } else {
      print("Upload Image Failed");
    }
    // setState(() {
    //   isLoadingImage = false;
    // });
  }

  Future pickProfileImage1() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);

    if (pickedFile != null) {
      picimage = XFile(pickedFile.path);
      _profileImage = XFile(pickedFile.path);
      Dio d = Dio();
      FormData formData = dio.FormData.fromMap({
        'profile_pic': _profileImage != null
            ? await dio.MultipartFile.fromFile(_profileImage!.path,
                filename: 'image.jpg')
            : " ",
        'user_token': user_token.toString(),
      });
      print(formData);
      var response = d
          .post("https://colormoon.in/eqwi_petrol/api/V1/update_profile_pic",
              data: formData)
          .then((result) {
        final jsonResponse = (result.data);
        print("respons${result}");
        if (jsonResponse['status'] == 'success') {
          print(jsonResponse['data']);
          setState(() {
            profile_picture = jsonResponse['data']['profile_pic_url'];
          });
        } else {
          profile_picture = '';
        }
      }).catchError((e) {
        print(e);
      });
    } else {
      print("Upload Image Failed");
    }
  }

  Widget bottomSheet(context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontFamily: "Mulish",
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      pickProfileImage1();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Camera"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      pickProfileImage();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Gallery"),
                      ],
                    ),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context, title: 'Edit Profile',
            onTaped: () {
          Navigator.pop(context);
        }),
        body: Form(
          key: formkey,
          child: isloader == false
              ? ListView(
                  children: [
                    Container(
                      height: 94,
                      color: AppColor.whiteColor,
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(left: 20, top: 23),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2.0,
                                    ),
                                    color: Colors.blueGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: profile_picture.toString(),
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      )),
                                    ),
                                  )),
                            ),
                            Transform.translate(
                              offset: Offset(-20, 40),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 50,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) =>
                                            bottomSheet(context)),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color(0xFF707070),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  namecontroller.text.toString(),
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
                                  emailcontroller.text.toString(),
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
                      margin: EdgeInsets.only(left: 16, top: 10, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF646464)),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: namecontroller,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(20),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'Enter Name',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    hintStyle: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFA0A0A0),
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        '${StringConstatnts.assets}user_id.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your name';
                                    } else if (value.length < 3) {
                                      return 'minimum 3 letters';
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email id',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                SizedBox(
                                  height: 48,
                                  child: TextFormField(
                                    controller: emailcontroller,
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                              '${StringConstatnts.assets}mail.png'),
                                        ),
                                        contentPadding: EdgeInsets.all(10.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintStyle: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFFA0A0A0),
                                        )),
                                    validator: (value) {
                                      RegExp emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                      if (value!.isEmpty) {
                                        return 'Please enter email id';
                                      } else if (!emailValid.hasMatch(value)) {
                                        return 'Please enter valid email address';
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone Number',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                SizedBox(
                                  height: 48,
                                  child: TextFormField(
                                    enableInteractiveSelection: false,
                                    readOnly: true,
                                    controller: mobilecontroller,
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                              '${StringConstatnts.assets}mobile.png'),
                                        ),
                                        contentPadding: EdgeInsets.all(10.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintStyle: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFFA0A0A0),
                                        )),
                                  ),
                                )
                              ],
                            ),
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
                            margin: EdgeInsets.only(bottom: 16),
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
                                    onMapCreated:
                                        (GoogleMapController controller) {
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
                        Positioned(
                            bottom: 8,
                            right: 25,
                            child: InkWell(
                              onTap: () async {
                                var selectedaddress =
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                  builder: (context) => ProfileLocation(),
                                ));
                                print('address coming');
                                print(selectedaddress);
                                if (selectedaddress['latitude'] != null) {
                                  setState(() {
                                    address =
                                        '${selectedaddress['street']},${selectedaddress['locality']},${selectedaddress['state']},${selectedaddress['country']},${selectedaddress['postalCode']}';
                                    latitude =
                                        selectedaddress['latitude'].toString();
                                    longitude =
                                        selectedaddress['longitude'].toString();
                                    data_latitude =
                                        double.parse(latitude.toString());
                                    data_longitude =
                                        double.parse(longitude.toString());
                                    startLocation =
                                        LatLng(data_latitude, data_longitude);
                                    GetAddressFromLatLong(startLocation);
                                  });
                                }
                              },
                              child: Image.asset(
                                '${StringConstatnts.assets}add_loction.png',
                                height: 25,
                              ),
                            )),
                      ],
                    ),

                    Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, top: 82, bottom: 40),
                        child: isloading == false
                            ? ElevatedButton(
                                onPressed: () {
                                  updateProfile();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                                child: Text(
                                  'UPDATE',
                                  style: TextStyle(
                                      fontFamily: "ROBOTO",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                                child: Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3),
                                  ),
                                ),
                              )),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context).pop();
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 16, bottom: 19, right: 16, top: 19),
                    //     alignment: Alignment.center,
                    //     height: 48,
                    //     decoration: BoxDecoration(
                    //       color: AppColor.blackColor,
                    //       borderRadius: BorderRadius.circular(48 / 2),
                    //     ),
                    //     child: Text(
                    //       'UPDATE',
                    //       style: GoogleFonts.roboto(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColor.whiteColor),
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              : Center(
                  child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: AppColor.appThemeColor, strokeWidth: 3),
                  ),
                ),
        ));
  }
}
