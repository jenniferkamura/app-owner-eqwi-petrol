import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';

class AddFuelBSheetWidget extends StatelessWidget {
  final Widget widget;
  final  void Function()? onPressed;
  final  void Function()? onPressedBack;
  final bool isLoad;
  const AddFuelBSheetWidget({Key? key,  this.onPressed, required this.widget, this.onPressedBack, required this.isLoad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Compartments',
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              IconButton(
                  onPressed: onPressedBack,
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 30,
                  )),
            ],
          ),
        ),
        widget,
        ElevatedButton(
          onPressed: isLoad?(){}:onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.appThemeColor,
              padding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              textStyle: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold)),
          child: Text(isLoad?'Loading..':'Submit',style: GoogleFonts.roboto(
              fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white
          ),),
        ),
        const SizedBox(
          height: 10,
          width: 0,
        ),
      ],
    );
  }
}
