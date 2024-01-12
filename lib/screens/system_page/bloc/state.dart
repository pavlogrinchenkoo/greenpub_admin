import 'package:delivery/api/system/dto.dart';

abstract class SystemState {}

class LoadingState extends SystemState {}

class LoadedState extends SystemState {
  final SystemModel? system;

  LoadedState({this.system});
}

class ErrorState extends SystemState {}