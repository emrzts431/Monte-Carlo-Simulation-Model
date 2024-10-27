import 'package:flutter/material.dart';

class SnackbarHolder {
  SnackbarHolder._();

  static void showSnackbar(String message, bool isError, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: (isError) ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            left: 10,
            right: 10),
      ),
    );
  }
}
