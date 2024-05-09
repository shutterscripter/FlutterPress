import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  bool isLocationPermissionGranted = false;

  Future<void> checkLocationPermissionAndGrant() async {
    var status = await Permission.location.isGranted;


    if (!status) {
      await Permission.location.request();
      isLocationPermissionGranted = await Permission.location.isGranted;
    }
  }
}
