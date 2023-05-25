import 'package:flutter/material.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location_geocoder/location_geocoder.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import "dart:io";
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/src/foundation/key.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

class ProfileLocation extends StatefulWidget {
  const ProfileLocation({super.key});

  @override
  State<ProfileLocation> createState() => _ProfileLocationState();
}

class _ProfileLocationState extends State<ProfileLocation> {
  String googleApikey = "AIzaSyANKvvGW7sjJjBs_VR2iaV87RPXYi0auLg";
  final LocatitonGeocoder geocoder =
      LocatitonGeocoder('AIzaSyANKvvGW7sjJjBs_VR2iaV87RPXYi0auLg');
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  //Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? mapController;
  late double data_latitude;
  late double data_longitude;
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
  bool locationloader = false;
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
  //late final LatLng? startLocation;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _getGeoLocationPosition();

    //  _checkAddress();
    //  getLocation();
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController.complete(controller);
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
      print(startLocation);
      GetAddressFromLatLong(startLocation);
      // getIcons();
    });
    return await Geolocator.getCurrentPosition();
  }

  late BitmapDescriptor _markerDirection;

  Future<void> GetAddressFromLatLong(position) async {
    print('address');
    print(position);
    setState(() {
      locationloader = true;
    });
    print(locationloader);
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
    String addressLine = addresses.first.addressLine!;
    Constants.prefs?.setString('address', addressLine.toString());
    setState(() {
      first = Constants.prefs?.getString('address');
      if (place_location != null) {
        location = place_location;
        place_location = null;
      } else {
        location = first;
      }
      _mapLoading = true;
      // selected_data = [
      //   {'location': location, 'latitude': latitude, 'longitude': longitude}
      // ];
      startLocation = LatLng(data_latitude, data_longitude);
      data_loaded = true;

      locationloader = false;
    });
    print(locationloader);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    // doornocontroller.text = '${place.street}';
    address =
        '${place.street},${place.subLocality},${place.locality},${place.country},${place.postalCode}';
    pincode = '${place.postalCode}';
    selectedaddress = {
      "street": "${place.name},${place.street},${place.subThoroughfare}",
      "locality": "${place.locality}",
      "subLocality": "${place.subLocality}",
      "country": "${place.country}",
      "state": "${place.administrativeArea}",
      "postalCode": "${place.postalCode}",
      "latitude": "${data_latitude}",
      "longitude": "${data_longitude}",
      // ',${place.subLocality},${place.locality},${place.country},${place.postalCode},${data_latitude.toString()},${data_longitude.toString()}'
    };

    //  '${place.street},${place.subLocality},${place.locality},${place.country},${place.postalCode},${data_latitude.toString()},${data_longitude.toString()}';
  }

  Future<void> _checkAddress() async {
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          isLoading = !isLoading;
        }));
  }

  sendLocationData() {
    Navigator.pop(context, selectedaddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context,
            title: 'Use Your Location', onTaped: () {
          Navigator.pop(context);
        }),
        body: Stack(children: [
          _mapLoading == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                    onCameraMove: (CameraPosition cameraPositiona) async {
                      cameraPosition = cameraPositiona; //when map is dragging
                    },
                    onCameraIdle: () async {
                      //when map drag stops
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              cameraPosition.target.latitude,
                              cameraPosition.target.longitude);
                      print('cmea');
                      print(cameraPosition.target.latitude);
                      setState(() {
                        print('placemarks');
                      });
                      late double cameralat = cameraPosition.target.latitude;
                      late double cameralang = cameraPosition.target.longitude;
                      print(cameralat);
                      startLocation = LatLng(cameralat, cameralang);
                      print('Start location :${startLocation}');
                      GetAddressFromLatLong(startLocation);
                      //  startLocation = cameralat;
                      //  Position position = cameralat +','+cameralat
                      // GetAddressFromLatLong(cameralat);
                      //   GetAddressFromLatLong();
                    },
                  ),
                )
              : Center(
                  // top: 100,
                  // left: 50,
                  child: CircularProgressIndicator(
                  strokeWidth: 2,
                )),
          Positioned(
              //search input bar
              top: -10,
              child: InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        components: [Component(Component.country, 'ind')],
                        //google_map_webservice package
                        onError: (err) {
                          print(err);
                        });

                    if (place != null) {
                      setState(() {
                        data_loaded = false;
                        print(place.description);
                        location = place.description.toString();
                        place_location = place.description.toString();
                        print(location);
                      });

                      //form google_maps_webservice package
                      final plist = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);
                      //move map camera to selected place with animation
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatlang, zoom: 18)));
                      setState(() {
                        data_loaded = false;
                        selected_data = [
                          {
                            'location': location,
                            'latitude': lat,
                            'longitude': lang
                          }
                        ];
                        selectFromPlace = true;
                        startLocation = LatLng(selected_data[0]['latitude'],
                            selected_data[0]['longitude']);
                        GetAddressFromLatLong(startLocation);
                      });
                      print(selected_data);
                      //startLocation = LatLng(latitude, longitude)
                      print(location);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 80,
                          child: ListTile(
                            title: Text(
                              location,
                              maxLines: 2,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          )),
                    ),
                  ))),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(
                color: AppColor.appThemeColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            address.toString(),
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              onPressed: () {
                                sendLocationData();
                              },
                              child: Text(
                                'save',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  shape: StadiumBorder()),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
              child: Image(
                  width: 50,
                  image: AssetImage(
                      '${StringConstatnts.assets}locationgreen.png'))),
        ]));
  }
}
