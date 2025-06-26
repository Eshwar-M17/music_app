import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part 'auth_local_repositery.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepositery authLocalRepositery(Ref ref) {
  return AuthLocalRepositery();
}

class AuthLocalRepositery {
  SharedPreferences? _sharedPreferences;

  Future<void> sharedPreferencesIntilize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Future<SharedPreferences> _getPrefs() async {
  //   return _sharedPreferences ??= await SharedPreferences.getInstance();
  // }

  Future<void> setToken(String? token) async {
    // final prefs = await _getPrefs();
    if (token != null) {
      if (_sharedPreferences == null) {
        print("shared preference is null");
      } else {
        await _sharedPreferences!.setString("token_key", token);
      }
    }
  }

  Future<String?> getToken() async {
    // final prefs = await _getPrefs();
    return _sharedPreferences!.getString("token_key");
  }
}
