import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_user/dto.dart';
import 'package:delivery/api/firestore_user/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class UsersCubit extends Cubit<UsersState> {
  final FirestoreUserApi firestoreApi;

  UsersCubit(this.firestoreApi) : super(LoadingState());

  List<UserModel> users = [];
  bool isLoadMoreTriggered = false;
  int count = 0;

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      final userList = await firestoreApi.getUsersList(50);
      emit(LoadedState(users: userList));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getUsers() async {
    try {
      if(count >= 50) {
        final userList = await firestoreApi.getUsersList(50);
        users.addAll(userList);
        emit(LoadedState(
            users: users
        ));
        count = userList.length;
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

  void goHome(BuildContext context, String? uid) {
    if (context.mounted) {
      context.router.push(UserRoute(uid: uid));
    }
  }
}
