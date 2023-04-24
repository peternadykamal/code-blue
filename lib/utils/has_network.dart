import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// how to use it
/// ```dart
/// // assuming you have a function that fetches data from the internet
/// Future<void> fetchData() async {
///  // fetch data from the internet
/// }
///
/// Future<void> fetchDataWithInternet() async {
///  if (await isNetworkAvailable()) {
///   await fetchData();
///  }
/// }
/// ```
Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

/// how to use it
/// ```dart
///  Future<String> fetchData() async {
///    // fetch data from the internet
///    return 'data';
///  }
///
///  Future<bool> writeData() async {
///    // write data to the internet
///    return true;
///  }
///
///  Future<void> fetchDataWithInternet() async {
///    final results = await withInternetConnection([
///      () => fetchData(),
///      () => writeData()
///    ]);
///    for (dynamic object in results) {
///      if (object is String) {
///        print(object);
///      } else if (object is bool) {
///        print(object);
///      }
///    }
///  }
/// ```
Future<List<dynamic>> withInternetConnection(
    List<Future<dynamic> Function()> callbacks) async {
  final List<dynamic> results = [];
  try {
    for (final callback in callbacks) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        final result = await callback();
        results.add(result);
      }
    }
  } catch (e) {
    print('Error: $e');
    Fluttertoast.showToast(
      msg: e.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  return results;
}
