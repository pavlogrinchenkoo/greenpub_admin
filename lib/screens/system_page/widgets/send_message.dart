import 'package:delivery/screens/system_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SendMessage extends StatelessWidget {
  SendMessage({super.key});

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SystemCubit>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BC.white,
        borderRadius: BRadius.r10,
        boxShadow: BShadow.light,
      ),
      child: Column(
        children: [
          const Row(
            children: [BackButton()],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _CustomField(
                  text: 'Заголовок',
                  controller: controllerTitle,
                ),
                Space.h16,
                TextField(
                  controller: controllerText,
                  enabled: true,
                  maxLength: 999,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Опис',
                    focusColor: BC.black,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BRadius.r10,
                        borderSide: BorderSide(
                          color: BC.black,
                          width: 3,
                        )),
                    border: OutlineInputBorder(
                      borderRadius: BRadius.r10,
                    ),
                  ),
                ),
                Space.h16,
                CustomButton(
                  onTap: () => bloc.showDialogSend(context, controllerTitle.text, controllerText.text, '1'),
                  icon: Text('Надіслати', style: BS.bold18.apply(color: BC.white)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String text;

  const _CustomField({super.key, required this.controller, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 99,
      enabled: true,
      decoration: InputDecoration(
        labelText: text,
        focusColor: BC.black,
        focusedBorder: OutlineInputBorder(
            borderRadius: BRadius.r10,
            borderSide: BorderSide(
              color: BC.black,
              width: 3,
            )),
        border: OutlineInputBorder(
          borderRadius: BRadius.r10,
        ),
      ),
    );
  }
}
