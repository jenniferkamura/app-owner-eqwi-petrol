import 'package:flutter/material.dart';

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