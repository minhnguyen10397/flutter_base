import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataHelper {
  final String _keyUser = "_keyUser";
  final String _keyToken = "_keyToken";
  final String _keyRefreshToken = "_keyRefreshToken";

  LocalDataHelper._();

  static final instance = LocalDataHelper._();

  late SharedPreferences sharedPreferences;
  late FlutterSecureStorage flutterSecureStorage;

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    flutterSecureStorage = const FlutterSecureStorage();
  }

  setUser(int data) async {
    await sharedPreferences.setInt(_keyUser, data);
  }

  int? getUser() {
    final result = sharedPreferences.getInt(_keyUser);
    return result;
  }

  setToken(String token) async {
    await flutterSecureStorage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    String? result = await flutterSecureStorage.read(key: _keyToken);
    return result;
  }

  setRefreshToken(String refreshToken) async {
    await flutterSecureStorage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    String? result = await flutterSecureStorage.read(key: _keyRefreshToken);
    return result;
  }

  clearData() async {
    await sharedPreferences.remove(_keyUser);
    await flutterSecureStorage.delete(key: _keyToken);
    await flutterSecureStorage.delete(key: _keyRefreshToken);
  }
}
