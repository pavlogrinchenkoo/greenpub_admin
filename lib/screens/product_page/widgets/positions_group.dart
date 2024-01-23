import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/screens/product_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/selected_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PositionsGroup extends StatelessWidget {
  final PositionGroupModel? position;

  const PositionsGroup({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ProductCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${position?.name}', style: BS.bold18),
            Space.w16,
            SelectedButton(
                onTap: () => _bloc.changeRequired(position),
                isSelected: position?.required ?? false),
            Space.w16,
            CustomButton(
              onTap: () => _bloc.showPosition(context, position),
              icon: Text('Змінити', style: BS.bold14.apply(color: BC.white)),
            ),
            const Spacer(),
            IconButton(onPressed: () => _bloc.removePosition(position?.name), icon: const Icon(Icons.delete)),
          ],
        ),
        Space.h16,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var item in position?.positions ?? [])
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: BC.beige,
                  borderRadius: BRadius.r10,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.name}', style: BS.bold16),
                        Space.h8,
                        Text('${item.price} грн', style: BS.sb14),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }
}
