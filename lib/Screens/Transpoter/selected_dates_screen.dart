import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/common/trans_common_app_bar.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/notification_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_screen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectedDatesScreen extends StatefulWidget {
  const SelectedDatesScreen({Key? key}) : super(key: key);

  @override
  State<SelectedDatesScreen> createState() => _SelectedDatesScreenState();
}

class _SelectedDatesScreenState extends State<SelectedDatesScreen> {
  NotificationController notificationController =
      Get.put(NotificationController());
       TransportHomeController transportHomeController =
      Get.put(TransportHomeController());

  String? userToken = Constants.prefs?.getString('user_token');

  List dateListData = [];
  List selectedData = [];

  void deleteDatesTap(String id) async {
    await notificationController.deleteDatesFun(userToken.toString(), id);
    if (notificationController.deleteDatesFinalData.status == 'success') {
      notificationController.getAddsFun(userToken.toString());
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    notificationController.getAddsFun(userToken.toString());
    super.didChangeDependencies();
  }

   Future<bool> _willPopCallback() async {

    await transportHomeController.transportPickUpOrdersFun(
        userToken.toString(), 'Pending',
        isLoad: true);
    await transportHomeController.transportCurrentOrdersFun(
        userToken.toString(), 'Accept',
        isLoad: true);
    await transportHomeController.transportHomeFun(userToken.toString());
    // await showDialog or Show add banners or whatever
    // then
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.appThemeColor,
          title: Text('Not Available Dates',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          leading: IconButton(
              onPressed: () {
                Get.to(() => TransporterHomeScreen(),
                    duration: const Duration(milliseconds: 400),
                    transition: Transition.leftToRight);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.white,
              )),
          // actions: [
          //   IconButton(onPressed: (){
          //     showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //             scrollable: true,
          //             title: const Text('Leaves'),
          //             content: SfDateRangePicker(
          //               // onSelectionChanged: _onSelectionChanged,
          //               toggleDaySelection: true,
          //               view: DateRangePickerView.month,
          //               selectionMode: DateRangePickerSelectionMode.multiple,
          //               showActionButtons: true,
          //               enablePastDates: false,
          //               todayHighlightColor:AppColor.appThemeColor,
          //               onSubmit: (Object? val) async {
          //                 Navigator.pop(context);
          //                 // upDateDates(selectedData);
          //               },
          //               selectionColor: AppColor.appThemeColor,
          //               onCancel: (){
          //                 Navigator.pop(context);
          //               },
          //               // initialSelectedDate:DateTime(now.year, now.month, now.day),
          //               minDate:DateTime.now().add(const Duration(days: 1)),
          //               // monthViewSettings: DateRangePickerMonthViewSettings(),
          //               // initialSelectedRange: PickerDateRange(
          //               //     DateTime.now().subtract(const Duration(days: 4)),
          //               //     DateTime.now().add(const Duration(days: 3))),
          //             ),
          //           );
          //         });
          //
          //   }, icon: const Icon(Icons.edit,color: Colors.white,size: 20,))
          // ],
        ),
        // appBar: TransAppBarCustom.commonAppBarCustom(context, onTaped: () {
        //   Get.offAll(() => TranspoterHomeScreen(),
        //       duration: const Duration(milliseconds: 400),
        //       transition: Transition.leftToRight);
        // }, title: 'PickUp Order Details'),
        body: GetX<NotificationController>(
          initState: (_) =>
              NotificationController.to.getAddsFun(userToken.toString()),
          builder: (thc) => notificationController.isDatesLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColor.appThemeColor,
                  strokeWidth: 2,
                ))
              : thc.addsFinalData.result!.isEmpty
                  ?  Center(child: Text('No Data Founded',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackColor)))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: thc.addsFinalData.result?.length,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      clipBehavior: Clip.hardEdge,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Card(
                            color: Colors.grey[300],
                            elevation: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                      'Not Available Dates: ${thc.addsFinalData.result?[index].setDate.toString().substring(0, 10)}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.blackColor)),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              scrollable: true,
                                              title: const Text(
                                                  'Are You Sure? you want to delete this date?'),
                                              content: Row(
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('No')),
                                                  TextButton(
                                                      onPressed: () {
                                                        deleteDatesTap(
                                                            '${thc.addsFinalData.result?[index].id.toString()}');
                                                      },
                                                      child: notificationController
                                                              .isDatesDeleteLoad
                                                              .value
                                                          ? const CircularProgressIndicator()
                                                          : const Text('Yes')),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      size: 20,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
        ),
      ),
    );
  }
}
