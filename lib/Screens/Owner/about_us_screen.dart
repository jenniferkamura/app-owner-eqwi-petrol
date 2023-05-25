// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
//import 'package:flutter_html/flutter_html.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool isloader = false;
  String? aboutdata;

  @override
  void initState() {
    super.initState();
    getAboutus();
  }

  Future<void> getAboutus() async {
    Map<String, dynamic> bodyData = {
      'cms_page': 'about_body',
    };
    setState(() {
      isloader = true;
    });
    print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "cms_pages"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      //print("print is.....${result}");
      setState(() {
        isloader = false;
      });
      if (result['status'] == 'success') {
        aboutdata = result['data'];
      }
      print(aboutdata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom.commonAppBarCustom(context, title: 'About Us',
          onTaped: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TabbarScreen()));
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  '${StringConstatnts.assets}abou.png',
                  height: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
                child: Text(
                  '$aboutdata',
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3D3E41)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
