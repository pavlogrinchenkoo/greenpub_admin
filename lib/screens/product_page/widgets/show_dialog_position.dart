import 'package:delivery/api/positions/dto.dart';
import 'package:delivery/screens/position_page/bloc/bloc.dart';
import 'package:delivery/screens/product_page/bloc/bloc.dart';
import 'package:delivery/screens/system_page/widgets/custom_container.dart';
import 'package:delivery/style.dart';
import 'package:delivery/widgets/selected_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowPosition extends StatefulWidget {
  final List<PositionGroupModel>? position;

  const ShowPosition({super.key, this.position});

  @override
  State<ShowPosition> createState() => _ShowPositionState();
}

class _ShowPositionState extends State<ShowPosition> {
  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ProductCubit>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [BackButton()],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.position?.length,
                itemBuilder: (context, index) {
                  final position = widget.position?[index];
                  final isSelected = _bloc.positions
                      .where((element) => element.uuid == position?.uuid)
                      .isNotEmpty;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BRadius.r10,
                      color: BC.beige,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text('${position?.name}', style: BS.bold18),
                          const Spacer(),
                          SelectedButton(
                            onTap: () {
                              if (isSelected) {
                                _bloc.removePosition(position?.name);
                              } else {
                                _bloc.addPosition(position);
                              }
                              setState(() {});
                            },
                            isSelected: isSelected ?? false,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
