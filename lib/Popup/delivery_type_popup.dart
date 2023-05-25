// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Global/Global.dart';
import 'package:owner_eqwi_petrol/Screens/Manger/manager_cart_order_raise_sucessfully_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/check_out_screen.dart';
import 'package:date_time_picker/date_time_picker.dart';

class DeliveryTypePopup extends StatefulWidget {
  String? name;
  String? cart_ids;
  String? selectStationId;
  String? coupon_code;

  DeliveryTypePopup(
      {Key? key, this.name, this.selectStationId, this.coupon_code})
      : super(key: key);

  @override
  State<DeliveryTypePopup> createState() => _DeliveryTypePopupState();
}

class _DeliveryTypePopupState extends State<DeliveryTypePopup> {
  String? delivery_type = 'delivery now';
  bool isloading = false;
  GlobalKey<FormState> formkey = GlobalKey();
  DateTime dateTime = DateTime.now();
  TextEditingController dateController = TextEditingController();
  String date = "";
  bool isDateError = false;
  TextEditingController timeController = TextEditingController();
  String time = "";
  bool isTimeError = false;
  late DateTime select_date;
  String? selectDate;
  final now = DateTime.now();
  String? user_type = Constants.prefs?.getString('user_type');

  @override
  void initState() {
    print(widget.cart_ids);
    print(widget.selectStationId);
    print(widget.coupon_code);
    getTodaydate();
  }

  getTodaydate() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var displayDate = DateFormat('dd-MM-yyyy');
    String todaydate = formatter.format(now);
    selectDate = todaydate;

