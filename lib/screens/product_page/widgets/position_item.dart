import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/positions/dto.dart';
import 'package:delivery/screens/position_page/bloc/bloc.dart';
import 'package:delivery/screens/product_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/selected_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSauceItem extends StatefulWidget {
  final ProductModelPosition? position;

  const CustomSauceItem({super.key, this.position});

  @override
  State<CustomSauceItem> createState() => _CustomSauceItemState();
}

class _CustomSauceItemState extends State<CustomSauceItem> {
  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<PositionCubit>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BC.white,
        borderRadius: BRadius.r10,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.position?.name ?? '',
                style: BS.bold18,
              ),
              Space.h8,
              Text(
                '${widget.position?.price ?? ' '} грн',
                style: BS.sb14,
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    _bloc.removeSauce(widget.position?.uuid);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
        ],
      ),
    );
  }
}
