import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTextFieldWidget extends StatelessWidget {
  final TextInputType keyboardPopType;
  final TextEditingController controller;
  final int maxLines;
  final String hintText;
  final bool isObscureText;
  final VoidCallback isSuffixPressed;
  final List<TextInputFormatter>? typeOfRed;
  final ValueChanged onChangeVal;
  final bool isErrorText;
  final Color? filledColor;
  final Color focusBorderColor;
  final Color outLineInputBorderColor;
  final Color enableBorderColor;
  final String isErrorTextString;
  final TextCapitalization textCapitalization;
  final bool isPrefixIcon;
  final IconData iconData;
  final Color prefixColor;
  final double prefixSize;
  const CommonTextFieldWidget({Key? key, required this.keyboardPopType, required this.controller, required this.maxLines, required this.hintText, required this.isObscureText, required this.isSuffixPressed, this.typeOfRed, required this.onChangeVal, required this.isErrorText, this.filledColor, required this.focusBorderColor, required this.outLineInputBorderColor, required this.enableBorderColor, required this.isErrorTextString, required this.textCapitalization, required this.isPrefixIcon, required this.iconData, required this.prefixColor, required this.prefixSize}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardPopType,
      controller: controller,
      autofocus: false,
      textCapitalization: textCapitalization,
      obscureText: isObscureText ? true : false,
      cursorColor: Colors.grey,
      maxLines: maxLines,
      inputFormatters: typeOfRed,
      style: GoogleFonts.roboto(
          textStyle: Theme.of(context).textTheme.displayMedium,
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400
      ),
      cursorWidth: 1,
      decoration: InputDecoration(
        isDense: false,
        prefixIcon: isPrefixIcon?Icon(
          iconData,
          color: prefixColor,
          size: prefixSize,
        ): const SizedBox(
          height: 0,
          width: 0,
        ),
        fillColor: filledColor,
        hintText: hintText,
        errorText: isErrorText ? isErrorTextString : null,
        hintStyle: GoogleFonts.roboto(
            textStyle: Theme.of(context).textTheme.displayMedium,
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400
        ),
        // alignLabelWithHint: false,

        filled: true,
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: focusBorderColor, width: 1),
        ),
        // filled: true,
        //  focusedBorder: InputBorder({BorderSide borderSide = BorderSide.none}),
        border: OutlineInputBorder(
          // focusColor: Colors.white,
          borderSide: BorderSide(color: outLineInputBorderColor, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        //labelText: lablename,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: enableBorderColor, width: 1),
        ),
      ),
      onChanged: onChangeVal,
    );
  }
}
