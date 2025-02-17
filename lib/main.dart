import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_test_flutter/src/features/authentication/data/auth_service.dart';
import 'package:pre_test_flutter/src/features/authentication/presentation/login_page.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authS = ref.watch(authServiceProvider);
    final authStatus = authS.whenData((value) => value).valueOrNull ?? false;
    return MaterialApp(
      title: 'Pre Test Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        useMaterial3: true,
      ),
      home: authStatus
          ? Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
              ),
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await ref.read(authServiceProvider.notifier).logout();
                  },
                  child: Text('Logout'),
                ),
              ),
            )
          : LoginPage(),
    );
  }
}
