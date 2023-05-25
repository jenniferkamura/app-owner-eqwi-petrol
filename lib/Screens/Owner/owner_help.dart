import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Popup/confirmation_popup.dart';
import 'package:owner_eqwi_petrol/Popup/transporter_conformation_popup.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/drawer_controller.dart';

class OwnerHelpScreen extends StatefulWidget {
  const OwnerHelpScreen({super.key});

  @override
  State<OwnerHelpScreen> createState() => _OwnerHelpScreenState();
}

class _OwnerHelpScreenState extends State<OwnerHelpScreen> {
  DrawerDataController drawerDataController = Get.put(DrawerDataController());

  String? userToken = Constants.prefs?.getString('user_token');
  bool helpTextError = false;
  String? helpvalue;
  raiseTicketFun(context) async {
    // print(drawerDataController.helpController.text);
    await drawerDataController.raiseTicketFun(
        userToken.toString(), drawerDataController.helpController.text);
    if (drawerDataController.raiseTicketFinalData.status == 'success') {
      showDialog(
          context: context,
          builder: (context) {
            return const TransporterConfirmationPopup();
          });
      drawerDataController.helpController.clear();
    } else {
      Fluttertoast.showToast(
          msg: drawerDataController.raiseTicketFinalData.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom.commonAppBarCustom(context, onTaped: () {
        Get.back();
      }, title: 'Help - Raise Ticket'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add query/ details',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF555561),
                  ),
                ),
                const SizedBox(
                  height: 10,
                  width: 0,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: drawerDataController.helpController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 18.0, color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter Something Here..',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.only(left: 10, top: 10),
                  ),
                  validator: (val) {
                    print('val: $val');
                    if (val!.isEmpty) {
                      return "Please enter your message";
                    } else {}
                  },
                ),
              ],
            ),
            CommonButton(
                buttonTitle: drawerDataController.raiseTicketLoading.value
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ))
                    : const Text('RAISE TICKET'),
                onTapped: () => raiseTicketFun(context)),
          ],
        ),
      ),
    );
  }
}
