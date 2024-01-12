import 'package:delivery/api/system/dto.dart';
import 'package:delivery/screens/system_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ShowEdit extends StatefulWidget {
  final SystemModel? system;
  ShowEdit({super.key, this.system});

  @override
  State<ShowEdit> createState() => _ShowEditState();
}

class _ShowEditState extends State<ShowEdit> {
  final TextEditingController controllerStart = TextEditingController();

  final TextEditingController controllerEnd = TextEditingController();

  final TextEditingController controllerPrice = TextEditingController();

  final maskFormatterTime = MaskTextInputFormatter(
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final maskFormatterPrice = MaskTextInputFormatter(
      mask: '####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    controllerStart.text = widget.system?.startTime ?? '';
    controllerEnd.text = widget.system?.endTime ?? '';
    controllerPrice.text = widget.system?.deliveryPrice?.toString() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<SystemCubit>();
    return CustomScaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: BC.beige,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomField(
                    text: 'Початок роботи',
                    controller: controllerStart,
                    maskFormatter: maskFormatterTime,
                  ),
                ),
                Space.w16,
                Expanded(
                  child: CustomField(
                    text: 'Кінець роботи',
                    controller: controllerEnd,
                    maskFormatter: maskFormatterTime,
                  ),
                ),
              ],
            ),
            Space.h16,
            CustomField(
              text: 'Кількість грн за км',
              controller: controllerPrice,
              maskFormatter: maskFormatterPrice,
            ),
            Space.h16,
            CustomButton(
              onTap: () => _bloc.saveSystem(context, SystemModel(
                startTime: controllerStart.text,
                endTime: controllerEnd.text,
                deliveryPrice: double.parse(controllerPrice.text),
              )),
              icon: Text('Зберегти', style: BS.bold18.apply(color: BC.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final MaskTextInputFormatter maskFormatter;
  final String text;

  const CustomField(
      {super.key,
      required this.controller,
      required this.maskFormatter,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [maskFormatter],
      controller: controller,
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
