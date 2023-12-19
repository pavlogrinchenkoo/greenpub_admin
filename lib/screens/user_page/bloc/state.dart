import 'package:delivery/api/firestore_user/dto.dart';
import 'package:flutter/services.dart';

abstract class UserState {}

class LoadingState extends UserState {}

class LoadedState extends UserState {
  final UserModel? user;
  final Uint8List? image;

  LoadedState({this.user, this.image});
}

class ErrorState extends UserState {}
