import 'package:auto_route/annotations.dart';
import 'package:delivery/screens/users_page/bloc/bloc.dart';
import 'package:delivery/screens/users_page/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    context.read<UsersCubit>().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<UsersCubit>();
    return BlocBuilder<UsersCubit, UsersState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
            body: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (!_bloc.isLoadMoreTriggered) {
                    _bloc.getUsers();
                    _bloc.isLoadMoreTriggered = true;
                  }
                } else {
                  _bloc.isLoadMoreTriggered = false;
                }
                return true;
              },
              child: ListView.builder(
                  itemCount: state.users?.length,
                  itemBuilder: (context, index) {
                    final user = state.users?[index];
                    return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: BC.black,
                              width:
                                  (index == (state.users?.length ?? 0) - 1) ? 1 : 0,
                            ),
                            right: BorderSide(
                              color: BC.black,
                              width: 1,
                            ),
                            left: BorderSide(
                              color: BC.black,
                              width: 1,
                            ),
                            top: BorderSide(
                              color: BC.black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _bloc.goHome(context, user?.uid),
                          child: ListTile(
                              title: Text(
                                user?.firstName ?? '',
                                style: BS.bold14.apply(color: BC.black),
                              ),
                              subtitle: Text(
                                user?.phone ?? '',
                                style: BS.light14.apply(color: BC.black),
                              )),
                        ));
                  }),
            ));
      }
      return const SizedBox();
    });
  }
}
