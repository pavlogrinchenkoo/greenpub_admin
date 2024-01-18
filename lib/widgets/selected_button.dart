import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:flutter/material.dart';

class SelectedButton extends StatelessWidget {
  final bool isSelected;
  final Function()? onTap;
  const SelectedButton({super.key, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BRadius.r10,
          color: isSelected ? BC.white : BC.black,
        ),
        child: Row(
          children: [
            isSelected ? Icon(Icons.check, color: BC.black, size: 18) : const SizedBox(),
            isSelected ? Space.w8 : const SizedBox(),
            isSelected ? Text('Вкл', style: BS.sb14) : Text('Вкл', style: BS.sb14.apply(color: BC.white)),
          ],
        ),
      ),
    );
  }
}