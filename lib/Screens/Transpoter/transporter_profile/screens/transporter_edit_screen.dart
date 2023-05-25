import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/commom_text_field.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/edit_profile_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transport_web_services/transport_web_services.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_profile/screens/transporter_edit_second_screen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;
import "dart:io";
import 'dart:async';

class TransporterEditProfileScreen extends StatefulWidget {
  const TransporterEditProfileScreen({Key? key}) : super(key: key);

  @override
  State<TransporterEditProfileScreen> createState() =>
      _TransporterEditProfileScreenState();
}

class _TransporterEditProfileScreenState
    extends State<TransporterEditProfileScreen> {
  EditProfileController editProfileController =
      Get.put(EditProfileController());
  String name = "";
  bool isNameError = false;
  String email = "";
  bool isEmailError = false;
  String phone = "";
  bool isPhoneError = false;
  String vehicleNumber = "";
  bool isVehicleNumberError = false;
  String vehicleCapacity = "";
  bool isVehicleCapacityError = false;
  String? profile_picture;
  String? userToken = Constants.prefs?.getString('user_token');
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());

  ///new image picker
  final picker = ImagePicker();

  XFile? profilePicXFile;
  File? profilePicFile;
  String profilePic = "";
  XFile? _profileImage;
  XFile? picimage;
  late String baseUploadImage;
  // void pickProfilePicFun(type) async {
  //   final pickedFile =
  //       await picker.pickImage(source: ImageSource.camera, imageQuality: 15);

  //   if (pickedFile != null) {
  //     if (type == "profilePic") {
  //       setState(() {
  //         profilePicXFile = XFile(pickedFile.path);
  //         profilePicFile = File(pickedFile.path);
  //       });

  //       //print("image file path ::${imageXFileIdFront!.path}");
  //       if (profilePicXFile != null) {
  //         print('userToken ${userToken.toString()}');
  //         dynamic result = await TransportWebServices()
  //             .uploadAttachmentAndFilesNewApiCall(userToken.toString(),
  //                 File(profilePicXFile!.path), 'profilePic');
  //         if (result != null) {
  //           setState(() {
  //             print('result >>> ${result['data']}');
  //             profilePicFile = result;
  //             print("image data ::$profilePicFile $profilePicXFile");
  //           });
  //         }
  //       }
  //     }
  //   }
  // }

  Future pickProfileImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      picimage = XFile(pickedFile.path);
      _profileImage = XFile(pickedFile.path);
      Dio d = Dio();
      dio.FormData formData = dio.FormData.fromMap({
        'profile_pic': _profileImage != null
            ? await dio.MultipartFile.fromFile(_profileImage!.path,
                filename: 'image.jpg')
            : " ",
        'user_token': userToken.toString(),
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
      dio.FormData formData = dio.FormData.fromMap({
        'profile_pic': _profileImage != null
            ? await dio.MultipartFile.fromFile(_profileImage!.path,
                filename: 'image.jpg')
            : " ",
        'user_token': userToken.toString(),
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
  void initState() {
    transportHomeController
        .transportHomeFun(userToken.toString(), isLoad: false)
        .then((val) {
      editProfileController.nameController.text =
          transportHomeController.transportHomeSuccessData.name.toString();
      editProfileController.emailController.text =
          transportHomeController.transportHomeSuccessData.email.toString();
      editProfileController.phoneNumberController.text =
          transportHomeController.transportHomeSuccessData.mobile.toString();
      editProfileController.vehicleNumberController.text =
          transportHomeController.transportHomeSuccessData.vehicleNumber
              .toString();
      profile_picture = transportHomeController
          .transportHomeSuccessData.profilePicUrl
          .toString();
      editProfileController.vehicleCapacityController.text =
          transportHomeController.transportHomeSuccessData.vehicleCapacity
              .toString();
    });
    super.initState();
  }

  nextButton() {
    if (editProfileController.nameController.text.isEmpty) {
      setState(() {
        isNameError = true;
      });
    } else if (editProfileController.emailController.text.isEmpty) {
      setState(() {
        isEmailError = true;
      });
    } else if (editProfileController.phoneNumberController.text.isEmpty) {
      setState(() {
        isPhoneError = true;
      });
    } else if (editProfileController.vehicleNumberController.text.isEmpty) {
      setState(() {
        isVehicleNumberError = true;
      });
    } else if (editProfileController.vehicleCapacityController.text.isEmpty) {
      setState(() {
        isVehicleCapacityError = true;
      });
    } else {
      Get.to(
          () => TransporterSecondEditScreen(
              name: editProfileController.nameController.text.toString(),
              email: editProfileController.emailController.text.toString(),
              mobileNumber:
                  editProfileController.phoneNumberController.text.toString(),
              vehicleNumber:
                  editProfileController.vehicleNumberController.text.toString(),
              vehicleCapacity: editProfileController
                  .vehicleCapacityController.text
                  .toString(),
              profileImage: transportHomeController
                  .transportHomeSuccessData.profilePic
                  .toString()),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 400));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
        Get.back();
      }, title: 'Edit Profile'),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CommonButton(
            onTapped: () {
              nextButton();
            },
            buttonTitle: Text('NEXT',
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: [
            Row(
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
                            builder: ((builder) => bottomSheet(context)),
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
                const SizedBox(
                  height: 0,
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${transportHomeController.transportHomeSuccessData.name}',
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500]),
                    ),
                    Text(
                      '${transportHomeController.transportHomeSuccessData.email}',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500]),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.star_border_outlined,
                          color: Colors.grey,
                          size: 12,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          color: Colors.grey,
                          size: 12,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          color: Colors.grey,
                          size: 12,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          color: Colors.grey,
                          size: 12,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          color: Colors.grey,
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            Text('Name',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500])),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            CommonTextFieldWidget(
                controller: editProfileController.nameController,
                maxLines: 1,
                textCapitalization: TextCapitalization.none,
                hintText: 'Name',
                isSuffixPressed: () {},
                isObscureText: false,
                typeOfRed: <TextInputFormatter>[
                  FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                  LengthLimitingTextInputFormatter(20),
                ],
                onChangeVal: (val) {
                  setState(() {
                    name = val;
                    isNameError = false;
                  });
                },
                isErrorText: isNameError,
                isErrorTextString: 'Please enter your name',
                keyboardPopType: TextInputType.text,
                filledColor: Colors.transparent,
                focusBorderColor: Colors.grey,
                outLineInputBorderColor: Colors.black54,
                enableBorderColor: Colors.black12,
                isPrefixIcon: true,
                iconData: Icons.person_outline_outlined,
                prefixColor: Colors.grey,
                prefixSize: 20),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            Text('Email Id',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500])),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            CommonTextFieldWidget(
                controller: editProfileController.emailController,
                maxLines: 1,
                textCapitalization: TextCapitalization.none,
                hintText: 'Email Id',
                isSuffixPressed: () {},
                isObscureText: false,
                typeOfRed: <TextInputFormatter>[
                  FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                  LengthLimitingTextInputFormatter(20),
                ],
                onChangeVal: (val) {
                  setState(() {
                    email = val;
                    isEmailError = false;
                  });
                },
                isErrorText: isEmailError,
                isErrorTextString: 'Please enter your email',
                keyboardPopType: TextInputType.emailAddress,
                filledColor: Colors.transparent,
                focusBorderColor: Colors.grey,
                outLineInputBorderColor: Colors.black54,
                enableBorderColor: Colors.black12,
                isPrefixIcon: true,
                iconData: Icons.email_outlined,
                prefixColor: Colors.grey,
                prefixSize: 20),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            Text('Phone Number',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500])),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            CommonTextFieldWidget(
                controller: editProfileController.phoneNumberController,
                maxLines: 1,
                textCapitalization: TextCapitalization.none,
                hintText: 'Phone Number',
                isSuffixPressed: () {},
                isObscureText: false,
                typeOfRed: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  FilteringTextInputFormatter.deny(RegExp("[a-z A-Z]")),
                  LengthLimitingTextInputFormatter(12),
                ],
                onChangeVal: (val) {
                  setState(() {
                    phone = val;
                    isPhoneError = false;
                  });
                },
                isErrorText: isPhoneError,
                isErrorTextString: 'Please enter your phone number',
                keyboardPopType: TextInputType.text,
                filledColor: Colors.transparent,
                focusBorderColor: Colors.grey,
                outLineInputBorderColor: Colors.black54,
                enableBorderColor: Colors.black12,
                isPrefixIcon: true,
                iconData: Icons.phone_android_sharp,
                prefixColor: Colors.grey,
                prefixSize: 20),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            Text('Vehicle Number',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500])),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            CommonTextFieldWidget(
                controller: editProfileController.vehicleNumberController,
                maxLines: 1,
                textCapitalization: TextCapitalization.characters,
                hintText: 'Vehicle Number',
                isSuffixPressed: () {},
                isObscureText: false,
                typeOfRed: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9A-Z]")),
                  LengthLimitingTextInputFormatter(12),
                ],
                onChangeVal: (val) {
                  setState(() {
                    vehicleNumber = val;
                    isVehicleNumberError = false;
                  });
                },
                isErrorText: isVehicleNumberError,
                isErrorTextString: 'Please enter your vehicle number',
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
              height: 10,
              width: 0,
            ),
            Text('Vehicle Capacity',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500])),
            const SizedBox(
              height: 10,
              width: 0,
            ),
            CommonTextFieldWidget(
                controller: editProfileController.vehicleCapacityController,
                maxLines: 1,
                textCapitalization: TextCapitalization.none,
                hintText: 'Vehicle Capacity',
                isSuffixPressed: () {},
                isObscureText: false,
                typeOfRed: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9 a-z A-Z]")),
                  LengthLimitingTextInputFormatter(12),
                ],
                onChangeVal: (val) {
                  setState(() {
                    vehicleCapacity = val;
                    isVehicleCapacityError = false;
                  });
                },
                isErrorText: isVehicleCapacityError,
                isErrorTextString: 'Please enter your vehicle capacity',
                keyboardPopType: TextInputType.text,
                filledColor: Colors.transparent,
                focusBorderColor: Colors.grey,
                outLineInputBorderColor: Colors.black54,
                enableBorderColor: Colors.black12,
                isPrefixIcon: true,
                iconData: Icons.fire_truck_outlined,
                prefixColor: Colors.grey,
                prefixSize: 20),
            const SizedBox(
              height: 100,
              width: 0,
            ),
          ],
        ),
      ),
    );
  }
}
