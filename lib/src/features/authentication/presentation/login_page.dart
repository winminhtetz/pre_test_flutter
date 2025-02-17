import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_test_flutter/src/constant/app_strings.dart';
import 'package:pre_test_flutter/src/features/authentication/data/auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //App Logo
                    Image.asset(
                      AppStrings.logoPath,
                      width: 140,
                    ),
                    const SizedBox(height: 20),

                    //UserName and Password Fields
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Username (or) Phone Number/Email',
                        icon: Icon(Icons.phone),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        icon: Icon(Icons.star),
                      ),
                    ),
                    const SizedBox(height: 20),

                    //Terms and Conditions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) => setState(() {
                            _isChecked = value!;
                          }),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              color: themeColor,
                              decoration: TextDecoration.underline,
                              decorationColor: themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //Login Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          await ref.read(authServiceProvider.notifier).login(
                                userName: 'admin',
                                password: 'abc123',
                                onSuccess: (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value)));
                                },
                                onError: (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value)));
                                },
                              );
                        },
                        child: Text('Login'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
