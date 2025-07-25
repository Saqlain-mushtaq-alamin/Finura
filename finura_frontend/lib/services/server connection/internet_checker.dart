
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  static Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
