import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_test_flutter/src/constant/app_strings.dart';
import 'package:pre_test_flutter/src/extensions/show_toast_extension.dart';
import 'package:pre_test_flutter/src/features/authentication/data/auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isChecked = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: _isLoading,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            TextFormField(
                              controller: _phoneController,
                              validator: _validator,
                              decoration: InputDecoration(
                                hintText: 'Username (or) Phone Number/Email',
                                icon: Icon(Icons.phone),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              validator: _validator,
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
                                onPressed: _onLoginPressed,
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
            ),
          ),
          if (_isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withOpacity(.5),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  Future<void> _onLoginPressed() async {
    setState(() => _isLoading = true);
    if (_formKey.currentState!.validate() && _isChecked) {
      final userName = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      await ref.read(authServiceProvider.notifier).login(
            userName: userName,
            password: password,
            onSuccess: context.showToast,
            onError: (v) => context.showToast(v, true),
          );
    } else {
      context.showToast('Please input required forms!', true);
    }
    setState(() => _isLoading = false);
  }
}
