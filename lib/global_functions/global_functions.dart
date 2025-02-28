import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:urbanclap_servicemen/theme.dart';

class GlobalFunctions extends GetxController {
  RxString address = ''.obs;

  Future<void> requestLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text("Location Required"),
          content: Text("Please enable location permissions in settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          address.value =
              '${place.subAdministrativeArea}, ${place.locality}, ${place.postalCode}';
        }
      } catch (e) {
        showErrorDialog(e.toString());
      }
    }
  }

  // Inform use widgets

  showGlobalLoader() {
    return showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            strokeCap: StrokeCap.round,
            color: MyTheme.logoColorTheme,
          ),
        );
      },
    );
  }

  showWorkingOnIt() {
    return showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) {
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 1.5,
                    strokeCap: StrokeCap.round,
                    color: MyTheme.logoColorTheme,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Working on it...',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      barrierDismissible: true,
      context: Get.context!,
      builder: (context) {
        return Center(
          child: Card(
            color: Colors.red[100],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
