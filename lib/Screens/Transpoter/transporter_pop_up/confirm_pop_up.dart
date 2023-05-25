import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/controllers/home_page_controller.dart';

class ConfirmPopUpTransporter extends StatefulWidget {
  final void Function() tapAction;
  String type;

  ConfirmPopUpTransporter(
      {Key? key, required this.tapAction, required this.type})
      : super(key: key);

  @override
  State<ConfirmPopUpTransporter> createState() =>
      _ConfirmPopUpTransporterState();
}

class _ConfirmPopUpTransporterState extends State<ConfirmPopUpTransporter> {
  TransportHomeController transportHomeController =
      Get.put(TransportHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF89A619),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text(
                          'Confirmation',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.whiteColor),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/wrong.png',
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 11,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: 0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: widget.type == 'Reach'
                        ? const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Have you '),
                                TextSpan(
                                  text: 'Reached?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Have You '),
                                TextSpan(
                                  text: 'Loaded?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ' The Orders'),
                              ],
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Obx(
                        () => (transportHomeController.isReachLoad.value ||
                                transportHomeController.isReachorderLoad.value)
                            ? ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: widget.tapAction,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                child: const Text('YES'),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
