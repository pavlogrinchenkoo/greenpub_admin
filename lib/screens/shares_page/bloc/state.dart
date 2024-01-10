import 'package:delivery/api/firestore_shared/dto.dart';

abstract class SharesState {}

class LoadingState extends SharesState {}

class LoadedState extends SharesState {
  final List<SharesModel> shares;

  LoadedState({required this.shares});
}

class ErrorState extends SharesState {}