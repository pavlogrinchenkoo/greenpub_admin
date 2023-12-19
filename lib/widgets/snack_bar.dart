import 'package:delivery/style.dart';
import 'package:flutter/material.dart';

class SnackBarService {
  static const errorColor = Colors.red;
  static const okColor = Colors.green;

  static Future<void> showSnackBar(
      BuildContext context, String massage, bool error) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(massage, style: BS.bold14.apply(color: BC.black)),
      backgroundColor: error ? errorColor :  okColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}