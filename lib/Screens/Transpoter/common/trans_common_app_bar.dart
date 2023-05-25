import 'package:flutter/material.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';


class TransAppBarCustom {
  static AppBar commonAppBarCustom(context, {title,required VoidCallback onTaped}){
    return AppBar(
     // leadingWidth: 50,
      titleSpacing:1,
      backgroundColor: AppColor.appThemeColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title!,
        style: CustomTextWhiteStyle.textStyleWhite(context,18,FontWeight.w600),
      ),
      leading: IconButton(onPressed: onTaped, icon: const Icon(
        Icons.arrow_back_ios,
        size: 18,
        color: Colors.white,
      )),
    );
  }
}