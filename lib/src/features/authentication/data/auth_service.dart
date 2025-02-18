import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pre_test_flutter/src/features/authentication/domain/login_response_model.dart';
import 'package:pre_test_flutter/src/services/dio/dio_provider.dart';
import 'package:pre_test_flutter/src/services/share_preference/share_preference_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  late Dio _dio;
  late SharedPreferences _sharedPreferences;

  @override
  Future<bool> build() async {
    final dioP = ref.watch(dioProvider);
    _dio = dioP.whenData((value) => value).value!;
    final shp = ref.watch(sharePreferencesProvider);
    _sharedPreferences = shp.whenData((value) => value).value!;
    return _sharedPreferences.getBool('isLogin') ?? false;
  }

  Future<void> login({
    required String userName,
    required String password,
    required ValueChanged<String> onSuccess,
    required ValueChanged<String> onError,
  }) async {
    try {
      final response = await _dio.post(
        '/v3/user/',
        data: json.encode({
          'username': userName,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final loginResponse = LoginResponse.fromJson(response.data);
        final loginData = loginResponse.data;
        final accessToken = loginData.accessToken;
        final refreshToken = loginData.refreshToken;
        final expiresIn = loginData.expiresIn;

        await _sharedPreferences.setString('accessToken', accessToken);
        await _sharedPreferences.setString('refreshToken', refreshToken);
        await _sharedPreferences.setInt('expiresIn', expiresIn);

        await _sharedPreferences.setBool('isLogin', true);

        await update((_) => true);
        onSuccess(data['message']);
      } else {
        onError(response.data['message']);
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> logout() async {
    await _sharedPreferences.setBool('isLogin', false);
    await _sharedPreferences.remove('accessToken');
    await _sharedPreferences.remove('refreshToken');
    await _sharedPreferences.remove('expiresIn');
    await update((_) => false);
  }
}
