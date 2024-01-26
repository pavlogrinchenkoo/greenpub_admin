import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/positions/dto.dart';

abstract class PositionState {}

class LoadingState extends PositionState {}

class LoadedState extends PositionState {
  final List<ProductModel>? sauces;
  final List<ProductModelPosition>? positions;
  final PositionGroupModel? position;

  LoadedState({ this.sauces,  this.positions,  this.position});
}

class ErrorState extends PositionState {}