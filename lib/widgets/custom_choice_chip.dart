import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:flutter/material.dart';

class CustomChoiceChip extends StatefulWidget {
  final List<CustomItem>? children;

  const CustomChoiceChip({super.key, this.children});

  @override
  State<CustomChoiceChip> createState() => _CustomChoiceChipState();
}

class _CustomChoiceChipState extends State<CustomChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.children ?? [],
    );
  }
}

class CustomItem extends StatelessWidget {
  final bool isSelected;
  final String? text;
  final Function()? onTap;

  const CustomItem(
      {super.key, required this.isSelected, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
          duration: BDuration.d500,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Colors.white : BC.grey,
          ),
          child: Row(
            children: [
              isSelected ?  Icon(Icons.check, size: 18, color: BC.black) : const SizedBox(),
              isSelected ? Space.w8 : const SizedBox(),
              Text(
                text ?? "",
                style:
                    BS.light14.apply(color: isSelected ? BC.black : BC.black),
              ),
            ],
          )),
    );
  }
}
