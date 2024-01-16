import 'package:delivery/api/firestore_orders/dto.dart';

abstract class StatisticsState {}

class LoadingState extends StatisticsState {}

class LoadedState extends StatisticsState {
  final double sum;
  final double card;
  final double cash;
  final double averageAll;
  final double averageCard;
  final double averageCash;
  final int cardLength;
  final int cashLength;
  final int ordersLength;
  final List<OrderModel> orders;

  LoadedState({required this.sum, required this.card, required this.cash, required this.orders, required this.averageAll, required this.averageCard, required this.averageCash, required this.cardLength, required this.cashLength, required this.ordersLength});
}

class ErrorState extends StatisticsState {}