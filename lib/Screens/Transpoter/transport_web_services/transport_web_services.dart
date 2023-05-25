import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/login_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/adds_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/button_status_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/contact_us_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/delete_date_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/delete_notification_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/get_compartments_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/help_and_rais_ticket.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/help_and_support_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/logout_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/not_availble_dates_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/notifications_list_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/reject_reason_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/signature_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/today_route_orders_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_avail_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_home_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_list_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/transporter_order_details_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/url_links/transport_url_links.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class TransportWebServices {
  FormData formData = FormData();
  static BaseOptions options = BaseOptions(
      baseUrl: Constants.baseurl,
      connectTimeout: 60 * 1000, // 60 seconds
      receiveTimeout: 60 * 1000 // 60 seconds
      );
  final Options _options = Options(
    method: 'get',
    headers: {},
    responseType: ResponseType.json,
    contentType: Headers.jsonContentType,
  );
  final Options _optionsPost = Options(
    method: 'post',
    headers: {},
    responseType: ResponseType.json,
    contentType: Headers.jsonContentType,
  );
  static Dio dio = Dio(options);

  ///transporter home
  Future<TransporterHomeModel> transporterHomeApi(String userToken) async {
    formData = FormData.fromMap({
      'user_token': userToken,
    });
    // call me yeah bro its not connecting wait
    try {
      Response res = await dio.post(TransportUrlLinks.transporterHomeUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return TransporterHomeModel.fromJson(res.data['data']);
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            // Fluttertoast.showToast(
            //     msg: error,
            //     toastLength: Toast.LENGTH_SHORT,
            //     gravity: ToastGravity.BOTTOM,
            //     timeInSecForIosWeb: 1,
            //     backgroundColor: Colors.red[600],
            //     textColor: Colors.white,
            //     fontSize: 12.0);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      // Fluttertoast.showToast(
      //     msg: e.message,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red[600],
      //     textColor: Colors.white,
      //     fontSize: 12.0);
    } on SocketException catch (_) {}
    return TransporterHomeModel(rating: "0");
  }

  ///transporter availability
  Future<TransporterAvailModel> transporterAvailabilityApi(String userToken,
      String available, double lat, double lag, String dateTime) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'available': available,
      'latitude': lat,
      'longitude': lag,
      'list_date': '["$dateTime"]',
    });

    try {
      Response res = await dio.post(TransportUrlLinks.transporterAvailableUrl,
          data: formData, options: _optionsPost);
      print('Avail >>> ${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          print('Avail >>> ${res.data}');

          return TransporterAvailModel.fromJson(res.data['data']);
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[600],
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return TransporterAvailModel(
        userId: '',
        loginId: '',
        name: '',
        email: '',
        mobile: '',
        address: '',
        stationId: '',
        latitude: '',
        longitude: '',
        profilePic: '',
        userToken: userToken,
        userType: '',
        transporterAvailable: false,
        profilePicUrl: '');
  }

  ///pickUp orders list
  Future<TransportOrderListModel> pickUpOrdersApi(
      String userToken, orderStatus) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'order_status': orderStatus,
    });
    try {
      Response res = await dio.post(
          TransportUrlLinks.transporterPickUpOrderListUrl,
          data: formData,
          options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return TransportOrderListModel.fromJson(res.data['data']);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            TransportOrderListModel(
                pagesCount: 0, result: [], totalRecordsCount: 0);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return TransportOrderListModel(
        pagesCount: 0, result: [], totalRecordsCount: 0);
  }

  ///transporter Action
  Future<Map<String, dynamic>> transporterActionApi(String userToken, orderId,
      assignOrderId, orderStatus, reasonTitle, reasonDescription) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'order_id': orderId,
      'assign_order_id': assignOrderId,
      'order_status': orderStatus,
      'reason_id': reasonTitle,
      'reason_description': reasonDescription,
    });

    try {
      Response res = await dio.post(TransportUrlLinks.transporterOrderActionUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              return res.data;
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return {};
  }

  ///accept order details
  Future<TransportOrderDetailsModel> acceptOrderDetails(

      String userToken, orderId) async {
    print('INSIDE CALL ');
    formData = FormData.fromMap({
      'user_token': userToken,
      'order_id': orderId,
    });
    try {
      Response res = await dio.post(
          TransportUrlLinks.transporterOrderDetailsUrl,
          data: formData,
          options: _optionsPost);

      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return TransportOrderDetailsModel.fromJson(res.data['data']);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return TransportOrderDetailsModel();
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return TransportOrderDetailsModel();
  }

  Future<RejectReasonModel> rejectReasonApi(String userToken) async {
    RejectReasonModel result;
    formData = FormData.fromMap({
      'user_token': userToken,
    });
    try {
      Response res = await dio.post(
          TransportUrlLinks.transporterRejectReasonListUrl,
          data: formData,
          options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          var data = res.data;
          result = RejectReasonModel.fromJson(data);
          return result;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: 'SocketException',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return RejectReasonModel(status: '', message: '', data: []);
  }

  Future<Map<String, dynamic>> reachedOrderButtonApi(
    userToken,
    orderId,
    assignOrderId,
    orderStatus,
  ) async {
    formData = FormData.fromMap({
      'user_token': userToken.toString(),
      'order_id': orderId.toString(),
      'assign_order_id': assignOrderId.toString(),
      'order_status': orderStatus.toString(),
    });

    try {
      Response res = await dio.post(TransportUrlLinks.transporterOrderActionUrl,
          data: formData, options: _optionsPost);
      //return{};
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              return res.data;
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return {};
  }

  Future<Map<String, dynamic>> reachedButtonApi(
      String userToken,
      orderId,
      assignOrderId,
      orderStatus,
      reasonTitle,
      reasonDescription,
      orderDetailsId,
      otp,
      signatureFile) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'order_id': orderId,
      'assign_order_id': assignOrderId,
      'order_status': orderStatus,
      'reason_id': reasonTitle,
      'reason_description': reasonDescription,
      'order_detail_id': orderDetailsId,
      'otp': otp,
      'signature_file': signatureFile,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.transporterOrderActionUrl,
          data: formData, options: _optionsPost);
      //return{};
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              return res.data;
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return {};
  }

  Future<Map<String, dynamic>> dell(String userToken, String orderId,
      String assignOrderId, String orderStatus, String otp, File file) async {
    String fileName = file.path.split('/').last;
    formData = FormData.fromMap({
      'user_token': userToken,
      'order_id': orderId,
      'assign_order_id': assignOrderId,
      'order_status': orderStatus,
      'otp': otp,
      'signature': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    try {
      Response res = await dio.post(TransportUrlLinks.transporterOrderActionUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else if (res.data["status"] == "error") {
          return res.data;
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return {};
  }

  uploadAttachmentAndFilesApiCall(
      String userToken, String imagePath, String documentType) async {
    try {
      String fileName = "fdsfdsfsd.jpg";
      String? mimeType = mime(fileName);
      String? mimee = mimeType?.split('/')[0];
      String? type = mimeType?.split('/')[1];
      dio.options.headers["Content-Type"] = "multipart/form-data";

      FormData formData = FormData.fromMap({
        "user_token": userToken,
        "front_photo": await MultipartFile.fromFile(imagePath,
            filename: fileName, contentType: MediaType(mimee!, type!)),
        "document_type": documentType,
      });
      Response res = await dio.post(TransportUrlLinks.uploadDocumentsUrl,
          data: formData, options: _optionsPost);
      // .catchError((e) => print(e.response.toString()));
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          var data = res.data;
          return data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            }
          }
        }
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    } on SocketException catch (_) {}
    return '';
  }

  ///delivery tap
  Future<ButtonStatusModel> deliveredButtonApi(
      String userToken,
      orderId,
      assignOrderId,
      orderStatus,
      reasonTitle,
      reasonDescription,
      orderDetailsId,
      otp,
      signatureFile) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'order_id': orderId,
      'assign_order_id': assignOrderId,
      'order_status': orderStatus,
      'reason_id': reasonTitle,
      'reason_description': reasonDescription,
      'order_detail_id': orderDetailsId,
      'otp': otp,
      'signature_file': signatureFile,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.transporterOrderActionUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return ButtonStatusModel.fromJson(res.data['data']);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return ButtonStatusModel.fromJson(res.data['data']);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return ButtonStatusModel();
  }

  Future<SignatureModel> signatureSubmitApi(
      String userToken, File file, String documentType) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "user_token": userToken,
      "front_photo":
          await MultipartFile.fromFile(file.path, filename: fileName),
      "document_type": documentType,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.uploadDocumentsUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: 'Signature successfully Uploaded',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 12.0);
          return SignatureModel.fromJson(res.data['data']);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return SignatureModel.fromJson(res.data['data']);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return SignatureModel();
  }

  ///get notifications
  Future<NotificationsListModel> getNotificationsApis(
      String userToken, String page) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'page': page,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.getNotificationsUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return NotificationsListModel.fromJson(res.data['data']);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return NotificationsListModel(
                pagesCount: 0, result: [], totalRecordsCount: 0);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return NotificationsListModel(
        pagesCount: 0, result: [], totalRecordsCount: 0);
  }

  ///log OUt
  Future<LogOutModel> transporterLogoutApi(String userToken) async {
    formData = FormData.fromMap({
      'user_token': userToken,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.logoutUrl,
          data: formData, options: _optionsPost);
      // log('res.data >>>>${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return LogOutModel.fromJson(res.data);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return LogOutModel(status: '', message: '', data: false);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return LogOutModel(status: '', message: '', data: false);
  }

  ///notification
  Future<DeleteNotificationModel> deleteNotification(
      String userToken, String notificationId) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'notification_id': notificationId,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.deleteNotificationsUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return DeleteNotificationModel.fromJson(res.data);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return DeleteNotificationModel(
                status: '', message: '', data: false);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return DeleteNotificationModel(status: '', message: '', data: false);
  }

  ///contact us api
  Future<ContactUsModel> contactUsApi() async {
    try {
      Response res =
          await dio.get(TransportUrlLinks.contactUsUrl, options: _options);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return ContactUsModel.fromJson(res.data['data']);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return ContactUsModel();
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return ContactUsModel();
  }

  ///notification
  Future<RaiseTicketModel> raiseTicketApi(
      String userToken, String queryDetails) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'query_detail': queryDetails,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.raisedTicketUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return RaiseTicketModel.fromJson(res.data);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return RaiseTicketModel(status: '', message: '', data: '');
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return RaiseTicketModel(status: '', message: '', data: '');
  }

  Future<AddsModel> addsApiCall(String userToken) async {
    AddsModel result;
    formData = FormData.fromMap({
      'user_token': userToken,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.advertisementUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          var data = res.data;
          result = AddsModel.fromJson(data);
          return result;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: 'SocketException',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return AddsModel(status: '', message: '', data: []);
  }

  Future<HelpAndSupportModel> heliAndSupportQApi(
      String userToken, String queryDetails) async {
    HelpAndSupportModel result;
    formData = FormData.fromMap({
      'user_token': userToken,
      'search': queryDetails,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.helpAndSupportUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          var data = res.data;
          result = HelpAndSupportModel.fromJson(data);
          return result;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              return HelpAndSupportModel(status: '', message: '', data: []);
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: 'SocketException',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return HelpAndSupportModel(status: '', message: '', data: []);
  }

  Future<DeleteNotificationModel> deleteAllNotification(
      String userToken) async {
    formData = FormData.fromMap({
      'user_token': userToken,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.deleteAllNotificationsUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return DeleteNotificationModel.fromJson(res.data);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return DeleteNotificationModel(status: '', message: '', data: false);
  }

  ///pickUp orders list
  Future<TransportOrderListModel> ordersApi(
      String userToken, String orderStatus) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'order_status': orderStatus,
    });
    try {
      Response res = await dio.post(
          TransportUrlLinks.transporterPickUpOrderListUrl,
          data: formData,
          options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return TransportOrderListModel.fromJson(res.data['data']);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            TransportOrderListModel(
                pagesCount: 0, result: [], totalRecordsCount: 0);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return TransportOrderListModel(
        pagesCount: 0, result: [], totalRecordsCount: 0);
  }

  Future<Map<String, dynamic>> transporterUpdateProfileApi(
      String userToken,
      String name,
      String email,
      String mobileNo,
      String vehicleNo,
      String vehicleCapacity,
      String compartmentDetail,
      String vehicleFrontPhoto,
      String vehicleBackPhoto,
      String vehicleLeftPhoto,
      String vehicleRightPhoto,
      String vehicleDocument,
      String numberOfCompartments,
      String documentNumber,
      String drivingLicense,
      String vehicleId) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'name': name,
      'email': email,
      'mobile': mobileNo,
      'vehicle_number': vehicleNo,
      'vehicle_capacity': vehicleCapacity,
      'compartment_detail': compartmentDetail,
      'front_vehicle_photo': vehicleFrontPhoto,
      'back_vehicle_photo': vehicleBackPhoto,
      'left_vehicle_photo': vehicleLeftPhoto,
      'right_vehicle_photo': vehicleLeftPhoto,
      'vehicle_document': vehicleDocument,
      'no_of_compartment': numberOfCompartments,
      'document_number': documentNumber,
      'driving_license': drivingLicense,
      'vehicle_id': vehicleId,
    });
    try {
      Response res = await dio.post(
          TransportUrlLinks.transporterUpdateProfileUrl,
          data: formData,
          options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              return res.data;
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return {};
  }

  Future<Map<String, dynamic>> uploadAttachmentAndFilesNewApiCall(
      String userToken, File file, String documentType) async {
    try {
      /*  String fileNameN = "fdsfdsfsd.jpg";
      String? mimeType = mime(fileNameN);
      String? mimee = mimeType?.split('/')[0];
      String? type = mimeType?.split('/')[1];
      dio.options.headers["Content-Type"] = "multipart/form-data";*/
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "user_token": userToken,
        "front_photo":
            await MultipartFile.fromFile(file.path, filename: fileName),
        "document_type": documentType,
      });
      Response res = await dio.post(TransportUrlLinks.uploadDocumentsUrl,
          data: formData, options: _optionsPost);
      // .catchError((e) => print(e.response.toString()));
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          var data = res.data;
          return data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            }
          }
        }
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return {};
  }

  Future<Map<String, dynamic>> transporterAvailableDateVise(
    String userToken,
    String available,
    List listDate,
  ) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'available': available,
      'latitude': '',
      'longitude': '',
      'list_date': jsonEncode(listDate),
    });
    try {
      Response res = await dio.post(TransportUrlLinks.transporterAvailableUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (error == 'User token expired!') {
              Get.offAll(() => const LoginScreen(),
                  duration: const Duration(milliseconds: 400),
                  transition: Transition.rightToLeft);
              Fluttertoast.showToast(
                  msg: error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[600],
                  textColor: Colors.white,
                  fontSize: 12.0);
            } else {
              return res.data;
            }
          }
        }
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return {};
  }

  // Future<TransporterAvailModel> transporterAvailableDateVise(
  //     String userToken, String available, double lat, double lag,List listDate) async {
  //   formData = FormData.fromMap({
  //     'user_token': userToken,
  //     'available': available,
  //     'latitude': lat,
  //     'longitude': lag,
  //     'list_date':jsonEncode(listDate),
  //   });
  //   try {
  //     Response res = await dio.post(TransportUrlLinks.transporterAvailableUrl,
  //         data: formData, options: _optionsPost);
  //     if (res.statusCode == 200) {
  //       print('*****************(((((((((');
  //       print(res.data);
  //       if (res.data["status"] == "success") {
  //         print('*********************');
  //         print(res.data);
  //         print(res.data["status"]);
  //         print(res.data["data"]);
  //         print('*********************');
  //         return TransporterAvailModel.fromJson(res.data['data']);
  //       } else {
  //         if (res.data["status"] == "error") {
  //           var error = res.data['message'];
  //           Fluttertoast.showToast(
  //               msg: error,
  //               toastLength: Toast.LENGTH_SHORT,
  //               gravity: ToastGravity.BOTTOM,
  //               timeInSecForIosWeb: 1,
  //               backgroundColor: Colors.red[600],
  //               textColor: Colors.white,
  //               fontSize: 12.0);
  //         }
  //       }
  //     }
  //   } on DioError catch (e) {
  //     // throw Exception(e.message);
  //     Fluttertoast.showToast(
  //         msg: e.message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red[600],
  //         textColor: Colors.white,
  //         fontSize: 12.0);
  //   } on SocketException catch (_) {}
  //   return TransporterAvailModel(
  //       userId: '',
  //       loginId: '',
  //       name: '',
  //       email: '',
  //       mobile: '',
  //       address: '',
  //       stationId: '',
  //       latitude: '',
  //       longitude: '',
  //       profilePic: '',
  //       userToken: userToken,
  //       userType: '',
  //       transporterAvailable: '',
  //       profilePicUrl: '');
  // }

  ///pickUp orders list
  Future<NotAvailbleDatesListModel> notAvailableDatesApiCall(
      String userToken) async {
    formData = FormData.fromMap({
      'user_token': userToken,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.myAvailability,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return NotAvailbleDatesListModel.fromJson(res.data['data']);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            NotAvailbleDatesListModel(
                pagesCount: 0, result: [], totalRecordsCount: 0);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return NotAvailbleDatesListModel(
        pagesCount: 0, result: [], totalRecordsCount: 0);
  }

  Future<DeleteNotAvailableDates> deleteAvailableDatesApiCall(
      String userToken, String dateId) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'id': dateId,
    });
    try {
      Response res = await dio.post(
          TransportUrlLinks.deleteTransporterAvailable,
          data: formData,
          options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return DeleteNotAvailableDates.fromJson(res.data);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return DeleteNotAvailableDates(status: '', message: '');
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return DeleteNotAvailableDates(status: '', message: '');
  }

  Future<TodayOrdersModelModel> todayRoutePlanApiCall(String userToken) async {
    formData = FormData.fromMap({
      'user_token': userToken,
    });
    try {
      Response res = await dio.post(TransportUrlLinks.todayOrderListUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          var data = res.data;
          return TodayOrdersModelModel.fromJson(data);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            return TodayOrdersModelModel(status: '', message: '', data: []);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return TodayOrdersModelModel(status: '', message: '', data: []);
  }

  ///pickUp orders list
  Future<GetCompartmentModel> getCompartmentsApi(String userToken) async {
    formData = FormData.fromMap({
      'user_token': userToken,
    });
    print('555555');
    print('${formData.fields}');
    print('555555');
    try {
      Response res = await dio.post(TransportUrlLinks.getVehicleUrl,
          data: formData, options: _optionsPost);
      if (res.statusCode == 200) {
        print('9999999');
        print('${res.data}');
        print('${res.data['status']}');
        print('${res.data['message']}');
        print('99999999');
        if (res.data['status'] == 'success') {
          return GetCompartmentModel.fromJson(res.data);
        } else if (res.data["status"] == "error") {
          var error = res.data['message'];
          if (error == 'User token expired!') {
            Get.offAll(() => const LoginScreen(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.rightToLeft);
            Fluttertoast.showToast(
                msg: error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red[600],
                textColor: Colors.white,
                fontSize: 12.0);
          } else {
            GetCompartmentModel(status: '', data: [], message: '');
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return GetCompartmentModel(status: '', data: [], message: '');
  }

  Future<Map<String, dynamic>> addFuelApi(
    String userToken,
    String orderId,
    List compartmentData,
    String catId,
  ) async {
     formData = FormData.fromMap({
      'user_token': userToken.toString(),
      'order_id': orderId.toString(),
      'compartment_data': jsonEncode(compartmentData),
      'product_id': catId,
    });
    var signupData = jsonEncode({
      'user_token': userToken.toString(),
      'order_id': orderId.toString(),
      'compartment_data': compartmentData,
      'product_id': catId,
    });
    // FormData productData = FormData.fromMap({
    //   "productimage": productImage==null?null:await MultipartFile.fromFile(productImage.path, filename: productImage.path) ,
    //   "name": postData!.name,
    //   "brand":  postData.brand,
    //   "model":  postData.model,
    //   "serialnumber":  postData.serialnumber,
    //   "specifications":  postData.specifications,
    //   "item_id": postData.item!.id,
    //   "is_active": true
    // });

    try {
      Response res = await dio.post(TransportUrlLinks.addFuelUrl,
          data: formData, options: _optionsPost);
      //return{};
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            return res.data;
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return {};
  }
}
