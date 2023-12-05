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
}