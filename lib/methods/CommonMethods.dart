import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods {
  void checkConnectivity(BuildContext context) async {
    var ConnectionResult = await Connectivity().checkConnectivity();
    if (ConnectionResult != ConnectivityResult.mobile &&
        ConnectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      displaySnackbar(
          "Internet is not connected, Check your connection and try again",
          context);
    }
  }

  void displaySnackbar(String messageText, BuildContext context) {
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
