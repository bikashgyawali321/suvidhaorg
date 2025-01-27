import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  String? _currentAddress;
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  bool loading = false;
  LocationProvider() {
    getCurrentLocation();
  }
  //get the current address of the user
  Future<void> getCurrentLocation() async {
    loading = true;

    notifyListeners();
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        loading = false;
        notifyListeners();
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude);
        Placemark place = placemarks[0];
        _currentAddress =
            "${place.subLocality}, ${place.locality}, ${place.country}";
        notifyListeners();
      } else {
        _currentAddress = "Permission Denied";
        debugPrint("Permission Denied");
      }
    } catch (e) {
      debugPrint("Exception while fetching location: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
