import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/system/dto.dart';
import 'package:delivery/api/system/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/system_page/widgets/show_edit.dart';
import 'package:delivery/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class SystemCubit extends Cubit<SystemState> {
  final SystemApi _systemApi;

  SystemCubit(this._systemApi) : super(LoadingState());

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      final system = await _systemApi.getSystem();
      emit(LoadedState(
        system: system,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void showEdit(BuildContext context, SystemModel? system) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: BDuration.d500,
        pageBuilder: (pageContext, _, __) {
          return Material(
              child: ShowEdit(
            system: system,
          ));
        });
  }

  Future<void> saveSystem(BuildContext context, SystemModel system) async {
    try {
      await _systemApi.saveSystem(system);
      if (context.mounted) {
        context.router.pop();
        await init(context);
      }
    } catch (e) {
      print(e);
    }
  }
}
