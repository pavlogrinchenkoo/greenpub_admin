import 'package:delivery/api/firestore_orders/dto.dart';

abstract class OrdersState {}

class LoadingState extends OrdersState {}

class LoadedState extends OrdersState {
  final List<OrderModel>? order;

  LoadedState({this.order});
}

class ErrorState extends OrdersState {}
