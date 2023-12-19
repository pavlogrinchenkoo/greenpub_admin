import 'package:delivery/style.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({this.icon, this.onTap, super.key});

  final Widget? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BRadius.r16,
      color: BC.black,
      child: InkWell(
          borderRadius: BRadius.r16,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: icon),
          )),
    );
  }
}
