import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.onInit();
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
        messageText: const Text(
          'Please Connect to the Internet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        duration: const Duration(days: 1),
        isDismissible: false,
        backgroundColor: const Color(0xffd32f2f),
        snackStyle: SnackStyle.GROUNDED,
        margin: EdgeInsets.zero,
        icon: const Icon(
          Icons.signal_cellular_connected_no_internet_0_bar,
          color: Colors.white,
        ),
      );
    }else{
      if(Get.isSnackbarOpen){
        Get.closeCurrentSnackbar();
      }
    }
  }
}
