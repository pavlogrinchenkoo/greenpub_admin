import 'package:auto_route/annotations.dart';
import 'package:delivery/screens/system_page/bloc/bloc.dart';
import 'package:delivery/screens/system_page/bloc/state.dart';
import 'package:delivery/screens/system_page/widgets/custom_container.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SystemPage extends StatefulWidget {
  const SystemPage({super.key});

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  @override
  void initState() {
    context.read<SystemCubit>().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<SystemCubit>();
    return BlocBuilder<SystemCubit, SystemState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                 CustomContainer(
                  title: 'Час роботи: ',
                  value: '${state.system?.startTime} - ${state.system?.endTime}',
                ),
                Space.h16,
                 CustomContainer(
                  title: 'Кількість за км: ',
                  value: '${state.system?.deliveryPrice} грн ',
                ),
                Space.h16,
                Row(
                  children: [
                    CustomButton(
                      onTap: () => _bloc.showEdit(context, state.system),
                      icon: Text(
                        'Редагувати',
                        style: BS.bold18.apply(color: BC.beige),
                      ),
                    ),
                    Space.w22,
                    CustomButton(
                      onTap: () => _bloc.showModal(context),
                      icon: Text(
                        'Пуш Повідомлення',
                        style: BS.bold18.apply(color: BC.beige),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}
