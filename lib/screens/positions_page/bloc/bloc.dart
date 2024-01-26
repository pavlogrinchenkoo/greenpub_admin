import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/positions/dto.dart';
import 'package:delivery/api/positions/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/widgets/custom_show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class PositionsCubit extends Cubit<PositionsState> {
  final PositionApi positionApi;

  PositionsCubit(this.positionApi) : super(LoadingState());

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      await getPositions();
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getPositions() async {
    try {
      final positionsList = await positionApi.getPositionsList();
      emit(LoadedState(positionsList: positionsList));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void goEditPosition(BuildContext context, PositionGroupModel position) {
    if (context.mounted) {
      context.router.push(PositionRoute(position: position));
    }
  }

  void goAddPosition(BuildContext context) {
    if (context.mounted) {
      context.router.push(PositionRoute());
    }
  }

  void showDeleteDialog(BuildContext context, PositionGroupModel position) {
    if (context.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return CustomShowDialog(
              title: 'Видалити позицію?',
              content: 'Ви впевнені, що хочете видалити позицію?',
              buttonOne: 'Видалити',
              buttonTwo: 'Відмінити',
              onTapOne: () {
                removePosition(position);
                context.router.pop();
              },
              onTapTwo: () {
                context.router.pop();
              },
            );
          });
    }
  }

  void removePosition(PositionGroupModel position) async {
    try {
      await positionApi.deletePosition(position.uuid ?? '');
      await getPositions();
    } catch (e) {
      print(e);
    }
  }
}
