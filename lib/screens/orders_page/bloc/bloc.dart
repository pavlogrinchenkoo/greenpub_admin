import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_orders/request.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/api/firestore_user/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final FirestoreUserApi firestoreApi;
  final FirestoreOrdersApi firestoreOrdersApi;
  final FirestoreProductApi firestoreProductApi;

  OrdersCubit(
      this.firestoreApi, this.firestoreOrdersApi, this.firestoreProductApi)
      : super(LoadingState());

  List<OrderModel> orders = [];
  bool isLoadMoreTriggered = false;
  int count = 0;
  int index = 0;
  List<Uint8List?> images = [];
  String payType = '';
  String deliveryStatus = '';
  String deliveryType = '';

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      final orders = await firestoreOrdersApi.getOrdersList(50);
      print(orders.length);
      this.orders.addAll(orders);
      getImage(orders.first.items ?? []);
      payType = orders.first.payType ?? '';
      deliveryStatus = orders.first.statusType ?? '';
      deliveryType = orders.first.deliveryType ?? '';
      emit(LoadedState(
        order: orders,
        selectedOrder: orders.first,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getImage(List<ItemProduct> products) async {
    emit(LoadingState());
    images.clear();
    for (int i = 0, length = products.length; i < length; i++) {
      final getImage = await firestoreProductApi.getImage(products[i].product?.image ?? '');
      images.add(getImage);
    }
  }

  selectOrder(int index) async {
    this.index = index;
    await getImage(orders[index].items ?? []);
    payType = orders[index].payType ?? '';
    deliveryStatus = orders[index].statusType ?? '';
    deliveryType = orders[index].deliveryType ?? '';
    emit(LoadedState(
      order: orders,
      selectedOrder: orders[index],
    ));
  }

  void saveOrder(OrderModel order) async {
    try {
      final uid = orders[index].uid;
      final newOrder = OrderModel(
        uid: uid,
        items: order.items,
        deliveryType: deliveryType,
        payType: payType,
        statusType: deliveryStatus,
        address: order.address,
        comment: order.comment,
        timeCreate: order.timeCreate,
        totalPrice: order.totalPrice,
        discount: order.discount,

      );
      await firestoreOrdersApi.editOrder(uid ?? '', newOrder);
      emit(LoadedState(
        order: orders,
        selectedOrder: orders[index],
      ));
    } catch (e) {
      emit(ErrorState());
    }

  }

  void selectDeliveryType(String type) {
    deliveryType = type;
  }

  void selectPayType(String type) {
    payType = type;
  }

  void selectDeliveryStatus(String type) {
    deliveryStatus = type;
  }

  Future<void> getOrders() async {
    try {
      if (count >= 50) {
        final orders = await firestoreOrdersApi.getOrdersList(50);
        this.orders.addAll(orders);
        emit(LoadedState(
          order: this.orders,
          selectedOrder: orders.first,
        ));
        count = orders.length;
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> goOrder(BuildContext context, String uid) async {
    if (context.mounted) context.router.push(OrderRoute(uid: uid));
  }
}
