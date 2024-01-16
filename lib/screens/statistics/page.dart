import 'package:auto_route/annotations.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/bloc.dart';
import 'bloc/state.dart';

@RoutePage()
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    context.read<StatisticsCubit>().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<StatisticsCubit>();
    return BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
          body: Row(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return _CustomContainer(order: order);
                    }),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BC.white,
                    borderRadius: BRadius.r10,
                    boxShadow: BShadow.light,
                  ),
                  child: ListView(
                    children: [
                      Text('Кількість замовлень', style: BS.bold16),
                      Space.h8,
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Готівкою',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.cashLength}',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                          Space.w16,
                          Column(
                            children: [
                              Text(
                                'Карткою',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.cardLength}',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                          Space.w16,
                          Column(
                            children: [
                              Text(
                                'Всього',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.ordersLength}',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Space.h16,
                      Text('Середня вартість замовлення', style: BS.bold16),
                      Space.h8,
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Готівкою',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.averageCash} грн.',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                          Space.w16,
                          Column(
                            children: [
                              Text(
                                'Карткою',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.averageCard} грн.',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                          Space.w16,
                          Column(
                            children: [
                              Text(
                                'Всього',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.averageAll} грн.',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Space.h16,
                      Text('Загальна сума продажів', style: BS.bold16),
                      Space.h8,
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Готівкою',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.cash} грн.',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                          Space.w16,
                          Column(
                            children: [
                              Text(
                                'Карткою',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.card} грн.',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                          Space.w16,
                          Column(
                            children: [
                              Text(
                                'Всього',
                                style: BS.bold16,
                              ),
                              Text(
                                '${state.sum} грн.',
                                style: BS.sb14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: InkWell(
            onTap: () => _bloc.showFilter(context),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration:
                  BoxDecoration(borderRadius: BRadius.r10, color: BC.black),
              child: Text('Фільтрувати',
                  style: BS.bold18.copyWith(
                    color: BC.white,
                  )),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class _CustomContainer extends StatelessWidget {
  final OrderModel order;

  const _CustomContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final DateTime? dateTimeString = order.timeCreate == null
        ? null
        : DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSS')
            .parse(order.timeCreate ?? '');
    final time = dateTimeString != null
        ? DateFormat('dd.MM о HH:mm').format(dateTimeString)
        : '';

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: BC.white,
        borderRadius: BRadius.r10,
        boxShadow: BShadow.light,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Дата',
                style: BS.bold16,
              ),
              Space.h8,
              Text(
                time,
                style: BS.sb14,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Вартість замовлення',
                style: BS.bold16,
              ),
              Space.h8,
              Text(
                order.totalPrice.toString() ?? '',
                style: BS.sb14,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Спосіб оплати',
                style: BS.bold16,
              ),
              Space.h8,
              Text(
                order.payType ?? '',
                style: BS.sb14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
