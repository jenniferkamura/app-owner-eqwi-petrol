import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/models/owner_current_order_model.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/url_links/owner_url_links.dart';
import 'package:owner_eqwi_petrol/modals/stationmodel.dart';

import '../../../modals/staationmangerdetailmodal.dart';

class WebServices {
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

  ///add station api cal
  Future<Map<String, dynamic>> addStationApiCall(
      String userToken,
      stationName,
      contactPerson,
      contactNumber,
      alterNateNumber,
      country,
      state,
      city,
      // pinCode,
      address,
      latitude,
      longitude,
      landmark) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'station_name': stationName,
      'contact_person': contactPerson,
      'contact_number': contactNumber,
      'alternate_number': alterNateNumber,
      'country': country,
      'state': state,
      'city': city,
      // 'pincode': pinCode,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'landmark': landmark,
    });
    try {
      Response res = await dio.post(OwnerUrlLinks.addStationUrl,
          data: formData, options: _optionsPost);
      print('${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (kDebugMode) {
              print(error);
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);

    } on SocketException catch (_) {}
    return {};
  }

  // Add Station Manager api //

  Future<Map<String, dynamic>> addStationManagertApiCall(
      String userToken,
      loginId,
      name,
      email,
      mobile,
      password,
      confirmPassword,
      address,
      latitude,
      longitude,
      stationId) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'login_id': loginId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'password': password,
      'confirm_password': confirmPassword,
      'station_id': stationId,
      'user_type': 'Manager'
    });
    try {
      Response res = await dio.post(OwnerUrlLinks.addStationManagerUrl,
          data: formData, options: _optionsPost);
      print('${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            Fluttertoast.showToast(
                msg: error.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 12.0);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);

    } on SocketException catch (_) {}
    return {};
  }

  // get station manager details //

  Future<Mangerdetails> managerDetailsApi(String mangerId, userToken) async {
    formData = FormData.fromMap({'user_id': mangerId, 'user_token': userToken});
    try {
      Response res = await dio.post(OwnerUrlLinks.editStationMangerUrl,
          data: formData, options: _optionsPost);

      print('Formdate ${res.data["data"]}');
      //  print('Formdate :${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          print('>>>>> ${res.data}');
          // return res.data;
          return Mangerdetails.fromJson(res.data);
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (kDebugMode) {
              print(error);
            }
          }
        }
        // return Mangerdetails.fromJson(res.data['data']);
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return Mangerdetails();
  }

  // update station manager //

  Future<Map<String, dynamic>> updateStationManagertApiCall(
      String userToken,
      loginId,
      name,
      email,
      mobile,
      // password,
      // confirmPassword,
      address,
      latitude,
      longitude,
      stationId,
      managerId,
      userType) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'login_id': loginId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      // 'password': password,
      // 'confirm_password': confirmPassword,
      'station_id': stationId,
      'manager_id': managerId,
      'user_type': 'Manager'
    });
    try {
      Response res = await dio.post(OwnerUrlLinks.UpdateStationMangerUrl,
          data: formData, options: _optionsPost);
      print('${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (kDebugMode) {
              print(error);
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);

    } on SocketException catch (_) {}
    return {};
  }

  // get station manager details //

  Future<Stationdetailsmodel> stationDetailsApi(
      String stationId, userToken) async {
    formData =
        FormData.fromMap({'station_id': stationId, 'user_token': userToken});
    try {
      Response res = await dio.post(OwnerUrlLinks.editStationUrl,
          data: formData, options: _optionsPost);

      print('Formdate ${res.data["data"]}');
      //  print('Formdate :${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          print('>>>>> ${res.data}');
          // return res.data;
          return Stationdetailsmodel.fromJson(res.data);
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (kDebugMode) {
              print(error);
            }
          }
        }
        // return Mangerdetails.fromJson(res.data['data']);
      }
    } on DioError catch (e) {
      // throw Exception(e.message);
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 12.0);
    } on SocketException catch (_) {}
    return Stationdetailsmodel();
  }

  ///add station api cal
  Future<Map<String, dynamic>> updateStationApiCall(
      String userToken,
      stationName,
      contactPerson,
      contactNumber,
      alterNateNumber,
      country,
      state,
      city,
      // pinCode,
      address,
      latitude,
      longitude,
      landmark,
      stationId) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'station_name': stationName,
      'contact_person': contactPerson,
      'contact_number': contactNumber,
      'alternate_number': alterNateNumber,
      'country': country,
      'state': state,
      'city': city,
      // 'pincode': pinCode,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'landmark': landmark,
      'station_id': stationId
    });
    try {
      Response res = await dio.post(OwnerUrlLinks.updateStationUrl,
          data: formData, options: _optionsPost);
      print('form: ${formData.fields}');

      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (kDebugMode) {
              print(error);
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);

    } on SocketException catch (_) {}
    return {};
  }

  ///owner current orders api
  Future<List<OwnerCurrentOrdersModel>> ownerCurrentOrdersApi(
      String userToken) async {
    List<OwnerCurrentOrdersModel> result = [];
    // HddEzNyFSCX8jCUHSFEY
    formData = FormData.fromMap({'user_token': userToken});
    try {
      Response res = await dio.post(OwnerUrlLinks.currentOrderUrl,
          data: formData, options: _optionsPost);
      print('formData >> ${formData.fields}');
      print('res >> $res');
      print('res >> ${res.statusCode}');
      print('res dd>> ${res.data['status']}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          var data = res.data;
          print('data>> $data');
          print('data>> ${data['data']}');
          if (data != null) {
            data["data"].forEach((e) {
              result.add(OwnerCurrentOrdersModel.fromJson(e));
            });
            return result;
          }
        } else if (res.data["status"] == "error") {
          return <OwnerCurrentOrdersModel>[];
        }
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('not connected');
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> addAttenderApiCall(
      String userToken,
      loginId,
      name,
      email,
      mobile,
      password,
      confirmPassword,
      address,
      latitude,
      longitude,
      stationId,
      user_type) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'login_id': loginId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'password': password,
      'confirm_password': confirmPassword,
      'station_id': stationId,
      'user_type': 'Attendant'
    });
    try {
      Response res = await dio.post(OwnerUrlLinks.addStationManagerUrl,
          data: formData, options: _optionsPost);
      print('${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            Fluttertoast.showToast(
                msg: error.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 12.0);
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);

    } on SocketException catch (_) {}
    return {};
  }

  // update attender //

  Future<Map<String, dynamic>> updateAttendarApiCall(
      String userToken,
      loginId,
      name,
      email,
      mobile,
      // password,
      // confirmPassword,
      address,
      latitude,
      longitude,
      stationId,
      managerId,
      userType) async {
    formData = FormData.fromMap({
      'user_token': userToken,
      'login_id': loginId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      // 'password': password,
      // 'confirm_password': confirmPassword,
      'station_id': stationId,
      'manager_id': managerId,
      'user_type': 'Attendant'
    });
    try {
      Response res = await dio.post(OwnerUrlLinks.UpdateStationMangerUrl,
          data: formData, options: _optionsPost);
      print('${formData.fields}');
      if (res.statusCode == 200) {
        if (res.data["status"] == "success") {
          return res.data;
        } else {
          if (res.data["status"] == "error") {
            var error = res.data['message'];
            if (kDebugMode) {
              print(error);
            }
          }
        }
      }
    } on DioError catch (e) {
      // throw Exception(e.message);

    } on SocketException catch (_) {}
    return {};
  }
}
