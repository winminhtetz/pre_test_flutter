import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pre_test_flutter/src/features/pick_up/domain/pick_up_model.dart';
import 'package:pre_test_flutter/src/services/dio/dio_provider.dart';
import 'package:pre_test_flutter/src/services/share_preference/share_preference_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pickup_service.g.dart';

@Riverpod(keepAlive: true)
class PickupService extends _$PickupService {
  late Dio _dio;
  late SharedPreferences _sharedPreferences;
  late String? _token;

  @override
  Future<List<Item>?> build() async {
    final shp = ref.watch(sharePreferencesProvider);
    _sharedPreferences = shp.whenData((value) => value).value!;
    _token = _sharedPreferences.getString('accessToken');
    final dioP = ref.watch(dioProvider);
    _dio = dioP.whenData((value) => value).value!;
    return getPickUp();
  }

  Future<List<Item>?> getPickUp({
    int? page,
    int max = 10,
    ValueChanged<String>? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    try {
      final response = await _dio.post(
        '/v4/pickup/list',
        data: json.encode({
          'first': page ?? 0,
          'max': max,
        }),
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
          },
        ),
      );

      if (response.statusCode == 200) {
        final resData = response.data;
        final d = resData['data'];
        final list = Pickup.fromJson(d);
        return list.items;
      } else {
        final message = response.data['message'];
        onError?.call(message);
        return null;
      }
    } catch (e) {
      onError?.call(e.toString());
      return null;
    }
  }

  Future<void> getMorePickups({
    int? page,
    int max = 10,
    ValueChanged<String>? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    try {
      final response = await _dio.post(
        '/v4/pickup/list',
        data: json.encode({
          'first': page ?? 0,
          'max': max,
        }),
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
          },
        ),
      );

      if (response.statusCode == 200) {
        final resData = response.data;
        final d = resData['data'];
        final list = Pickup.fromJson(d);
        await update((p0) => [...?p0, ...list.items]);
        
      } else {
        final message = response.data['message'];
        onError?.call(message);
      }
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
