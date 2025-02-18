import 'package:flutter/material.dart';

extension ShowToastExtension on BuildContext {
  void showToast(String message, [bool isError = false]) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message),
      ),
    );
  }
}
