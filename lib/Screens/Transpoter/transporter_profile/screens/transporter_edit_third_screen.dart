import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/commom_text_field.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/common_button.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/edit_profile_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TransporterEditPThirdScreen extends StatefulWidget {
  final String name;
  final String email;
  final String mobileNumber;
  final String vehicleNumber;
  final String vehicleCapacity;
  final String numberOfCompartments;
  // final String vehiclePhoto;
  final String vehiclefrontPhoto;
  final String vehiclebackPhoto;
  final String vehicleleftPhoto;
  final String vehiclerightPhoto;

  final String vehicleDoc;
  final String compartmentDetails;
  final String licenseNumber;

  const TransporterEditPThirdScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.mobileNumber,
      required this.vehicleNumber,
      required this.vehicleCapacity,
      required this.numberOfCompartments,
      required this.vehiclefrontPhoto,
      required this.vehiclebackPhoto,
      required this.vehicleleftPhoto,
      required this.vehiclerightPhoto,
      required this.vehicleDoc,
      required this.compartmentDetails,
      required this.licenseNumber})
      : super(key: key);

  @override
  State<TransporterEditPThirdScreen> createState() =>
      _TransporterEditPThirdScreenState();
}

class _TransporterEditPThirdScreenState
    extends State<TransporterEditPThirdScreen> {
  EditProfileController editProfileController =
      Get.put(EditProfileController());
  String licenseNumber = "";
  bool isLicenseNumberError = false;
  String? vehicleId;

  ///image picker
  XFile? picimage;
  final picker = ImagePicker();

  XFile? imageXFileLicense;
  File? uploadLicense;
  String licensePic = "";
  String? userToken = Constants.prefs?.getString('user_token');
  XFile? _vehiclelicence;
  String? vehicleshowlicense;
  String? vehiclelicense;

  bool isDataLoader = false;

  @override
  void initState() {
    super.initState();
    gethomecartData();

    editProfileController.licenseNumberController.text = widget.licenseNumber;
  }

  Future<void> gethomecartData() async {
    Map<String, dynamic> bodyData = {
      'user_token': userToken.toString(),
    };
    setState(() {
      isDataLoader = true;
    });
    // print(bodyData);
    http.Response response =
        await http.post(Uri.parse("${Constants.baseurl}home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // print("print is.....${result}");
      setState(() {
        isDataLoader = false;
      });
      if (result['status'] == 'success') {
        vehicleId = result['data']['vehicle_id'].toString();
        getVehicleDetails();
      }
      // print('vehicleId : $vehicleId');
    }
  }

  Future<void> getVehicleDetails() async {
    setState(() {
      isDataLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': userToken.toString(),
      'vehicle_id': vehicleId.toString()
    };

    // print(bodyData);
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}get_vehicle_detail"),
        body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // print("print is.....${result}");
      setState(() {
        isDataLoader = false;
      });
      if (result['status'] == 'success') {
        setState(() {
          licensePic = result['data']['driving_license'];
          vehicleshowlicense = result['data']['driving_license_url'];
        });
      }
    }
  }

  updateProfile() {
    // print(data);
    if (editProfileController.licenseNumberController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please Enter License Number',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } else {
      editProfileController.profileUpdateFun(
        userToken.toString(),
        widget.name,
        widget.email,
        widget.mobileNumber,
        widget.vehicleNumber,
        widget.vehicleCapacity,
        // /*widget.profileImage*/'front_6901668173340.jpg',
        // /*widget.vehiclePhoto*/'front_6901668173340.jpg',
        // /*widget.vehicleDoc*/'front_6901668173340.jpg',
        widget.compartmentDetails,
        widget.vehiclefrontPhoto,
        widget.vehiclebackPhoto,
        widget.vehicleleftPhoto,
        widget.vehiclerightPhoto,
        widget.vehicleDoc,
        widget.numberOfCompartments,
        editProfileController.licenseNumberController.text,
        licensePic.toString(),
        vehicleId.toString(),
      );
    }
  }

  Future pickUploadLicence() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      picimage = XFile(pickedFile.path);
      _vehiclelicence = XFile(pickedFile.path);
      Dio d = Dio();
      dio.FormData formData = dio.FormData.fromMap({
        'front_photo': _vehiclelicence != null
            ? await dio.MultipartFile.fromFile(_vehiclelicence!.path,
                filename: 'image.jpg')
            : " ",
        'document_type': 'Driving License',
        'user_token': userToken.toString(),
      });
      print(formData.fields);
      var response = d
          .post("https://colormoon.in/eqwi_petrol/api/V1/upload_documents",
              data: formData)
          .then((result) {
        final jsonResponse = (result.data);
        print("respons${result}");
        if (jsonResponse['status'] == 'success') {
          print(jsonResponse['data']);
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
            licensePic = jsonResponse['data']['image'];
            vehicleshowlicense = jsonResponse['data']['image_path'];
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
          licensePic = '';
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

  Future pickUploadLicence1() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);

    if (pickedFile != null) {
      picimage = XFile(pickedFile.path);
      _vehiclelicence = XFile(pickedFile.path);
      Dio d = Dio();
      dio.FormData formData = dio.FormData.fromMap({
        'front_photo': _vehiclelicence != null
            ? await dio.MultipartFile.fromFile(_vehiclelicence!.path,
                filename: 'image.jpg')
            : " ",
        'document_type': 'Driving License',
        'user_token': userToken.toString(),
      });
      print(formData);
      var response = d
          .post("https://colormoon.in/eqwi_petrol/api/V1/upload_documents",
              data: formData)
          .then((result) {
        final jsonResponse = (result.data);
        print("respons${result}");
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
          print(jsonResponse['data']);
          setState(() {
            licensePic = jsonResponse['data']['image'];
            vehicleshowlicense = jsonResponse['data']['image_path'];
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
          licensePic = '';
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
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Upload License",
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
                      pickUploadLicence1();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Icon(Icons.camera),
                        const SizedBox(
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
                      pickUploadLicence();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Icon(Icons.image),
                        const SizedBox(
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
              await updateProfile();
            },
            buttonTitle: Text('UPDATE',
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))),
      ),
      body: isDataLoader == false
          ? ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                Text('Driving License & Details',
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600])),
                const SizedBox(
                  height: 20,
                  width: 0,
                ),
                Text('License Number',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500])),
                const SizedBox(
                  height: 10,
                  width: 0,
                ),
                CommonTextFieldWidget(
                    controller: editProfileController.licenseNumberController,
                    maxLines: 1,
                    textCapitalization: TextCapitalization.none,
                    hintText: 'License Number',
                    isSuffixPressed: () {},
                    isObscureText: false,
                    typeOfRed: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp("[0-9 a-z A-Z]")),
                      LengthLimitingTextInputFormatter(20),
                    ],
                    onChangeVal: (val) {
                      setState(() {
                        licenseNumber = val;
                        isLicenseNumberError = false;
                      });
                    },
                    isErrorText: isLicenseNumberError,
                    isErrorTextString: 'Please enter your license number',
                    keyboardPopType: TextInputType.text,
                    filledColor: Colors.transparent,
                    focusBorderColor: Colors.grey,
                    outLineInputBorderColor: Colors.black54,
                    enableBorderColor: Colors.black12,
                    isPrefixIcon: true,
                    iconData: Icons.confirmation_number_outlined,
                    prefixColor: Colors.grey,
                    prefixSize: 20),
                const SizedBox(
                  height: 20,
                  width: 0,
                ),
                Text('Upload License Document',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500])),
                const SizedBox(
                  height: 10,
                  width: 0,
                ),
                licensePic == ''
                    ? Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Icon(Icons.upload_file),
                              const SizedBox(height: 10),
                              const Text(
                                'Upload Vehicle License',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ))
                    : Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
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
                            imageUrl: vehicleshowlicense.toString(),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            )),
                          ),
                        ),
                      ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                  color: AppColor.appThemeColor, strokeWidth: 3),
            ),
    );
  }
}
