import 'package:auto_route/auto_route.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoadingState());

  Future<void> init() async {
    try {
      emit(LoadingState());
      emit(LoadedState());
    } catch (e) {
      emit(ErrorState());
    }
  }

  void goUsers(BuildContext context) {
    if(context.mounted) {
      context.router.push(const SideBarRoute());
    }
  }
}