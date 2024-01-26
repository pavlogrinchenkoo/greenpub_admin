import 'package:auto_route/annotations.dart';
import 'package:delivery/style.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'bloc/state.dart';

@RoutePage()
class PositionsPage extends StatefulWidget {
  const PositionsPage({super.key});

  @override
  State<PositionsPage> createState() => _PositionsPageState();
}

class _PositionsPageState extends State<PositionsPage> {
  @override
  void initState() {
    context.read<PositionsCubit>().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<PositionsCubit>();
    return BlocBuilder<PositionsCubit, PositionsState>(
        builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
          body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.positionsList.length,
              itemBuilder: (context, index) {
                final position = state.positionsList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BRadius.r10,
                    color: BC.white,
                  ),
                  child: InkWell(
                    borderRadius: BRadius.r10,
                    onTap: () => _bloc.goEditPosition(context, position),
                    child: Row(
                      children: [
                        Text(position.name ?? '', style: BS.bold18),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _bloc.showDeleteDialog(context, position);
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          floatingActionButton: InkWell(
            onTap: () => _bloc.goAddPosition(context),
            borderRadius: BRadius.r16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration:
                  BoxDecoration(color: BC.black, borderRadius: BRadius.r16),
              child: Text(
                'Додати позицію',
                style: BS.bold20.apply(color: BC.white),
              ),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}