    //  print(todaydate); // 2016-01-25
  }

  goToPayment() {
    if (delivery_type == null || delivery_type == '') {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please select delivery type",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (delivery_type == 'schedule delivery') {
      print('timeController.text');
      print(timeController.text);
      if (dateController.text == '' || dateController.text == null) {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: "Please select delivery date",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            webBgColor: "linear-gradient(to right, #6db000 #6db000)",
            //  backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (timeController.text == '' || timeController.text == null) {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: "Please select delivery time",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            webBgColor: "linear-gradient(to right, #6db000 #6db000)",
            //  backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CheckOutScreen(
                    cart_ids: widget.cart_ids,
                    delivery_type: '1',
                    delivery_date: dateController.text,
                    delivery_time: timeController.text,
                    station_id: widget.selectStationId,
                    coupon_code: widget.coupon_code)));
      }
    } else if (delivery_type == 'delivery now') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CheckOutScreen(
                  cart_ids: widget.cart_ids,
                  delivery_date: selectDate,
                  delivery_type: '0',
                  delivery_time: '',
                  station_id: widget.selectStationId,
                  coupon_code: widget.coupon_code)));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 307,
          margin: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF89A619),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'Delivery type',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.whiteColor),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          '${StringConstatnts.assets}wrong.png',
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 11,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 21, right: 19),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            delivery_type = "schedule delivery";
                          });
                        },
                        child: Row(
                          children: [
                            delivery_type == "schedule delivery"
                                ? Image.asset(
                                    '${StringConstatnts.assets}select.png',
                                    height: 15,
                                  )
                                : Image.asset(
                                    '${StringConstatnts.assets}unchecked.png',
                                    height: 15,
                                  ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Schedule delivery',
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF797979)),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Select Delivery Date',
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF848484)),
                                      ),
                                      Image.asset(
                                        '${StringConstatnts.assets}star.png',
                                        height: 8,
                                        color: Colors.transparent,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  SizedBox(
                                    height: 48,
                                    child: DateTimePicker(
                                      controller: dateController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintText: 'Select Date',
                                        suffixIcon: Icon(
                                          Icons.calendar_today_outlined,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                      ),
                                      type: DateTimePickerType.date,
                                      dateMask: 'yyyy-MM-dd',
                                      initialDate: DateTime(
                                          now.year, now.month, now.day + 1),
                                      firstDate: DateTime(
                                          now.year, now.month, now.day + 1),
                                      // initialDate: DateTime.now(),
                                      // firstDate: DateTime.now()
                                      //     .subtract(Duration(days: 0)),
                                      lastDate: DateTime(2100),
                                      selectableDayPredicate: (date) {
                                        return true;
                                      },
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please select date';
                                        }

                                        // return null;
                                      },
                                      onChanged: (val) {
                                        print('val:$val');
                                        setState(() {
                                          timeController.text = '';
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(
                              top: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Select Delivery Time',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF848484)),
                                    ),
                                    Image.asset(
                                      '${StringConstatnts.assets}star.png',
                                      height: 8,
                                      color: Colors.transparent,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                SizedBox(
                                  height: 48,
                                  child: Center(
                                      child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              timeController, //editing controller of this TextField
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            hintText: 'Select Time',
                                            suffixIcon: Icon(
                                              Icons.access_time_rounded,
                                              color: Colors.grey,
                                              size: 16,
                                            ),
                                          ),
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return 'Please select time';
                                            } // return null;
                                          },
                                          readOnly: true,
                                          onTap: () async {
                                            if (dateController.text == '') {
                                              Fluttertoast.showToast(
                                                  msg: "Please select date !",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  webBgColor:
                                                      "linear-gradient(to right, #6db000 #6db000)",
                                                  //  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                                builder: (context, child) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            alwaysUse24HourFormat:
                                                                false),
                                                    child: child ?? Container(),
                                                  );
                                                },
                                              );
                                              if (pickedTime != null) {
                                                late DateTime now;
                                                late DateTime restrict_time;
                                                // print(
                                                //     MediaQuery.of(context).alwaysUse24HourFormat);
                                                if (MediaQuery.of(context)
                                                    .alwaysUse24HourFormat) {
                                                  restrict_time = DateFormat(
                                                          "hh:mm")
                                                      // ignore: use_build_context_synchronously
                                                      .parse(TimeOfDay
                                                              .fromDateTime(
                                                                  DateTime
                                                                      .now())
                                                          .format(context)
                                                          .toString());
                                                  print(restrict_time);
                                                  now = DateFormat("hh:mm")
                                                      .parse(pickedTime
                                                          .format(context)
                                                          .toString());
                                                  //24h format
                                                } else {
                                                  restrict_time = DateFormat(
                                                          "hh:mm a")
                                                      // ignore: use_build_context_synchronously
                                                      .parse(TimeOfDay
                                                              .fromDateTime(
                                                                  DateTime
                                                                      .now())
                                                          .format(context)
                                                          .toString());
                                                  // print(restrict_time);
                                                  now = DateFormat("hh:mm a")
                                                      .parse(pickedTime
                                                          .format(context)
                                                          .toString());
                                                  //12h format
                                                }

                                                var formatter =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(DateTime.now());
                                                String formattedTime =
                                                    DateFormat('HH:mm')
                                                        .format(now);
                                                setState(() {
                                                  select_date = DateTime.parse(
                                                      formatter +
                                                          ' ' +
                                                          formattedTime);
                                                });

                                                String restrict_date_time =
                                                    DateFormat('HH:mm')
                                                        .format(restrict_time);

                                                DateTime restrict_final_time =
                                                    DateTime.parse(formatter +
                                                        ' ' +
                                                        restrict_date_time);

                                                if (DateFormat('yyyy-MM-dd')
                                                        .format(
                                                            DateTime.now()) ==
                                                    dateController.text) {
                                                  if (select_date
                                                          .millisecondsSinceEpoch <
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch) {
                                                    setState(() {
                                                      timeController.text = '';
                                                    });
                                                    // ignore: use_build_context_synchronously
                                                    Constants.snackBar(context,
                                                        "Please select valid time");
                                                  } else {
                                                    if (select_date
                                                            .millisecondsSinceEpoch >
                                                        restrict_final_time
                                                            .millisecondsSinceEpoch) {
                                                      setState(() {
                                                        timeController.text =
                                                            pickedTime.format(
                                                                context);
                                                        print('Hari');
                                                      });
                                                    } else {
                                                      setState(() {
                                                        timeController.text =
                                                            '';
                                                        print('rubi');
                                                      });
                                                      Constants.snackBar(
                                                          context,
                                                          "Please select valid time");
                                                    }
                                                  }
                                                } else {
                                                  setState(() {
                                                    timeController.text =
                                                        pickedTime
                                                            .format(context);
                                                    //set the value of text field.
                                                  });
                                                }
                                              } else {
                                                print("Time is not selected");
                                              }
                                            }
                                          } //set it true, so that user will not able to edit text
                                          )),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  height: 1,
                  color: Color(0xFF89A619).withOpacity(0.29),
                ),
                Container(
                  margin: EdgeInsets.only(left: 21, right: 19, top: 16),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        delivery_type = "delivery now";
                      });
                    },
                    child: Row(
                      children: [
                        delivery_type == "delivery now"
                            ? Image.asset(
                                '${StringConstatnts.assets}select.png',
                                height: 15,
                              )
                            : Image.asset(
                                '${StringConstatnts.assets}unchecked.png',
                                height: 15,
                              ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Deliver Now',
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.blackColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  height: 1,
                  color: Color(0xFF89A619).withOpacity(0.29),
                ),
                Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: isloading == false
                        ? ElevatedButton(
                            onPressed: () {
                              goToPayment();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.blackColor,
                                fixedSize: Size(300, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48 / 2),
                                )),
                            child: Text(
                              'continue'.toUpperCase(),
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
                                  borderRadius: BorderRadius.circular(48 / 2),
                                )),
                            child: Center(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 3),
                              ),
                            ),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


      // onTap: () async {
      //                                 if (dateController.text == '') {
      //                                   Fluttertoast.showToast(
      //                                       msg: "Please select date !",
      //                                       toastLength: Toast.LENGTH_SHORT,
      //                                       gravity: ToastGravity.TOP,
      //                                       timeInSecForIosWeb: 1,
      //                                       webBgColor:
      //                                           "linear-gradient(to right, #6db000 #6db000)",
      //                                       //  backgroundColor: Colors.red,
      //                                       textColor: Colors.white,
      //                                       fontSize: 16.0);
      //                                 } else {
      //                                   TimeOfDay? pickedTime =
      //                                       await showTimePicker(
      //                                     initialTime: TimeOfDay.now(),
      //                                     context: context,
      //                                     builder: (context, child) {
      //                                       return MediaQuery(
      //                                         data: MediaQuery.of(context)
      //                                             .copyWith(
      //                                                 alwaysUse24HourFormat:
      //                                                     false),
      //                                         child: child ?? Container(),
      //                                       );
      //                                     },
      //                                   );
      //                                   if (pickedTime != null) {
      //                                     print(
      //                                         '${pickedTime.format(context)}');
      //                                     print(TimeOfDay.fromDateTime(
      //                                             DateTime.now().add(
      //                                                 Duration(minutes: 30)))
      //                                         .format(context));
      //                                     DateTime restrict_time =
      //                                         DateFormat("hh:mm").parse(
      //                                             TimeOfDay.fromDateTime(
      //                                                     DateTime.now().add(
      //                                                         Duration(
      //                                                             minutes: 30)))
      //                                                 .format(context)
      //                                                 .toString());
      //                                     DateTime now = DateFormat("hh:mm a")
      //                                         .parse(pickedTime
      //                                             .format(context)
      //                                             .toString());

      //                                     var formatter =
      //                                         DateFormat('yyyy-MM-dd')
      //                                             .format(DateTime.now());
      //                                     String formattedTime =
      //                                         DateFormat('HH:mm').format(now);
      //                                     print('formattedTime');
      //                                     print(formattedTime);
      //                                     setState(() {
      //                                       timeController.text = formattedTime;
      //                                     });
      //                                   } else {
      //                                     print("Time is not selected");
      //                                   }
      //                                 }
      //                               }, 