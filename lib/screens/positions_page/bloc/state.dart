import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/positions/dto.dart';

abstract class PositionsState {}

class LoadingState extends PositionsState {}

class LoadedState extends PositionsState {
  final List<PositionGroupModel> positionsList;

  LoadedState({required this.positionsList});
}

class ErrorState extends PositionsState {}