import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

class NetworkService {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  void startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "Network Connected",
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Network Connected",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    });
  }

  void dispose() {
    _subscription.cancel();
  }
}
