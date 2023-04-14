import 'package:connectivity_plus/connectivity_plus.dart';

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
/// // assuming you have a function that fetches data from the internet
/// Future<void> fetchData() async {
///   // fetch data from the internet
/// }
///
/// Future<void> writeData() async {
///   // write data to the internet
/// }
///
/// Future<void> fetchDataWithInternet() async {
///   await withInternetConnection([() => fetchData(), () => writeData()]);
/// }
/// ```
Future<List<dynamic>> withInternetConnection(
    List<Future<dynamic> Function()> callbacks) async {
  final List<dynamic> results = [];
  for (final callback in callbacks) {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      final result = await callback();
      results.add(result);
    }
  }
  return results;
}
