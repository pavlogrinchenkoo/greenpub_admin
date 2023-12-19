import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:flutter/material.dart';

import 'custom_buttom.dart';

class CustomShowDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? buttonOne;
  final String? buttonTwo;
  final Function()? onTapOne;
  final Function()? onTapTwo;
  final Widget? text;

  const CustomShowDialog(
      {super.key,
      this.title,
      this.content,
      this.buttonOne,
      this.buttonTwo,
      this.onTapOne,
      this.onTapTwo,
      this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BRadius.r16,
      ),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title ?? "", style: BS.bold14, textAlign: TextAlign.center),
          (text != null)
              ? Row(
                  children: [
                    Space.w8,
                    text ?? const SizedBox(),
                  ],
                )
              : const SizedBox(),
        ],
      ),
      content:
          Text(content ?? "", style: BS.bold14, textAlign: TextAlign.center),
      actions: <Widget>[
        Column(
          children: [
            (buttonOne != null)
                ? CustomButton(
                    icon: Text(buttonOne ?? '', style: BS.bold14.apply(color: BC.white)),
                    onTap: onTapOne,
                  )
                : const SizedBox(),
            Space.h16,
            (buttonTwo != null)
                ? CustomButton(
                    icon: Text(buttonTwo ?? '', style: BS.bold14.apply(color: BC.white)),
                    onTap: onTapTwo,
                  )
                : const SizedBox(),
          ],
        )
      ],
    );
  }
}

class CustomEditDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? buttonOne;
  final String? buttonTwo;
  final Function()? onTapOne;
  final Function()? onTapTwo;
  final Widget? text;
  final TextEditingController controller;

  const CustomEditDialog(
      {super.key,
        this.title,
        this.content,
        this.buttonOne,
        this.buttonTwo,
        this.onTapOne,
        this.onTapTwo,
        this.text, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BRadius.r16,
      ),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title ?? "", style: BS.bold14, textAlign: TextAlign.center),
          (text != null)
              ? Row(
            children: [
              Space.w8,
              text ?? const SizedBox(),
            ],
          )
              : const SizedBox(),
        ],
      ),
      content:
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BRadius.r16,
          border: Border.all(color: BC.black),
        ),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
          )
        ),
      ),
      actions: <Widget>[
        Column(
          children: [
            (buttonOne != null)
                ? CustomButton(
              icon: Text(buttonOne ?? '', style: BS.bold14.apply(color: BC.white)),
              onTap: onTapOne,
            )
                : const SizedBox(),
            Space.h16,
            (buttonTwo != null)
                ? CustomButton(
              icon: Text(buttonTwo ?? '', style: BS.bold14.apply(color: BC.white)),
              onTap: onTapTwo,
            )
                : const SizedBox(),
          ],
        )
      ],
    );
  }
}
