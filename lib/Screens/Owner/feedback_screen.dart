// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:owner_eqwi_petrol/Screens/Manger/manger_tabbar_screen.dart';
import 'dart:convert' as convert;

import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';

class FeedBackScreen extends StatefulWidget {
  FeedBackScreen({Key? key}) : super(key: key);

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  List<String> feedBack = ['Awesome', 'Nice', 'Wow', 'Amazing app'];
  bool isloading = false;
  String? user_token = Constants.prefs?.getString('user_token');
  String? user_type = Constants.prefs?.getString('user_type');
  String? quick_feedback;

  double rating = 0.0;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController anySuggestionController = TextEditingController();

  Future<void> reviewSubmit() async {
    // print(rating);
    if (rating.toString() == "0.0" ||
        rating.toString() == '' ||
        rating.toString() == null) {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please provide rating",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (quick_feedback.toString() == null ||
        quick_feedback.toString() == '') {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please select quick feedback",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (formkey.currentState!.validate()) {
      //true
      setState(() {
        isloading = true;
        // ignore: avoid_print
        print(isloading);
      });
      Map<String, dynamic> bodyData = {
        'user_token': user_token.toString(),
        'description': anySuggestionController.text,
        "rating": rating.toString(),
        "quick_feedback": quick_feedback.toString(),
      };
      http.Response response = await http
          .post(Uri.parse("${Constants.baseurl}add_feedback"), body: bodyData);
      print(bodyData);

      if (response.statusCode == 200) {
        var result = convert.jsonDecode(response.body);
        // dart array
        setState(() {
          isloading = false;
          // ignore: avoid_print
          print(isloading);
        });
        print(result);
        if (result['status'] == 'success') {
          // reidrect to login Page
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TabbarScreen()));
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${result['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              // msg: jsonData['message'],
              msg: "${result['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              webBgColor: "linear-gradient(to right, #6db000 #6db000)",
              //  backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom.commonAppBarCustom(context, title: 'Feed back',
          onTaped: () {
        if (user_type == 'Owner') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => TabbarScreen()));
        } else if (user_type == 'Manager') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ManagerTabbarScreen()));
        }
      }),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 24, left: 16),
            child: Text(
              'Rate our application',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackColor),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            height: 133,
            decoration: BoxDecoration(
              color: AppColor.appThemeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'How do you rate our services',
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.whiteColor),
                ),
                SizedBox(
                  height: 29,
                ),
                RatingBar.builder(
                  itemSize: 25,
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  onRatingUpdate: (val) {
                    //print(val);
                    setState(() {
                      rating = val;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24, left: 16),
            child: Text(
              'Add review',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.blackColor),
            ),
          ),
          Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 13.0, top: 0, bottom: 15, right: 9),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: anySuggestionController,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                maxLines: 4,
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Write a review ....",
                  hintStyle: TextStyle(
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
                  if (val!.isEmpty) {
                    return "Please enter your message";
                  }
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24, left: 16),
            child: Text(
              'Use quick feedbacks',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF555561)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, top: 16),
            child: Wrap(
              spacing: 9.0,
              runSpacing: 11,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        quick_feedback = feedBack[0].toString();
                      });
                      print(quick_feedback);
                    },
                    child: Container(
                      width: 121,
                      decoration: quick_feedback == feedBack[0].toString()
                          ? BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15))
                          : BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE5E5E5),
                              ),
                              borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 6, bottom: 6, left: 15, right: 15),
                        child: Row(
                          children: [
                            Text(
                              feedBack[0],
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      quick_feedback == feedBack[0].toString()
                                          ? Colors.white
                                          : Color(0xFF555561)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Image.asset('${StringConstatnts.assets}emoji.png')
                          ],
                        ),
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        quick_feedback = feedBack[1].toString();
                      });
                      print(quick_feedback);
                    },
                    child: Container(
                      width: 91,
                      decoration: quick_feedback == feedBack[1].toString()
                          ? BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15))
                          : BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE5E5E5),
                              ),
                              borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 6, bottom: 6, left: 15, right: 15),
                        child: Row(
                          children: [
                            Text(
                              feedBack[1],
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      quick_feedback == feedBack[1].toString()
                                          ? Colors.white
                                          : Color(0xFF555561)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Image.asset('${StringConstatnts.assets}emoji.png')
                          ],
                        ),
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        quick_feedback = feedBack[2].toString();
                      });
                      print(quick_feedback);
                    },
                    child: Container(
                      width: 95,
                      decoration: quick_feedback == feedBack[2].toString()
                          ? BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15))
                          : BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE5E5E5),
                              ),
                              borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 6, bottom: 6, left: 15, right: 15),
                        child: Row(
                          children: [
                            Text(
                              feedBack[2],
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      quick_feedback == feedBack[2].toString()
                                          ? Colors.white
                                          : Color(0xFF555561)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Image.asset('${StringConstatnts.assets}emoji.png')
                          ],
                        ),
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        quick_feedback = feedBack[3].toString();
                      });
                      print(quick_feedback);
                    },
                    child: Container(
                      width: 155,
                      decoration: quick_feedback == feedBack[3].toString()
                          ? BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15))
                          : BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE5E5E5),
                              ),
                              borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 6, bottom: 6, left: 15, right: 15),
                        child: Row(
                          children: [
                            Text(
                              feedBack[3],
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      quick_feedback == feedBack[3].toString()
                                          ? Colors.white
                                          : Color(0xFF555561)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Image.asset('${StringConstatnts.assets}emoji.png')
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
              child: isloading == false
                  ? ElevatedButton(
                      onPressed: () {
                        reviewSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.blackColor,
                          fixedSize: Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48 / 2),
                          )),
                      child: Text(
                        'Submit FEEDBACK'.toUpperCase(),
                        style: TextStyle(
                            fontFamily: "ROBOTO",
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: Center(
                        child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.blackColor,
                          fixedSize: Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48 / 2),
                          )),
                    )),
        ],
      ),
    );
  }
}
