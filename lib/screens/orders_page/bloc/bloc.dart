import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_orders/request.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/api/firestore_user/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final FirestoreUserApi firestoreApi;
  final FirestoreOrdersApi firestoreOrdersApi;
  final FirestoreProductApi firestoreProductApi;

  OrdersCubit(this.firestoreApi, this.firestoreOrdersApi, this.firestoreProductApi) : super(LoadingState());

  List<OrderModel> orders = [];
  bool isLoadMoreTriggered = false;
  int count = 0;

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      final orders = await firestoreOrdersApi.getOrdersList(50);
      print(orders.length);
      emit(LoadedState(
        order: orders,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getOrders() async {
    try {
      if(count >= 50) {
        final orders = await firestoreOrdersApi.getOrdersList(50);
        this.orders.addAll(orders);
        emit(LoadedState(
            order: this.orders
        ));
        count = orders.length;
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> goOrder(BuildContext context, String uid) async {
    if(context.mounted) context.router.push(OrderRoute(uid: uid));
  }
}
