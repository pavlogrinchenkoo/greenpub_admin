import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_orders/request.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api/firestore_user/request.dart';
import 'state.dart';

class OrderCubit extends Cubit<OrderState> {
  final FirestoreUserApi firestoreApi;
  final FirestoreOrdersApi firestoreOrdersApi;
  final FirestoreProductApi firestoreProductApi;

  OrderCubit(
      this.firestoreApi, this.firestoreOrdersApi, this.firestoreProductApi)
      : super(LoadingState());

  List<ItemProduct> items = [];
  OrderModel? order;
  String? payType;
  String? deliveryType;
  double? price;

  Future<void> init(BuildContext context, String uid) async {
    try {
      emit(LoadingState());
      final order = await firestoreOrdersApi.getOrderData(uid);
      items = order?.items ?? [];
      this.order = order;
      payType = order?.payType;
      deliveryType = order?.deliveryType;
      price = order?.price ?? 0;
      print(price);
      emit(LoadedState(
        order: order,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> updateOrder(
    BuildContext context, {
    String? uuid,
    String? userId,
    String? address,
    String? timeCreate,
  }) async {
    try {
      final order = OrderModel(
        uid: uuid,
        userId: userId,
        items: items,
        price: price,
        address: address,
        payType: payType,
        deliveryType: deliveryType,
        timeCreate: timeCreate,
      );
      print(order.items);
      print(order.price);
      await firestoreOrdersApi.editOrder(uuid ?? '', order);
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Зміни збережені', false);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Зміни не збережені', true);
      }
    }
  }

  Future<void> deleteOrder(BuildContext context, String uuid) async {
    await firestoreOrdersApi.deleteOrder(uuid);
    if (context.mounted) context.router.pop();
  }

  Future<void> delete(BuildContext context, String uuid) async {
    items.removeWhere((element) => element.uuid == uuid);
    emit(LoadedState(order: order));
  }

  void changePayType(String payType) {
    this.payType = payType;
  }

  void changeDeliveryType(String deliveryType) {
    this.deliveryType = deliveryType;
  }

  void sumPrice(double itemPrice, String uuid, int count) {
    print(itemPrice);
    price = price! + itemPrice;
    items.where((element) => element.uuid == uuid).first.count = count;
    emit(LoadedState(order: order));
  }

  void dispose() {
    items.clear();
    order = null;
    payType = null;
    deliveryType = null;
  }

  Future<void> goOrdersPage(BuildContext context) async {
    if (context.mounted) {
      context.router.pop().whenComplete(() => context.read<OrdersCubit>().init(context));
    }
  }
}
