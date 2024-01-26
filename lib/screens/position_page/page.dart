import 'package:auto_route/annotations.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/positions/dto.dart';
import 'package:delivery/screens/product_page/bloc/bloc.dart';
import 'package:delivery/screens/product_page/widgets/position_item.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_appbar.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:delivery/widgets/selected_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'bloc/state.dart';

@RoutePage()
class PositionPage extends StatefulWidget {
  final PositionGroupModel? position;

  const PositionPage({super.key, this.position});

  @override
  State<PositionPage> createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> {
  late PositionCubit _bloc;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _bloc = context.read<PositionCubit>();
    _bloc.init(widget.position, controller);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<PositionCubit>();
    return BlocBuilder<PositionCubit, PositionState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
          appBar: CustomAppBar(
            text: state.position?.name ?? 'Додати позицію',
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                            CustomButton(
                              onTap: () =>
                                  _bloc.savePosition(controller.text, context),
                              icon: Text(
                                'Додати',
                                style: BS.sb14.apply(color: BC.white),
                              ),
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
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) => _bloc.searchProduct(value),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Пошук',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: BC.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            Space.h16,
                            Expanded(
                              child: ListView.builder(
                                  itemCount: state.sauces?.length,
                                  itemBuilder: (context, index) {
                                    final sauce = state.sauces?[index];
                                    return _CustomSauceItem(
                                      sauce: sauce,
                                      text: 'Додати продукт',
                                      isSelected: _bloc.positions?.any(
                                              (element) =>
                                                  element.uuid ==
                                                  sauce?.uuid) ??
                                          false,
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
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox();
    });
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
        color: BC.white,
        borderRadius: BRadius.r10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.sauce?.name ?? '',
                        style: BS.bold18,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Space.h8,
                Text(
                  '${widget.sauce?.price ?? ' '} грн',
                  style: BS.sb14,
                ),
              ],
            ),
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
