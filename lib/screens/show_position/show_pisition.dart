import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/screens/product_page/bloc/bloc.dart';
import 'package:delivery/screens/product_page/widgets/position_item.dart';
import 'package:delivery/screens/show_position/bloc/bloc.dart';
import 'package:delivery/screens/show_position/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:delivery/widgets/selected_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowPosition extends StatefulWidget {
  final PositionGroupModel? positionGroup;
  const ShowPosition({super.key,  this.positionGroup});

  @override
  State<ShowPosition> createState() => _ShowPositionState();
}

class _ShowPositionState extends State<ShowPosition> {
  late ShowPositionCubit _bloc;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _bloc = context.read<ShowPositionCubit>();
    _bloc.init(widget.positionGroup, controller);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ShowPositionCubit>();
    return BlocBuilder<ShowPositionCubit, ShowPositionState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const CustomIndicator();
        }
        if (state is LoadedState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    BackButton(
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: controller,
                              enabled: true,
                              text: 'Назва групи',
                            ),
                            Space.h16,
                            Row(
                              children: [
                                SizedBox(
                                    width: 85,
                                    child:
                                    SelectedButton(isSelected: _bloc.required, onTap: () => _bloc.editPosition())),
                                Space.w22,
                                CustomButton(
                                  onTap: () => _bloc.savePosition(controller.text, context),
                                  icon: Text(
                                    'Додати',
                                    style: BS.sb14.apply(color: BC.white),
                                  ),
                                )
                              ],
                            ),
                            Space.h16,
                            Expanded(
                              child: ListView.builder(
                                  itemCount: _bloc.positions?.length,
                                  itemBuilder: (context, index) {
                                    return CustomSauceItem(
                                      position: _bloc.positions?[index],
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      Space.w16,
                      Expanded(
                        child: ListView.builder(
                            itemCount: state.sauces?.length,
                            itemBuilder: (context, index) {
                              final sauce = state.sauces?[index];
                              return _CustomSauceItem(
                                sauce: sauce,
                                text: 'Додати продукт',
                                isSelected: _bloc.positions?.any((element) =>
                                element.uuid == sauce?.uuid) ?? false,
                                onTap: () {
                                  _bloc.addSauce(sauce);
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      }
    );

  }
}

class _CustomSauceItem extends StatefulWidget {
  final Function() onTap;
  final bool isSelected;
  final String text;
  final ProductModel? sauce;

  const _CustomSauceItem(
      {super.key,
      required this.sauce,
      required this.onTap,
      required this.isSelected,
      required this.text});

  @override
  State<_CustomSauceItem> createState() => _CustomSauceItemState();
}

class _CustomSauceItemState extends State<_CustomSauceItem> {
  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ProductCubit>();
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
                    widget.text,
                    style: BS.sb14,
                  ),
                  Space.w8,
                  SelectedButton(
                      onTap: widget.onTap, isSelected: widget.isSelected),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
