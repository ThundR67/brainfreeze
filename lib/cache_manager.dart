import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

Future<Map<String, dynamic>> cacheManaged(String key,
    Function fetchDataFromNetwork, dynamic valueToPass) async {
  Map<String, dynamic> data;
  data = await fetchDataFromNetwork(valueToPass);
  /*
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    data = await fetchDataFromNetwork(valueToPass)
        .timeout(const Duration(seconds:10));
  } on TimeoutException catch (_) {
    String cachedData = prefs.getString(key);
    data = json.decode(cachedData);
    return data;
  }
  */
  print(data);
  //await prefs.setString(key, json.encode(data));
  return data;
}
