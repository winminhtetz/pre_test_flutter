import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_test_flutter/src/common_widgets/error_page.dart';
import 'package:pre_test_flutter/src/common_widgets/loading_page.dart';
import 'package:pre_test_flutter/src/features/authentication/data/auth_service.dart';
import 'package:pre_test_flutter/src/features/authentication/presentation/login_page.dart';
import 'package:pre_test_flutter/src/features/pick_up/presentation/pick_up_page.dart';

void main() => runApp(ProviderScope(child: const MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authS = ref.watch(authServiceProvider);

    return MaterialApp(
      title: 'Pre Test Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        useMaterial3: true,
      ),
      home: authS.when(
        data: (alreadyLogin) => alreadyLogin ? PickUpPage() : LoginPage(),
        error: (_, __) => ErrorPage(),
        loading: () => LoadingPage(),
      ),
    );
  }
}
