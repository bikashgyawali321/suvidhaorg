import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:suvidha/models/auth_models/auth_token.dart';

class CustomHive {
  CustomHive._internal();

  static final CustomHive _customHive = CustomHive._internal();

  factory CustomHive() => _customHive;
  late final Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('suvidha');
  }

  //save auth tokens
  Future<void> saveAuthToken(AuthToken token) async {
    return await _box.put('auth_token', jsonEncode(token.toJson()));
  }

  //get auth tokens
  AuthToken? getAuthToken() {
    final token = _box.get('auth_token');
    if (token == null) return null;
    final decodedToken = jsonDecode(token);

    return AuthToken.fromJson(decodedToken);
  }

  //delete auth tokens
  Future<void> deleteToken() async {
    return await _box.delete('auth_token');
  }

  //save theme mode
  void saveThemeMode(ThemeMode themeMode) {
    _box.put('theme_mode', themeMode.index);
  }

  //get theme mode
  Future<ThemeMode> getThemeMode() async {
    final themeIndex =
        await _box.get('theme_mode', defaultValue: ThemeMode.light.index);

    return ThemeMode.values[themeIndex];
  }

  //save fcm token

    Future<void> saveFCMToken(String token) {
    return _box.put('fcmToken', token);
  }

  //get fcm token
  String? getFCMToken() {
    String? encodedToken = _box.get('fcmToken');
    return encodedToken;
  }
}
