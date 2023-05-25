import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/common_button.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_profile/screens/transporter_edit_third_screen.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../../controllers/edit_profile_controller.dart';
import 'dart:async';

class TransporterSecondEditScreen extends StatefulWidget {
  final String name;
  final String email;
  final String mobileNumber;
  final String vehicleNumber;
  final String vehicleCapacity;
  final String profileImage;

  const TransporterSecondEditScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.mobileNumber,
      required this.vehicleNumber,
      required this.vehicleCapacity,
      required this.profileImage})
      : super(key: key);

  @override
  State<TransporterSecondEditScreen> createState() =>
      _TransporterSecondEditScreenState();
}

class _TransporterSecondEditScreenState
    extends State<TransporterSecondEditScreen> {
  EditProfileController profileController = Get.put(EditProfileController());
  int count = 0;
  XFile? profilePicXFile;
  File? profilePicFile;
  String vehicleDocument = "";
  XFile? _vehicleDocument;
  String vehiclePhoto = "";
  String vehicleFrontPhoto = "";
  String? vehicleFrontShowPhoto;
  String vehicleBackPhoto = "";
  String? vehicleBackShowPhoto;
  String vehicleLeftPhoto = "";
  String? vehicleLeftShowPhoto;
  String vehicleRightPhoto = "";
  String? vehicleRightShowPhoto;
  String? vehicleShowDocument;
  String? vehicleShowPhoto;
  XFile? picImage;
  late String numberOfCompartments;
  String? vehicleId;
  String? licenseNumber;
  String? vehiclePicData;
  final picker = ImagePicker();
  List vehicleCapacityData = [];
  List vehicleDetails = [];
  bool isLoader = false;
  String? userToken = Constants.prefs?.getString('user_token');
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());
  int noOfCompartments = 1;
  dynamic _finalData = [];
  bool isDataLoader = false;
  List<String> selectedIndex = ['1000', '1000', '1000', '1000', '1000', '1000'];

  onSubmitFun() {
    _finalData = [];
    for (var i = 0; i < noOfCompartments; i++) {
      setState(() {
        _finalData.add({
          "compartment_no": i + 1,
          "compartment_capacity": selectedIndex[i]
        });
      });
    }
  }

  nextButtonSubmit() async {
    if (vehicleFrontPhoto.isEmpty || vehicleFrontShowPhoto == null) {
      Fluttertoast.showToast(
          msg: 'please select vehicle Front Photo',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (vehicleBackPhoto.isEmpty || vehicleBackShowPhoto == null) {
      Fluttertoast.showToast(
          msg: 'please select vehicle Back Photo',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (vehicleLeftPhoto.isEmpty || vehicleLeftShowPhoto == null) {
      Fluttertoast.showToast(
          msg: 'please select vehicle Left Photo',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (vehicleRightPhoto.isEmpty || vehicleRightShowPhoto == null) {
      Fluttertoast.showToast(
          msg: 'please select vehicle Right Photo',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (vehicleDocument.isEmpty || vehicleShowDocument == null) {
      Fluttertoast.showToast(
          msg: 'please select vehicle Document',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (_finalData.isEmpty) {
      Fluttertoast.showToast(
          msg: 'please select compartment capacity',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } else {
      // print('profileController.getSelectedValGet >>>${profileController.getSelectedValGet[0].selectedValue}');
      // print('profileController.getSelectedValGet >>>${profileController.getSelectedValGet[1].selectedValue}');
      // print(jsonEncode(_finalData));
      // return false;
      await Get.to(
          () => TransporterEditPThirdScreen(
                name: widget.name,
                email: widget.email,
                mobileNumber: widget.mobileNumber,
                vehicleNumber: widget.vehicleNumber,
                vehicleCapacity: widget.vehicleCapacity,
                numberOfCompartments: noOfCompartments.toString(),
                vehiclefrontPhoto: vehicleFrontPhoto.toString(),
                vehiclebackPhoto: vehicleBackPhoto.toString(),
                vehicleleftPhoto: vehicleLeftPhoto.toString(),
                vehiclerightPhoto: vehicleRightPhoto.toString(),
                vehicleDoc: vehicleDocument,
                compartmentDetails: jsonEncode(_finalData),
                licenseNumber: licenseNumber.toString(),
              ),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 400));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getHomeCartData();
    });
  }

  // void initState() {
  //   print('vehiclePhoto : $vehiclePhoto');
  //   FutureBuilder.
  //   gethomecartData();
  // }

  Future<void> getHomeCartData() async {
    setState(() {
      isDataLoader == true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': userToken.toString(),
    };
    http.Response response =
        await http.post(Uri.parse("${Constants.baseurl}home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      setState(() {
        isDataLoader == false;
      });
      if (result['status'] == 'success') {
        vehicleId = result['data']['vehicle_id'].toString();
        getVehicleDetails();
      }
    }
  }

  Future<void> getVehicleDetails() async {
    setState(() {
      isDataLoader == true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': userToken.toString(),
      'vehicle_id': vehicleId.toString()
    };
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}get_vehicle_detail"),
        body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      setState(() {
        isDataLoader == false;
      });
      if (kDebugMode) {
        print('is-dataLoader: $isDataLoader');
      }
      if (result['status'] == 'success') {
        if (mounted) {
          setState(() {
            vehicleFrontShowPhoto = result['data']['front_vehicle_photo_url'];
            vehicleBackShowPhoto = result['data']['back_vehicle_photo_url'];
            vehicleLeftShowPhoto = result['data']['left_vehicle_photo_url'];
            vehicleRightShowPhoto = result['data']['right_vehicle_photo_url'];
            vehicleShowDocument = result['data']['vehicle_document_url'];
            vehicleFrontPhoto = result['data']['front_vehicle_photo'];
            vehicleBackPhoto = result['data']['back_vehicle_photo'];
            vehicleLeftPhoto = result['data']['left_vehicle_photo'];
            vehicleRightPhoto = result['data']['right_vehicle_photo'];
            vehicleDocument = result['data']['vehicle_document'];
            vehicleCapacityData = result['data']['vehicle_detail'];
            numberOfCompartments = (result['data']['no_of_compartment'] == '0')
                ? '1'
                : result['data']['no_of_compartment'];
            // print("no_of_compartment:  ${result['data']['no_of_compartment']}");
            noOfCompartments = (result['data']['vehicle_detail'].length == 0)
                ? 1
                : result['data']['vehicle_detail'].length;
            licenseNumber = result['data']['license_number'];
            vehicleDetails = result['data']['vehicle_detail'];
          });
        }
        if (result['data']['vehicle_detail'] != null) {
          for (var i = 0; i < result['data']['vehicle_detail'].length; i++) {
            selectedIndex[i] =
                result['data']['vehicle_detail'][i]['compartment_capacity'];
          }
        }
        // print(vehiclePhoto);
        // print(numberOfCompartments);
        // print('vehicleDetails >> $vehicleDetails');

        // mobile = result['data']['mobile'];
        // profile_picture = result['data']['profile_pic_url'];
        // address = result['data']['address'];
        // user_type = result['data']['user_type'];
      }
    }
  }

  Future pickUploadDoc() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      picImage = XFile(pickedFile.path);
      _vehicleDocument = XFile(pickedFile.path);
      Dio d = Dio();
      dio.FormData formData = dio.FormData.fromMap({
        'front_photo': _vehicleDocument != null
            ? await dio.MultipartFile.fromFile(_vehicleDocument!.path,
                filename: 'image.jpg')
            : " ",
        'document_type': 'Vehicle Document',
        'user_token': userToken.toString(),
      });
      if (kDebugMode) {
        print(formData.fields);
      }
      var response = d
          .post("https://colormoon.in/eqwi_petrol/api/V1/upload_documents",
              data: formData)
          .then((result) {
        final jsonResponse = (result.data);
        if (jsonResponse['status'] == 'success') {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${jsonResponse['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {
            vehicleDocument = jsonResponse['data']['image'];
            vehicleShowDocument = jsonResponse['data']['image_path'];
          });
        } else {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${jsonResponse['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          vehicleDocument = '';
        }
      }).catchError((e) {
        if (kDebugMode) {
          print('catchError');
          print(e);
        }
      });
    } else {
      if (kDebugMode) {
        print("Upload Image Failed");
      }
    }
    // setState(() {
    //   isLoadingImage = false;
    // });
  }

  Future pickUploadDoc1() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);

    if (pickedFile != null) {
      picImage = XFile(pickedFile.path);
      _vehicleDocument = XFile(pickedFile.path);
      Dio d = Dio();
      dio.FormData formData = dio.FormData.fromMap({
        'front_photo': _vehicleDocument != null
            ? await dio.MultipartFile.fromFile(_vehicleDocument!.path,
                filename: 'image.jpg')
            : " ",
        'document_type': 'Vehicle Document',
        'user_token': userToken.toString(),
      });

      var response = d
          .post("https://colormoon.in/eqwi_petrol/api/V1/upload_documents",
              data: formData)
          .then((result) {
        final jsonResponse = (result.data);
        if (jsonResponse['status'] == 'success') {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${jsonResponse['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            vehicleDocument = jsonResponse['data']['image'];
            vehicleShowDocument = jsonResponse['data']['image_path'];
          });
        } else {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${jsonResponse['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          vehiclePhoto = '';
        }
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    } else {
      if (kDebugMode) {
        print("Upload Image Failed");
      }
    }
  }

  Future pickUploadPhoto(text) async {
    if (text == 'Vehicle Front View') {
      vehiclePicData = "front_photo";
    } else if (text == 'Vehicle Back View') {
      vehiclePicData = "back_photo";
    } else if (text == 'Vehicle Left View') {
      vehiclePicData = "left_photo";
    } else if (text == 'Vehicle Right View') {
      vehiclePicData = "right_photo";
    }
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      picImage = XFile(pickedFile.path);
      _vehicleDocument = XFile(pickedFile.path);
      Dio d = Dio();
      dio.FormData formData = dio.FormData.fromMap({
        'front_photo': _vehicleDocument != null
            ? await dio.MultipartFile.fromFile(_vehicleDocument!.path,
                filename: 'image.jpg')
            : " ",
        'document_type': 'Vehicle Photo',
        'user_token': userToken.toString(),
      });

      var response = d
          .post("https://colormoon.in/eqwi_petrol/api/V1/upload_documents",
              data: formData)
          .then((result) {
        final jsonResponse = (result.data);
        if (jsonResponse['status'] == 'success') {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${jsonResponse['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            if (text == 'Vehicle Front View') {
              vehicleFrontPhoto = jsonResponse['data']['image'];
              vehicleFrontShowPhoto = jsonResponse['data']['image_path'];
            } else if (text == 'Vehicle Back View') {
              vehicleBackPhoto = jsonResponse['data']['image'];
              vehicleBackShowPhoto = jsonResponse['data']['image_path'];
            } else if (text == 'Vehicle Left View') {
              vehicleLeftPhoto = jsonResponse['data']['image'];
              vehicleLeftShowPhoto = jsonResponse['data']['image_path'];
            } else if (text == 'Vehicle Right View') {
              vehicleRightPhoto = jsonResponse['data']['image'];
              vehicleRightShowPhoto = jsonResponse['data']['image_path'];
            }
          });
        } else {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${jsonResponse['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          vehiclePhoto = '';
        }
      }).catchError((e) {
        if (kDebugMode) {
          print('catchError');
          print(e);
        }
      });
    } else {
      if (kDebugMode) {
        print("Upload Image Failed");
      }
    }
    // setState(() {
    //   isLoadingImage = false;
    // });
  }

  Future pickUploadPhoto1(text) async {
    if (text == 'Vehicle Front View') {
      vehiclePicData = "front_photo";
    } else if (text == 'Vehicle Back View') {
      vehiclePicData = "back_photo";
    } else if (text == 'Vehicle Left View') {
      vehiclePicData = "left_photo";
    } else if (text == 'Vehicle Right View') {
      vehiclePicData = "right_photo";
    }
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);

    if (pickedFile != null) {
      picImage = XFile(pickedFile.path);
      _vehicleDocument = XFile(pickedFile.path);
      Dio d = Dio();
      dio.FormData formData = dio.FormData.fromMap({
        vehiclePicData.toString(): _vehicleDocument != null
            ? await dio.MultipartFile.fromFile(_vehicleDocument!.path,
                filename: 'image.jpg')
            : " ",
        'document_type': 'Vehicle Photo',
        'user_token': userToken.toString(),
      });
      if (kDebugMode) {
        print(formData);
      }
      var response = d
          .post("https://colormoon.in/eqwi_petrol/api/V1/upload_documents",
              data: formData)
          .then((result) {
        final jsonResponse = (result.data);

        if (jsonResponse['status'] == 'success') {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${jsonResponse['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            if (text == 'Vehicle Front View') {
              vehicleFrontPhoto = jsonResponse['data']['image'];
              vehicleFrontShowPhoto = jsonResponse['data']['image_path'];
            } else if (text == 'Vehicle Back View') {
              vehicleBackPhoto = jsonResponse['data']['image'];
              vehicleBackShowPhoto = jsonResponse['data']['image_path'];
            } else if (text == 'Vehicle Left View') {
              vehicleLeftPhoto = jsonResponse['data']['image'];
              vehicleLeftShowPhoto = jsonResponse['data']['image_path'];
            } else if (text == 'Vehicle Right View') {
              vehicleRightPhoto = jsonResponse['data']['image'];
              vehicleRightShowPhoto = jsonResponse['data']['image_path'];
            }
          });
        } else {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${jsonResponse['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          vehicleDocument = '';
        }
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    } else {
      if (kDebugMode) {
        print("Upload Image Failed");
      }
    }
  }

  Widget bottomSheet(context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Upload Vehicle document",
            style: TextStyle(
              fontFamily: "Mulish",
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
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
                      pickUploadDoc1();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Camera"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      pickUploadDoc();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: const [
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

  Widget bottomSheetPhoto(context, text) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Upload " + text,
            style: const TextStyle(
              fontFamily: "Mulish",
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
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
                      pickUploadPhoto1(text);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Camera"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      pickUploadPhoto(text);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: const [
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
      appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
        Get.back();
      }, title: 'Edit Profile'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CommonButton(
            onTapped: () async {
              await onSubmitFun();
              Future.delayed(
                  const Duration(seconds: 1), () => {nextButtonSubmit()});
            },
            buttonTitle: Text('NEXT',
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))),
      ),
      body: isDataLoader == true
          ? Center(
              child: CircularProgressIndicator(
                  color: AppColor.appThemeColor, strokeWidth: 3),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              physics: const BouncingScrollPhysics(),
              children: [
                Text('Vehicle Details & Capacity',
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600])),
                const SizedBox(
                  height: 25,
                  width: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Vehicle Front View',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600])),
                    Text('Vehicle Back View',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(
                  height: 5,
                  width: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    vehicleFrontShowPhoto == ''
                        ? Expanded(
                            flex: 5,
                            child: Container(
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: const Offset(
                                        2.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheetPhoto(
                                          context, 'Vehicle Front View')),
                                    );
                                  },
                                  child: const Center(
                                      child: Icon(
                                    Icons.upload_file,
                                    size: 40,
                                    color: Colors.black38,
                                  )),
                                )),
                          )
                        : Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: const Offset(
                                        2.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheetPhoto(
                                          context, 'Vehicle Front View')),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: vehicleFrontShowPhoto.toString(),
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                   const SizedBox(width: 10,height: 0,),
                    vehicleBackShowPhoto == ''
                        ? Expanded(
                            flex: 5,
                            child: Container(
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: const Offset(
                                        2.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheetPhoto(
                                          context, 'Vehicle Back View')),
                                    );
                                  },
                                  child: const Center(
                                      child: Icon(
                                    Icons.upload_file,
                                    size: 40,
                                    color: Colors.black38,
                                  )),
                                )),
                          )
                        : Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: const Offset(
                                        2.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheetPhoto(
                                          context, 'Vehicle Back View')),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: vehicleBackShowPhoto.toString(),
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                  width: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Vehicle Left View',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600])),
                    Text('Vehicle Right View',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(
                  height: 10,
                  width: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    vehicleLeftShowPhoto == ''
                        ? Expanded(
                      flex: 5,
                          child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.5),
                                    blurRadius: 10.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: const Offset(
                                      2.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheetPhoto(
                                        context, 'Vehicle Left View')),
                                  );
                                },
                                child: const Center(
                                    child: Icon(
                                  Icons.upload_file,
                                  size: 40,
                                  color: Colors.black38,
                                )),
                              )),
                        )
                        : Expanded(
                      flex: 5,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: const Offset(
                                        2.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheetPhoto(
                                          context, 'Vehicle Left View')),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: vehicleLeftShowPhoto.toString(),
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                        ),
                    const SizedBox(width: 10,height: 0,),
                    vehicleRightShowPhoto == ''
                        ? Expanded(
                      flex: 5,
                          child: Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.5),
                                    blurRadius: 10.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: const Offset(
                                      2.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheetPhoto(
                                        context, 'Vehicle Right View')),
                                  );
                                },
                                child: const Center(
                                    child: Icon(
                                  Icons.upload_file,
                                  size: 40,
                                  color: Colors.black38,
                                )),
                              )),
                        )
                        : Expanded(
                      flex: 5,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 10.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: const Offset(
                                        2.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheetPhoto(
                                          context, 'Vehicle Right View')),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: vehicleRightShowPhoto.toString(),
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                        ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
                  child: Text('Vehicle Document',
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600])),
                ),
                vehicleDocument == ''
                    ? Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.5),
                              blurRadius: 10.0, // soften the shadow
                              spreadRadius: 0.0, //extend the shadow
                              offset: const Offset(
                                2.0, // Move to right 10  horizontally
                                1.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet(context)),
                            );
                          },
                          child: const Center(
                              child: Icon(
                            Icons.upload_file,
                            size: 40,
                            color: Colors.black38,
                          )),
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 130,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                blurRadius: 10.0, // soften the shadow
                                spreadRadius: 0.0, //extend the shadow
                                offset: const Offset(
                                  2.0, // Move to right 10  horizontally
                                  1.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet(context)),
                              );
                            },
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: vehicleShowDocument.toString(),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              )),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                  width: 0,
                ),
                Text('Number Of Compartment',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500])),
                const SizedBox(
                  height: 10,
                  width: 0,
                ),
                // Text("${_selecteIndexs.toString()}"),
                // Text("${_finalData.toString()}"),
                DropdownButton<String>(
                  items: <String>['1', '2', '3', '4', '5', '6']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true,
                  value: noOfCompartments.toString(),
                  onChanged: (val) {
                    if (mounted) {
                      setState(() {
                        noOfCompartments = int.parse(val.toString());
                        selectedIndex = [
                          '1000',
                          '1000',
                          '1000',
                          '1000',
                          '1000',
                          '1000'
                        ];
                        _finalData = [];
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                  width: 0,
                ),
                ListView.builder(
                    itemCount: noOfCompartments,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      return dropdownWidget([
                        '1000',
                        '2000',
                        '3000',
                        '4000',
                        '5000',
                        '6000'
                      ], index, sv: selectedIndex[index]);
                    }),
                const SizedBox(height: 60,width: 0,),
              ],
            ),
    );
  }

  dropdownWidget(List<String> data, int index, {String? sv}) {
    String comName = '';
    if (index == 0) {
      comName = '1st Compartment Capacity';
    } else if (index == 1) {
      comName = '2nd Compartment Capacity';
    } else if (index == 2) {
      comName = '3nd Compartment Capacity';
    } else {
      comName = '${index + 1}th Compartment Capacity';
    }
    return ListView(
     physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(comName),
        const SizedBox(
          height: 5,
          width: 0,
        ),
        DropdownButton<String>(
          items: data.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          underline: const SizedBox(
            height: 0,
            width: 0,
          ),
          value: sv,
          isExpanded: true,
          selectedItemBuilder: (_) {
            return data.map<Widget>((String item) {
              return Text(item,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700));
            }).toList();
          },
          onChanged: (val) {
            if (mounted && mounted) {
              setState(() {
                //print("Selecte Vaie $val - $index");
                // noOfCompartments = int.parse(val.toString());
                selectedIndex[index] = val.toString();
              });
            }
          },
        ),

      ],
    );
  }
}
