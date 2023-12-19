import 'package:delivery/style.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: Center(
            child: CircularProgressIndicator(
      color: BC.black,
      strokeWidth: 3,
    )));
  }
}
