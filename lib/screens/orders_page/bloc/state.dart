import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_user/dto.dart';

abstract class OrdersState {}

class LoadingState extends OrdersState {}

class LoadedState extends OrdersState {
  final List<OrderModel>? order;
  final OrderModel? selectedOrder;
  final UserModel? user;
  LoadedState({this.order, this.selectedOrder, this.user});
}

class ErrorState extends OrdersState {}
