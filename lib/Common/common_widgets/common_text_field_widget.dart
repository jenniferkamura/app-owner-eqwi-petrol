import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';

class CommonTextFieldAuthentication extends StatelessWidget {
  final TextInputType keyboardPopType;
  final TextEditingController controller;
  final int maxLines;
  final String hintText;
  final List<TextInputFormatter>? typeOfRed;
  final ValueChanged onChangeVal;
  final bool isErrorText;
  final Color? filledColor;
  final Color focusBorderColor;
  final String isErrorTextString;
  final bool readOnlytext;
  final TextCapitalization textCapitalization;

  const CommonTextFieldAuthentication(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.typeOfRed,
      required this.onChangeVal,
      required this.isErrorText,
      required this.isErrorTextString,
      required this.keyboardPopType,
      required this.filledColor,
      required this.focusBorderColor,
      required this.textCapitalization,
      required this.readOnlytext,
      required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardPopType,
      controller: controller,
      autofocus: false,
      readOnly: readOnlytext,
      textCapitalization: textCapitalization,
      cursorColor: Colors.grey,
      maxLines: maxLines,
      inputFormatters: typeOfRed,
      style: GoogleFonts.roboto(
          textStyle: Theme.of(context).textTheme.displayMedium,
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400),
      cursorWidth: 1,
      decoration: InputDecoration(
        fillColor: filledColor,
        hintText: hintText,
        errorText: isErrorText ? isErrorTextString : null,
        hintStyle: GoogleFonts.roboto(
            textStyle: Theme.of(context).textTheme.displayMedium,
            color: AppColor.fieldHintColor,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        filled: true,
        focusColor: Colors.white,
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF6D6D6D), width: 1),
            borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.only(left: 20, top: 20),
      ),
      onChanged: onChangeVal,
    );
  }
}

///white text
class CustomTextWhiteStyle {
  static TextStyle textStyleWhite(
      BuildContext context, double size, FontWeight fontWeight) {
    return GoogleFonts.roboto(
        fontStyle: FontStyle.normal,
        color: Colors.white,
        fontSize: size,
        fontWeight: fontWeight);
  }
}

class CommonTextFieldTitle extends StatelessWidget {
  final String title;
  const CommonTextFieldTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor),
        ),
        Image.asset(
          '${StringConstatnts.assets}star.png',
          height: 8,
        )
      ],
    );
  }
}

class CommonIconButton extends StatelessWidget {
  final Color buttonColor, textColorData;
  final String buttonText;
  final IconData iconDataD;
  final VoidCallback tapIconButton;

  const CommonIconButton(
      {Key? key,
      required this.buttonColor,
      required this.buttonText,
      required this.iconDataD,
      required this.tapIconButton,
      required this.textColorData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: tapIconButton,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: buttonColor,
      ),
      icon: Icon(
        iconDataD,
        size: 18.0,
      ),
      label: Text(buttonText,
          style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: textColorData)), // <-- Text
    );
  }
}

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key, required this.buttonTitle, required this.onTapped});
  final Widget buttonTitle;
  final void Function()? onTapped;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, minimumSize: const Size(450, 50)),
        onPressed: onTapped,
        child: buttonTitle);
  }
}
