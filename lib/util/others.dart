import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}

class CategoryHelper {
  final String key = "Category";

  String get category {
    String temp = SharedPreferencesHelper.localStorage.getString(key) ?? "Candy";
    return temp;
  }

  set(String category) {
    SharedPreferencesHelper.localStorage.setString(key, category);
  }
}
