import 'package:auto_route/auto_route.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(LoadingState());

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      emit(LoadedState());
      if(context.mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    } catch (e) {
      emit(ErrorState());
    }
  }


}