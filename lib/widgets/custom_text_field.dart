import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? text;
  final bool enabled;
  final String? Function(String?)? validator;

  const CustomTextField(
      {super.key, required this.controller, this.text, required this.enabled, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text ?? '',
          style: BS.light14.apply(color: BC.black),
        ),
        Space.h8,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BRadius.r16,
            border: Border.all(
              color: BC.black,
              width: 1,
            ),
          ),
          child:   FormBuilderTextField(
            controller: controller,
            name: 'text_field',
            decoration: InputDecoration(
              hintText: text,
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: validator,
          ),

          // TextField(
          //     enabled: enabled,
          //     controller: controller,
          //     style: BS.light14.apply(color: BC.black),
          //     decoration: InputDecoration(
          //       hintText: text,
          //       hintStyle: BS.light14.apply(color: BC.black.withOpacity(0.5)),
          //       border: InputBorder.none,
          //       focusedBorder: InputBorder.none,
          //       enabledBorder: InputBorder.none,
          //       errorBorder: InputBorder.none,
          //     )),
        ),
      ],
    );
  }
}
