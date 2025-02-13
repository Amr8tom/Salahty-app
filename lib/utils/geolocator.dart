import 'package:al_quran/utils/permissions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GetLocation {
  /// Private constructor for singleton
  GetLocation._privateConstructor();
  static final _instanste= GetLocation._privateConstructor();
  static  Position? pos;
  factory GetLocation(){return _instanste;}

  /// Fetches the current latitude and longitude.
  static Future<void> getLatLang({ BuildContext? context}) async {
    bool serviceEnabled;
    LocationPermission permission;

    /// Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if(context!=null){
      showLocationDialog(context);}
      return Future.error('Location services are disabled.');
    }

    /// Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    pos=await Geolocator.getCurrentPosition();
await Permissions.alarm();
await Permissions.notifications();
  }

  /// Shows a dialog prompting the user to enable location services.
  static void showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Location Services'),
        content: const Text(
            'Location services are disabled. Please enable them to continue.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
              // You might want to recheck the location service status after this.
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
