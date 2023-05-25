import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> fetchDeviceGPSPosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        throw ('Location services are disabled.');
      } else {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.always) {
          return await Geolocator.getCurrentPosition();
        } else {
          permission = await Geolocator.requestPermission();

          if (permission == LocationPermission.denied) {
            throw ('Location permissions are denied');
          } else if (permission == LocationPermission.deniedForever) {
            // Permissions are denied forever, handle appropriately.
            throw ('Location permissions are permanently denied, we cannot request permissions.');
          } else if (permission == LocationPermission.whileInUse) {
            print("1111111111111111111111111");
            if (Platform.isAndroid) {
              AppSettings.openLocationSettings(callback: () async {
                await AppSettings.openAppSettings();
              });
              //AppSettings.openLocationSettings(asAnotherTask: true);
            }
            permission = await Geolocator.requestPermission();
            print(permission);
            if (permission == LocationPermission.always) {
              print("222222222222222222222222222");
              return await Geolocator.getCurrentPosition();
            }
            print(permission);
            print("3333333333333333333333333333");
            // Permissions are denied forever, handle appropriately.
            throw ('Set the location permissions to "Always" and restart the application.');
          } else {
            if (permission == LocationPermission.always) {
              return await Geolocator.getCurrentPosition();
            } else {
              throw ('Try again.');
            }
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
