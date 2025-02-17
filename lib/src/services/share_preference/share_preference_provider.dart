import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'share_preference_provider.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharePreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}
