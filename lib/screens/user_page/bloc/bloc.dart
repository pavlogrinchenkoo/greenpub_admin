import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_user/dto.dart';
import 'package:delivery/api/firestore_user/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/users_page/bloc/bloc.dart';
import 'package:delivery/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class UserCubit extends Cubit<UserState> {
  final FirestoreUserApi firestoreApi;

  UserCubit(this.firestoreApi) : super(LoadingState());

  Future<void> init(BuildContext context, String? uid) async {
    try {
      emit(LoadingState());
      getUser(uid);

    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getUser(uid) async {
    final user = await firestoreApi.getUserData(uid ?? '');
    final image = await firestoreApi.getImage(user?.avatar ?? '');
    emit(LoadedState(user: user, image: image));
  }

  Future<void> editUser(BuildContext context, UserModel user) async {
    try {
      await firestoreApi.editUser(user);
      await getUser(user.uid);
     if(context.mounted) SnackBarService.showSnackBar(context, 'Користувача змінено', false);
    } on Exception catch (e) {
      if(context.mounted) SnackBarService.showSnackBar(context, e.toString(), true);
    }
  }

  Future<void> deleteUser(BuildContext context, String uid) async {
    try {
      await firestoreApi.deleteAccount(uid);
      if (context.mounted) {
        context.router.replaceAll([const UsersRoute()]);
      }
    } on Exception catch (e) {
      if(context.mounted) SnackBarService.showSnackBar(context, e.toString(), true);
    }
  }

  Future<void> goUsersPage(BuildContext context) async {
    if (context.mounted) {
      context.router.pop().whenComplete(() => context.read<UsersCubit>().init(context));
    }
  }
}
