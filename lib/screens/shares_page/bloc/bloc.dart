import 'package:auto_route/auto_route.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class SharesCubit extends Cubit<SharesState> {
  SharesCubit() : super(LoadingState());

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      emit(LoadedState());
    } catch (e) {
      emit(ErrorState());
    }
  }
}