import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Dio> dio(Ref ref) async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://dev.gigagates.com/qq-delivery-backend',
      contentType: Headers.jsonContentType,
      validateStatus: (status) => status != 404,
      headers: {
        HttpHeaders.acceptHeader: Headers.jsonContentType,
      },
    ),
  );

  return dio;
}
