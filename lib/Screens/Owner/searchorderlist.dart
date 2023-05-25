import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/order_summary_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SearchorderList extends StatefulWidget {
  const SearchorderList({super.key});

  @override
  State<SearchorderList> createState() => _SearchorderListState();
}

class _SearchorderListState extends State<SearchorderList> {
  String? user_token = Constants.prefs?.getString('user_token');
  List<dynamic> searchlist = [];
  bool isloading = false;
  int searchlength = 0;
  bool searching = true;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController searchcontroller = TextEditingController();
  Future<bool> onWillPop() {
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    // Get.back();
    return Future.value(false);
  }

  onSearchTextChanged(String text) async {
    print(text);
    setState(() {
      var searchkey = text;
      getSearchlist(searchkey);
      // searchResultService = [];
      // _searchResult =
      //     CategoryServices(errorCode: 'invalid', data: [], message: '');
    });

    if (text == '') {
      setState(() {
        //_searchResult = categoryList;
        //  searchResultService = services;
      });
      return;
    }
  }

  Future<void> getSearchlist(searchkey) async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'search': searchkey.toString()
    };
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "search_order"), body: bodyData);

    print(bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      print(result);
      setState(() {
        isloading = false;
      });
      if (result['status'] == 'success') {
        if (result['data'] == null ||
            result['data'] == '' ||
            result['data'].length == 0) {
        } else {
          searchlist.clear();
          print('selectedData');
          setState(() {
            searchlist = result['data'];
            searchlength = result['data'].length;
          });

          //    print(selectedData);
        }
      } else if (result['status'] == 'error') {
        searchlist.clear();
        setState(() {
          searchlength = 0;
        });
      }
      print('searchlength: $searchlength');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          backgroundColor: AppColor.appThemeColor,
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: TextField(
                  controller: searchcontroller,
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {
                            onSearchTextChanged(searchcontroller.text);
                          },
                          child: Icon(Icons.search)),
                      hintText: 'Search Orders',
                      border: InputBorder.none),
                ),
              ),
            ),
          )),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: isloading == false
            ? searchlength != 0
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: searchlist.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => orderslist(
                      searchlist[index],
                    ),
                  )
                : Center(
                    child: Container(
                      child: Column(
                        children: [
                          Image.asset('${StringConstatnts.assets}nodata.png'),
                          Text(
                            'No orders found',
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: AppColor.appThemeColor,
                ),
              ),
      ),
    );
  }

  Widget orderslist(data) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 20, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFFD4D4D4),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OrderSummaryScreen(
                  name: data['order_status'],
                  order_id: data['id'],
                ),
              ));
            },
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 11, right: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Order ID:  ',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA0A0A0)),
                          children: <InlineSpan>[
                            TextSpan(
                              text: data['order_id'],
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Color(0xFFDBDBDB),
          ),
          //   if (name == 'Pending' || accountName == 'Manager')
        ],
      ),
    );
  }
}
