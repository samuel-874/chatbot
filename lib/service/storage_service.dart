import 'dart:async';
import 'package:sammychatbot/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  setItem({required String key, required String value}) async {
    final pref = await _sharedPreferences;
    pref.setString(key, value);
  }

  getItem(String key) async {
    final pref = await _sharedPreferences;
    String? item = pref.getString(key);
    return item;
  }

  storeUserData(User user) async {
    final pref = await _sharedPreferences;
    pref.setString('user_full_name', user.fullName!);
    pref.setString('user_email', user.email!);
    pref.setString('user_role', user.role!);
    pref.setString('jwt_token', user.token!);
  }

  clearUserData() async {
    final pref = await _sharedPreferences;
    pref.remove('user_full_name');
    pref.remove('user_email');
    pref.remove('user_role');
    pref.remove('jwt_token');
  }

  Future<User> getUserData() async {
    final pref = await _sharedPreferences;
    String? fullName = pref.getString('user_full_name');
    String? email = pref.getString('user_email');
    String? role = pref.getString('user_role');
    String? token = pref.getString('jwt_token');
    return User(fullName: fullName, email: email, role: role, token: token);
  }

  Future<bool> existingKey(String key) async{
    final pref = await _sharedPreferences;
    return pref.containsKey(key);
  }
}
