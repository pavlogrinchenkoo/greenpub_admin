import 'package:auto_route/annotations.dart';
import 'package:delivery/screens/shares_page/bloc/bloc.dart';
import 'package:delivery/screens/shares_page/bloc/state.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SharesPage extends StatefulWidget {
  const SharesPage({super.key});

  @override
  State<SharesPage> createState() => _SharesPageState();
}

class _SharesPageState extends State<SharesPage> {
  late SharesCubit _bloc;
  @override
  void initState() {
    _bloc = context.read<SharesCubit>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body:
    BlocBuilder<SharesCubit, SharesState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return const Text('Loaded');
      }
      return const SizedBox();
    }));
  }
}
