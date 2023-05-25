import 'package:flutter/material.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';


class AppBarCustom {
  static AppBar commonAppBarCustom(context, {title,required VoidCallback onTaped}){
    return AppBar(
      leadingWidth: 50,
      backgroundColor: AppColor.appThemeColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title!,
        style: CustomTextWhiteStyle.textStyleWhite(context,18,FontWeight.w600),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MaterialButton(
          onPressed: onTaped,
          color: Colors.white,
          textColor: Colors.white,
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}