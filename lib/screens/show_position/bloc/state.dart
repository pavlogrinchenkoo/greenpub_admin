import 'package:delivery/api/firestore_product/dto.dart';

abstract class ShowPositionState {}

class LoadingState extends ShowPositionState {}

class LoadedState extends ShowPositionState {
  final List<ProductModel>? sauces;
  final List<ProductModelPosition>? positions;
  final PositionGroupModel? position;

  LoadedState( {required this.sauces, this.positions, this.position});
}

class ErrorState extends ShowPositionState {}