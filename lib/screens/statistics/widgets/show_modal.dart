import 'package:delivery/screens/statistics/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowModal extends StatefulWidget {
  const ShowModal({super.key});

  @override
  State<ShowModal> createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  String text = 'Сьогодні';

  void changeText(String text) {
    setState(() {
      this.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<StatisticsCubit>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BC.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Text('Фільтр', style: BS.bold16),
          Space.h16,
          CustomSelectButton(
              isSelected: text == 'Сьогодні',
              onTap: () => changeText('Сьогодні'),
              text: 'Сьогодні'),
          Space.h16,
          CustomSelectButton(
              isSelected: text == 'Вчора',
              onTap: () => changeText('Вчора'),
              text: 'Вчора'),
          Space.h16,
          CustomSelectButton(
              isSelected: text == 'Останні 7 днів',
              onTap: () => changeText('Останні 7 днів'),
              text: 'Останні 7 днів'),
          Space.h16,
          CustomSelectButton(
              isSelected: text == 'Останні 15 днів',
              onTap: () => changeText('Останні 15 днів'),
              text: 'Останні 15 днів'),
          Space.h16,
          CustomButton(
            onTap: () => _bloc.getOrdersFilter(context, text),
            icon: Text('Зберегти', style: BS.bold16.apply(color: BC.white)),
          )
        ],
      ),
    );
  }
}

class CustomSelectButton extends StatelessWidget {
  final bool isSelected;
  final void Function() onTap;
  final String text;

  const CustomSelectButton({super.key,
    required this.isSelected,
    required this.onTap,
    required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: BC.black,
                width: 2,
              ),
            ),
            child: isSelected ? Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BC.black,
              ),
            ) : null,
          ),
          Space.w8,
          Text(text, style: BS.sb14),
        ],
      ),
    );
  }
}
