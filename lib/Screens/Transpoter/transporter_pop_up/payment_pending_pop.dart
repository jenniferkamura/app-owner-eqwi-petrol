import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';

class PaymentPendingPopUp extends StatefulWidget {
 final String currency,amount,orderId,assignOrderId;
  const PaymentPendingPopUp({Key? key,required this.currency,required this.amount, required this.orderId, required this.assignOrderId}) : super(key: key);

  @override
  State<PaymentPendingPopUp> createState() => _PaymentPendingPopUpState();
}

class _PaymentPendingPopUpState extends State<PaymentPendingPopUp> {

  String? userToken = Constants.prefs?.getString('user_token');

  TransportHomeController transportHomeController =
  Get.put(TransportHomeController());

  refreshPay() async {
    await transportHomeController.deliveryActionFun(
        userToken!,
        widget.orderId,
        widget.assignOrderId,
        'Delivered',
        '',
        '',
        '',
        '',
        '');
    if(transportHomeController.finalDeliveryData.paymentPending == 1){
      Fluttertoast.showToast(
          msg: 'Payment not done!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 12.0);
    }else{
      Fluttertoast.showToast(
          msg: 'Payment Done Successfully Now You Can Deliver!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 12.0);
      Get.back();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body:  SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      '${StringConstatnts.assets}Transpoter/pay.png',
                      height: 200,
                      width: 150,
                    ),
                    const SizedBox(height: 5,width: 0,),
                    Text('Please pay the balance amount',style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500])),
                    Text('${widget.currency}${widget.amount} to Complete the Order',style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900])),
                    const SizedBox(height: 5,width: 0,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            child: ElevatedButton(onPressed: (){
                              Get.back();
                            }, style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                                textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)), child: const Text('Cancel'),),
                          ),
                          const SizedBox(width: 20,height: 0,),
                          SizedBox(
                            height: 35,
                            child: Obx(()=>
                               ElevatedButton(onPressed:  transportHomeController
                                   .isDeliveryActionLoad.value?(){}:()=> refreshPay(), style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)), child: transportHomeController
                                   .isDeliveryActionLoad.value? const SizedBox(height:10,width:10,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)): const  Text('Refresh'),),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
