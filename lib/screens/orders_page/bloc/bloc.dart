import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_orders/request.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/api/firestore_user/dto.dart';
import 'package:delivery/api/firestore_user/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/orders_page/widgets/show_product/show_product.dart';
import 'package:delivery/widgets/custom_show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool isEdit = false;
  int count = 51;
  int index = 0;
  List<ImageModel?> images = [];
  String payType = '';
  String deliveryStatus = '';
  String deliveryType = '';
  UserModel? user;

  Future<void> init(BuildContext context, {int selectedIndex = 0}) async {
    try {
      emit(LoadingState());
      final orders = await firestoreOrdersApi.getOrdersList(50);
      this.orders = [...orders];

      payType = orders.first.payType ?? '';
      deliveryStatus = orders.first.statusType ?? '';
      deliveryType = orders.first.deliveryType ?? '';
      await getImage(orders.first.items ?? []);
      await getUser(selectedIndex);
      emit(LoadedState(
        order: orders,
        selectedOrder: orders[selectedIndex],
        user: user,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getUser(int index) async {
    final user = await firestoreApi.getUserData(orders[index].userId ?? '');
    this.user = user;
  }

  void showAddProductModal(BuildContext context) async {
    if (isEdit) {
      if (context.mounted) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: 'Products',
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, _, __) {
            return const Material(child: ShowProduct());
          },
        );
      }
    }
  }

  void startEdit() {
    isEdit = true;
    emit(LoadedState(
      order: orders,
      selectedOrder: orders[index],
    ));
  }

  Future<void> getImage(List<ItemProduct> products) async {
    emit(LoadingState());
    images.clear();
    for (int i = 0, length = products.length; i < length; i++) {
      final getImage =
          await firestoreProductApi.getImage(products[i].product?.image ?? '');
      final image = ImageModel(
        path: products[i].product?.image ?? '',
        bytes: getImage,
      );
      images.add(image);
    }
  }

  selectOrder(int index) async {
    this.index = index;
    await getImage(orders[index].items ?? []);
    payType = orders[index].payType ?? '';
    deliveryStatus = orders[index].statusType ?? '';
    deliveryType = orders[index].deliveryType ?? '';
    await getUser(index);
    emit(LoadedState(
      order: orders,
      selectedOrder: orders[index],
      user: user,
    ));
  }

  Future<void> addPoints() async {
    final order = orders[index];
    if (deliveryStatus == 'delivered') {
      final items = order.items
          ?.where((element) =>
              element.product?.oldPrice == null ||
              element.product?.oldPrice == 0)
          .toList();
      final price = items?.fold(0.0, (previousValue, element) {
        return previousValue + (element.product?.price ?? 0);
      });

      if (deliveryType == 'Курєром') {
        print(price);
        final points = (price ?? 0) * 0.05;
        print(points);
        final priceInPoints = points.toInt();
        await firestoreApi.editPoints(user?.uid ?? '', priceInPoints);
      } else {
        final points = (price ?? 0) * 0.1;
        final priceInPoints = points.toInt() ?? 0;
        await firestoreApi.editPoints(user?.uid ?? '', priceInPoints);
      }
      await firestoreApi.editPointsRemove(
          user?.uid ?? '', order.countedPoints?? 0);
    }
  }

  void saveOrder(OrderModel order, BuildContext context) async {
    try {
      await endEdit();
      final uid = order.uid;
      print(order.deliveryPrice);
      final totalPrice = (order.totalPrice ?? 0) + (order.deliveryPrice ?? 0);
      print(totalPrice);
      // final deliveryType = order.deliveryType ?? '';
      final newOrder = OrderModel(
        uid: uid,
        userId: order.userId,
        items: order.items,
        deliveryType: deliveryType,
        payType: payType,
        statusType: deliveryStatus,
        address: order.address,
        comment: order.comment,
        timeCreate: order.timeCreate,
        totalPrice: totalPrice,
        discount: order.discount,
        price: order.price,
        countedPoints: order.countedPoints,
        deliveryPrice: order.deliveryPrice,
      );

      await firestoreOrdersApi.editOrder(uid ?? '', newOrder);
      isEdit = false;
      if (context.mounted) init(context, selectedIndex: index);
    } catch (e) {
      emit(ErrorState());
    }
  }

  // void saveStatus(OrderModel order, String status) async {}

  void selectDeliveryType(String type) {
    if (isEdit) {
      deliveryType = type;
      emit(LoadedState(
        order: orders,
        selectedOrder: orders[index],
      ));
    }
  }

  void selectPayType(String type) {
    if (isEdit) {
      payType = type;
      emit(LoadedState(
        order: orders,
        selectedOrder: orders[index],
      ));
    }
  }

  void selectDeliveryStatus(
      String type, String? uuid, BuildContext context) async {
    if (isEdit) {
      showDialog(
          context: context,
          builder: (context) => CustomShowDialog(
                title: 'Ви хочете поміняти статус?',
                buttonOne: 'Так',
                buttonTwo: 'Ні',
                onTapOne: () async {
                  await firestoreOrdersApi.editStatus(uuid ?? '', type);
                  deliveryStatus = type;
                  if (context.mounted) context.router.pop();
                  emit(LoadedState(
                    order: orders,
                    selectedOrder: orders[index],
                  ));
                  addPoints();
                },
                onTapTwo: () {
                  context.router.pop();
                },
              ));
    }
  }

  Future<void> getOrders() async {
    try {
      if (count >= 49) {
        final orders = await firestoreOrdersApi.getOrdersList(50);
        this.orders.addAll([...orders]);
        emit(LoadedState(
          order: this.orders,
          selectedOrder: orders.first,
        ));
        count = orders.length;
        print(count);
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

  void addCount(ItemProduct? product) {
    if (isEdit) {
      product?.count = product.count! + 1;
      final order = orders[index];
      order.totalPrice = order.totalPrice! + (product?.product?.price ?? 0);
      if (product?.product?.oldPrice != null &&
          product?.product?.oldPrice != 0) {
        order.price = order.price! + (product?.product?.oldPrice ?? 0);
        order.discount = order.discount! +
            (product?.product?.oldPrice ?? 0) -
            (product?.product?.price ?? 0);
      } else {
        order.price = order.price! + (product?.product?.price ?? 0);
      }

      emit(LoadedState(
        order: orders,
        selectedOrder: orders[index],
      ));
    }
  }

  void removeCount(ItemProduct? product) {
    if (isEdit) {
      if (product?.count == 1) {
        product?.count = product.count! - 1;
        final order = orders[index];
        order.totalPrice = order.totalPrice! - (product?.product?.price ?? 0);
        if (product?.product?.oldPrice != null &&
            product?.product?.oldPrice != 0) {
          order.price = order.price! - (product?.product?.oldPrice ?? 0);
          final n = (product?.product?.oldPrice ?? 0) -
              (product?.product?.price ?? 0);
          order.discount = order.discount! - n;
        } else {
          order.price = order.price! - (product?.product?.price ?? 0);
        }
        order.items?.removeWhere(
            (element) => element.product?.uuid == product?.product?.uuid);
        images
            .removeWhere((element) => element?.path == product?.product?.image);
      } else {
        product?.count = product.count! - 1;
        final order = orders[index];
        order.totalPrice = order.totalPrice! - (product?.product?.price ?? 0);
        if (product?.product?.oldPrice != null &&
            product?.product?.oldPrice != 0) {
          order.price = order.price! - (product?.product?.oldPrice ?? 0);
          final n = (product?.product?.oldPrice ?? 0) -
              (product?.product?.price ?? 0);
          order.discount = order.discount! - n;
        } else {
          order.price = order.price! - (product?.product?.price ?? 0);
        }
      }
      emit(LoadedState(
        order: orders,
        selectedOrder: orders[index],
      ));
    }
  }

  Future<void> goOrder(BuildContext context, String uid) async {
    if (context.mounted) context.router.push(OrderRoute(uid: uid));
  }

  Future<void> addProduct(
      List<ItemProduct> products, BuildContext context) async {
    if (isEdit) {
      double totalPrice = 0;
      double discount = 0;
      double price = 0;
      for (final product in products) {
        final existingProduct = orders[index]
            .items
            ?.any((element) => element.product?.uuid == product.product?.uuid);
        if (existingProduct == true) {
          final produ = products.where(
              (element) => element.product?.uuid == product.product?.uuid);
          final orderProduct = orders[index].items?.where(
              (element) => element.product?.uuid == product.product?.uuid);
          final count =
              (orderProduct?.first.count ?? 0) + (produ.first.count ?? 0);
          orders[index]
              .items
              ?.where(
                  (element) => element.product?.uuid == product.product?.uuid)
              .first
              .count = count;
        } else {
          orders[index].items?.add(product);
          final getImage =
              await firestoreProductApi.getImage(product.product?.image ?? '');
          final image = ImageModel(
            path: product.product?.image ?? '',
            bytes: getImage
          );
          images.add(image);
        }
        for (final product in products) {
          final sumPrice = product.count! * (product.product?.price ?? 0);
          totalPrice = totalPrice + sumPrice;
          if (product.product?.oldPrice != null &&
              product.product?.oldPrice != 0) {
            final oldPrice = product.count! * (product.product?.oldPrice ?? 0);
            price = price + oldPrice;
            discount = price - totalPrice;
          } else {
            price = price + sumPrice;
          }
        }
      }
      final order = orders[index];
      order.totalPrice = (order.totalPrice ?? 0) + totalPrice;
      order.price = (order.price ?? 0) + price;
      order.discount = (order.discount ?? 0) + discount;
      emit(LoadedState(
        order: orders,
        selectedOrder: orders[index],
      ));
    }
  }

  Future<void> endEdit() async {
    if (isEdit) {
      final order = orders[index];
      double orderTotalPrice = 0;
      double price = 0;
      double discount = 0;
      double totalDiscount = 0;
      final spentPoints = order.countedPoints;
      for (final ItemProduct product in order.items ?? []) {
        final totalPrice = (product.count ?? 0) * (product.product?.priceWithOptions ?? 0);
        final totalPriceDiscount = (product.count ?? 0) * (product.product?.price ?? 0);
        orderTotalPrice = orderTotalPrice + totalPrice;
        totalDiscount = totalDiscount + totalPriceDiscount;
        if (product.product?.oldPrice != null &&
            product.product?.oldPrice != 0) {
          final oldPrice =
              (product.count ?? 0) * (product.product?.oldPrice ?? 0);
          price = price + oldPrice;
        } else {
          price = price + totalPrice;
          print('price $price');
        }
      }
      orderTotalPrice = orderTotalPrice - (spentPoints ?? 0);
      discount = price - totalDiscount;
      if (deliveryType == 'Самовивіз') {
        orderTotalPrice = orderTotalPrice;
        discount = price - orderTotalPrice;
      }

      order.price = double.parse(price.toStringAsFixed(2));
      order.totalPrice = double.parse(orderTotalPrice.toStringAsFixed(2));
      order.discount = double.parse(discount.toStringAsFixed(2));
      emit(LoadedState(
        order: orders,
        selectedOrder: orders[index],
      ));
    }
  }
}
