import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_user/dto.dart';

abstract class OrderState {}

class LoadingState extends OrderState {}

class LoadedState extends OrderState {
  final OrderModel? order;

  LoadedState({this.order});
}

class ErrorState extends OrderState {}