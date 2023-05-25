import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_profile/screens/transporter_edit_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_screen.dart';

class TransporterProfileScreen extends StatefulWidget {
  const TransporterProfileScreen({Key? key}) : super(key: key);

  @override
  State<TransporterProfileScreen> createState() =>
      _TransporterProfileScreenState();
}

class _TransporterProfileScreenState extends State<TransporterProfileScreen> {
  String? userToken = Constants.prefs?.getString('user_token');
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());

  @override
  Future<bool> onWillPop() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => TransporterHomeScreen()));
    //Get.back();
    return Future.value(false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          // leadingWidth: 50,
          titleSpacing: 1,
          backgroundColor: AppColor.appThemeColor,
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: CustomTextWhiteStyle.textStyleWhite(
                context, 18, FontWeight.w600),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.white,
              )),
          actions: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 17,
              ),
              onPressed: () {
                Get.to(() => const TransporterEditProfileScreen());
              },
              label: Text(
                "Edit",
                style: CustomTextWhiteStyle.textStyleWhite(
                    context, 14, FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                fixedSize: const Size(100, 43),
              ),
            ),
          ],
        ),
        body: GetX<TransportHomeController>(
          initState: (_) => TransportHomeController.to
              .initStateHomeData(userToken!.toString()),
          builder: (thc) => thc.isHomeLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.appThemeColor,
                  ),
                )
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 40,
                          backgroundImage: NetworkImage(thc
                              .transportHomeSuccessData.profilePicUrl
                              .toString()),
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
                              '${thc.transportHomeSuccessData.name}',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500]),
                            ),
                            Text(
                              '${thc.transportHomeSuccessData.userType}',
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
                      height: 20,
                      width: 0,
                    ),
                    Text('Name',
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500])),
                    const SizedBox(
                      height: 3,
                      width: 0,
                    ),
                    Text('${thc.transportHomeSuccessData.name}',
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    const SizedBox(
                      height: 20,
                      width: 0,
                    ),
                    Text('Email Id',
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500])),
                    const SizedBox(
                      height: 3,
                      width: 0,
                    ),
                    Text('${thc.transportHomeSuccessData.email}',
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    const SizedBox(
                      height: 20,
                      width: 0,
                    ),
                    Text('Phone Number',
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500])),
                    const SizedBox(
                      height: 3,
                      width: 0,
                    ),
                    Text('${thc.transportHomeSuccessData.mobile}',
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    const SizedBox(
                      height: 20,
                      width: 0,
                    ),
                    Divider(color: Colors.grey[500], thickness: 2),
                    const SizedBox(
                      height: 20,
                      width: 0,
                    ),
                    Text('Vehicle Details & Capacity',
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500])),
                    const SizedBox(
                      height: 20,
                      width: 0,
                    ),
                    Text('Vehicle Number',
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500])),
                    const SizedBox(
                      height: 3,
                      width: 0,
                    ),
                    Text('${thc.transportHomeSuccessData.vehicleNumber}',
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    const SizedBox(
                      height: 20,
                      width: 0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColor.appThemeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Vehicle Capacity',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          Text(
                              '${thc.transportHomeSuccessData.vehicleCapacity} ltr',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
