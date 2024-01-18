import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/screens/product_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/selected_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowPosition extends StatefulWidget {
  final List<ProductModel> sauces;

  const ShowPosition({super.key, required this.sauces});

  @override
  State<ShowPosition> createState() => _ShowPositionState();
}

class _ShowPositionState extends State<ShowPosition> {
  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ProductCubit>();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
           Row(
            children: [
              BackButton(
                onPressed: () => _bloc.back(context),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.sauces.length,
                itemBuilder: (context, index) {
                  return CustomSauceItem(sauce: widget.sauces[index]);
                }),
          ),
        ],
      ),
    );
  }
}

class CustomSauceItem extends StatefulWidget {
  final ProductModel? sauce;

  const CustomSauceItem({super.key, required this.sauce});

  @override
  State<CustomSauceItem> createState() => _CustomSauceItemState();
}

class _CustomSauceItemState extends State<CustomSauceItem> {
  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ProductCubit>();
    bool aa = _bloc.positions.any((element) => element.uuid == widget.sauce?.uuid);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BC.beige,
        borderRadius: BRadius.r10,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sauce?.name ?? '',
                style: BS.bold18,
              ),
              Space.h8,
              Text(
                '${widget.sauce?.price ?? ' '} грн',
                style: BS.sb14,
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    'Додати продукт',
                    style: BS.sb14,
                  ),
                  Space.w8,
                  SelectedButton(
                    onTap: () {
                      _bloc.addSauce(widget.sauce);
                      setState(() {});
                    },
                    isSelected: _bloc.positions.any((element) => element.uuid == widget.sauce?.uuid),
                  )
                ],
              ),
              Space.h8,
              (aa) ? Row(
                children: [
                  Text(
                    'Обовязковй',
                    style: BS.sb14,
                  ),
                  Space.w8,
                  SelectedButton(
                    onTap: () {
                      _bloc.editSauce(widget.sauce?.uuid);
                      setState(() {});
                    },
                    isSelected: _bloc.positions.where((element) => element.uuid == widget.sauce?.uuid).first.required ?? false,
                  )
                ],
              ) : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
