
import 'package:delivery/style.dart';
import 'package:flutter/material.dart';


class CustomSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool value) onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        width: 32,
        height: 16,
        decoration: BoxDecoration(
            color: value ? BC.green : BC.green,
            borderRadius: const BorderRadius.all(Radius.circular(14))),
        child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: value
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: AnimatedContainer(
              width: 14,
              height: 14,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  color: BC.green),
            )),
      ),
    );
  }
}
