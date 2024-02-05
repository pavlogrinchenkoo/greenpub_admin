import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_orders/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/statistics/widgets/show_modal.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final FirestoreOrdersApi firestoreOrdersApi;

  StatisticsCubit(this.firestoreOrdersApi) : super(LoadingState());

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      await getOrders('Cьогодні');
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getOrders(String date) async {
    List<OrderModel> orders = [];
    DateTime time = DateTime.now().subtract(const Duration(days: 1));
    if (date == 'Сьогодні') {
      time = DateTime.now().subtract(const Duration(days: 1));
    }
    if (date == 'Останні 7 днів') {
      time = DateTime.now().subtract(const Duration(days: 7));
    }
    if (date == 'Останні 15 днів') {
      time = DateTime.now().subtract(const Duration(days: 15));
    }
    if (date == 'Вчора') {
      orders = await firestoreOrdersApi.getElementsYesterday();
    } else {
      orders = await firestoreOrdersApi.getOrdersFilter(time);
    }
    print('orders: $orders');
    final sum = orders.fold(0.0,
        (previousValue, element) => previousValue + (element.totalPrice ?? 0));

    final card = orders
        .where((element) =>
            element.payType == 'Карткою при отримані' ||
            element.payType == 'Apple Pay' ||
            element.payType == 'Google Pay')
        .fold(
            0.0,
            (previousValue, element) =>
                previousValue + (element.totalPrice ?? 0));

    final cash = orders.where((element) => element.payType == 'Готівкою').fold(
        0.0,
        (previousValue, element) => previousValue + (element.totalPrice ?? 0));

    final cardLength = orders.where((element) =>
        element.payType == 'Карткою при отримані' ||
        element.payType == 'Apple Pay' ||
        element.payType == 'Google Pay');

    final cashLength = orders.where((element) => element.payType == 'Готівкою');

    final averageAll = orders.isNotEmpty ? sum / orders.length : 0.0;
    final averageCard = cardLength.isNotEmpty ? card / cardLength.length : 0.0;
    final averageCash = orders.isNotEmpty ? cash / cashLength.length : 0.0;

    double averageAllDouble = double.parse(averageAll.toStringAsFixed(2));
    double averageCardDouble = double.parse(averageCard.toStringAsFixed(2));
    double averageCashDouble = double.parse(averageCash.toStringAsFixed(2));
    double cashDouble = double.parse(cash.toStringAsFixed(2));
    double cardDouble = double.parse(card.toStringAsFixed(2));
    double sumDouble = double.parse(sum.toStringAsFixed(2));
    emit(LoadedState(
        sum: sumDouble,
        card: cardDouble,
        cash: cashDouble,
        averageAll: averageAllDouble,
        averageCard: averageCardDouble,
        averageCash: averageCashDouble,
        cardLength: cardLength.length,
        cashLength: cashLength.length,
        ordersLength: orders.length,
        orders: orders));
  }

  void showFilter(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const ShowModal();
        });
  }

  void getOrdersFilter(BuildContext context, String text) async {
    emit(LoadingState());
    await getOrders(text);
    if (context.mounted) {
      context.router.pop();
    }
  }
}
