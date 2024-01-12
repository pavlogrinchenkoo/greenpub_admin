import 'package:delivery/screens/system_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final String value;
  const CustomContainer({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<SystemCubit>();
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: BC.white,
        borderRadius: BRadius.r16,
        boxShadow: BShadow.light,
      ),
      child: Row(
        children: [
          Text(title, style: BS.bold18),
          Text(
            value,
            style: BS.bold18,
          ),
          // const Spacer(),
          // InkWell(
          //     onTap: () => _bloc.showEdit(context),
          //     child: const Icon(Icons.edit)),
        ],
      ),
    );
  }
}
