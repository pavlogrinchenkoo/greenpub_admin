import 'package:auto_route/annotations.dart';
import 'package:delivery/screens/system_page/bloc/bloc.dart';
import 'package:delivery/screens/system_page/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: BC.white,
                    borderRadius: BRadius.r16,
                    boxShadow: BShadow.light,
                  ),
                  child: Row(
                    children: [
                      Text('Час роботи: ', style: BS.bold18),
                      Text(
                        '09:00 - 18:00 ',
                        style: BS.bold18,
                      ),
                      const Spacer(),
                      InkWell(onTap: () {}, child: const Icon(Icons.edit)),
                    ],
                  ),
                ),
                Space.h16,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: BC.white,
                    borderRadius: BRadius.r16,
                    boxShadow: BShadow.light,
                  ),
                  child: Row(
                    children: [
                      Text('Кількість грн за км: ', style: BS.bold18),
                      Text(
                        '30 грн ',
                        style: BS.bold18,
                      ),
                      const Spacer(),
                      InkWell(onTap: () {}, child: const Icon(Icons.edit)),
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
