import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/drawer_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_widgets/contact_us_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class TransporterContactUsScreen extends StatelessWidget {
  TransporterContactUsScreen({super.key});

  DrawerDataController drawerDataController = Get.put(DrawerDataController());

  //final Uri _url = Uri.parse('https://flutter.dev');

  Future<void>  _launchUrl(String url) async {
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch ${Uri.parse(url)}';
    }
  }

  Future<void> _sendMail(String mailId) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: mailId,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TransAppBarCustom.commonAppBarCustom(onTaped: () {
        Navigator.pop(context);
      }, title: 'Contact Us', context),
      body:  GetX<DrawerDataController>(
        initState: (_) => DrawerDataController.to.contactUsFun(),
        builder: (ddc) =>  ddc.contactUsLoad.value? Center(child: CircularProgressIndicator(strokeWidth: 2,color: AppColor.appThemeColor,)): ContactUsWidget(
            imageUrl: '${StringConstatnts.assets}contaus.png',
            siteName: '${ddc.contactUsFinalData.contactEmail}',
            description:
            'Visit our website here',
            connectLink: '${ddc.contactUsFinalData.contactWebsiteUrl}',
            tapONLandMobile: () async {
              await launchUrl(Uri.parse(
                  'tel:${ddc.contactUsFinalData.contactLandlineNo}'));
            },
            tapONMobile: () async {
              await launchUrl(Uri.parse(
                  'tel:${ddc.contactUsFinalData.contactMobileNo}'));
            },
            onTapOnLink: () async{
              _launchUrl('${ddc.contactUsFinalData.contactWebsiteUrl}');
              //   if (await launchUrl(Uri.parse('${ddc.contactUsFinalData.contactWebsiteUrl}'))) {
              // await launchUrl(Uri.parse('${ddc.contactUsFinalData.contactWebsiteUrl}'));
              // } else {
              // throw 'Could not launch ${Uri.parse('${ddc.contactUsFinalData.contactWebsiteUrl}')}';
              // }
            },
            tapOnEmail: () {
              _sendMail(ddc.contactUsFinalData.contactEmail.toString());
             },
            connectLinkText: '${ddc.contactUsFinalData.contactEmail}',
            mobileNumber: '${ddc.contactUsFinalData.contactLandlineNo}',
            secondNumber: '${ddc.contactUsFinalData.contactMobileNo}'),
      ),
    );
  }
}
