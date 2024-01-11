import 'package:auto_route/auto_route.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class SystemCubit extends Cubit<SystemState> {
  SystemCubit() : super(LoadingState());

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      emit(LoadedState());
    } catch (e) {
      emit(ErrorState());
    }
  }

  // void showEdit(BuildContext context) {
  //   showGeneralDialog(context: context, pageBuilder: (pageContext, _, __)  {
  //
  //   });
  // }


}