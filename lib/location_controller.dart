// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
//
// class LocationController extends GetxController {
//   late Position currentLocation;
//
//   Future<void> listenCurrentLocation() async {
//     LocationPermission locationPermission = await Geolocator.checkPermission();
//
//     if (locationPermission == LocationPermission.always ||
//         locationPermission == LocationPermission.whileInUse) {
//       final bool isLocationServiceEnable =
//           await Geolocator.isLocationServiceEnabled();
//       if (isLocationServiceEnable) {
//         currentLocation = await Geolocator.getCurrentPosition();
//         update();
//       } else {}
//     } else {
//       if (locationPermission == LocationPermission.denied ||
//           locationPermission == LocationPermission.deniedForever) {
//         Geolocator.openLocationSettings();
//         return;
//       }
//       LocationPermission requestPermission =
//           await Geolocator.requestPermission();
//       if (requestPermission == LocationPermission.always ||
//           requestPermission == LocationPermission.whileInUse) {
//         listenCurrentLocation();
//       }
//     }
//   }
// }


import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  Position? currentLocation;
  bool locationCheck = false;
  List<LatLng> coOrdinates = [];
  Future<void> listenCurrentLocation() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      // Request permission if it's denied
      locationPermission = await Geolocator.requestPermission();
    }

    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      final bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnabled) {
        currentLocation = await Geolocator.getCurrentPosition();

        locationCheck = true;
        update();
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.bestForNavigation,
              timeLimit: Duration(seconds: 10)),
        ).listen((p) {
          print(currentLocation.toString());
          currentLocation = p;
          coOrdinates.add(LatLng(p.latitude, p.longitude));
          update();
        });
      } else {
        // Handle the case where location services are disabled
        listenCurrentLocation();
      }
    } else if (locationPermission == LocationPermission.deniedForever) {
      // If the permission is still deniedForever, take the user to settings
      Geolocator.openAppSettings();
    }
  }
}
