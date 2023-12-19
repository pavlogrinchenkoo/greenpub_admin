import 'package:delivery/api/firestore_user/dto.dart';

abstract class UsersState {}

class LoadingState extends UsersState {}

class LoadedState extends UsersState {
  final List<UserModel>? users;

  LoadedState({this.users});
}

class ErrorState extends UsersState {}
