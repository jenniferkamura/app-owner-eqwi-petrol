import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_wallet_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/paymentcancel.dart';
import '../../Common/app_color.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../../Common/common_app_bar.dart';
import '../../Common/constants.dart';

class AmountwalletWabview extends StatefulWidget {
  String? payment_url;
  final String? paymentId;
  AmountwalletWabview({Key? key, this.payment_url, this.paymentId})
      : super(key: key);

  @override
  State<AmountwalletWabview> createState() => _AmountwalletWabviewState();
}

class _AmountwalletWabviewState extends State<AmountwalletWabview> {
  String url = '';
  double progress = 0;
  bool isdddLoading = false;
  bool isLoading = true;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // print('payment url');
    print(widget.payment_url);
    print(widget.paymentId);
    checkPaymentStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey webViewKey = GlobalKey();

  Future<void> checkPaymentStatus() async {
    // ignore: prefer_interpolation_to_compose_strings
    String link =
        "https://colormoon.in/eqwi_petrol/payment/check_status/${widget.paymentId}";
    //  print('link');
    //  print(link);
    http.Response response = await http.post(Uri.parse(link));
    if (response.statusCode == 200) {
      //   body = convert.jsonDecode(response.body);
      var result = convert.jsonDecode(response.body); // dart array

      if (result['status'] == 'Pending') {
        //  print('lodedddd');
        checkPaymentStatus();
      } else if (result['status'] == 'Completed') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddWalletScreen()));
      } else if (result['status'] == 'Cancelled') {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
            msg: "Payment Cancelled",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            webBgColor: "linear-gradient(to right, #6db000 #6db000)",
            //  backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddWalletScreen()));
      }
    }
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const AddWalletScreen()));
    // Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        // backgroundColor: AppColor.appThemeColor,
        appBar: AppBarCustom.commonAppBarCustom(context, title: 'Jambo Pay',
            onTaped: () {
          Navigator.pop(context);
        }),
        body: Stack(
          children: <Widget>[
            WebView(
              // initialUrl: 'https://colormoon.in/eqwi_petrol/payment/pay/22826227ZHD0',
              initialUrl: widget.payment_url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                //  print('Web view created....');
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                print('WebView is loading (progress : $progress)');
                if (progress == 100) {
                  setState(() {
                    isLoading = false;
                  });
                }
                // if (progress == 100) {
                //   print('doneedsfdf');
                //   setState(() {
                //     isdddLoading = false;
                //   });
                // }
                // showWebData(progress);
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              // onPageFinished: (String url) {
              //   print
              //('Page finished loading: $url');
              // },

              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
            Visibility(
                visible: isLoading,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColor.appThemeColor, strokeWidth: 3),
                    ),
                  ),
                ))
          ],
        ),
        // floatingActionButton: favoriteButton(),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
