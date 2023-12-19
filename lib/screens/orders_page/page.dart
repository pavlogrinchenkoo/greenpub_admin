import 'package:auto_route/annotations.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/state.dart';

@RoutePage()
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late OrdersCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<OrdersCubit>();
    _bloc.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
            body: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (!_bloc.isLoadMoreTriggered) {
                    _bloc.getOrders();
                    _bloc.isLoadMoreTriggered = true;
                  }
                } else {
                  _bloc.isLoadMoreTriggered = false;
                }
                return true;
              },
              child: ListView.builder(
                  itemCount: state.order?.length,
                  itemBuilder: (context, index) {
                    final order = state.order?[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),

                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: BC.black,
                              width: (index == (state.order?.length ?? 0) - 1)
                                  ? 1
                                  : 0,
                            ),
                            right: BorderSide(
                              color: BC.black,
                              width: 1,
                            ),
                            left: BorderSide(
                              color: BC.black,
                              width: 1,
                            ),
                            top: BorderSide(
                              color: BC.black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _bloc.goOrder(context, order?.uid ?? ''),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Адрес',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                                Space.h8,
                                Text(
                                  order?.address ?? '',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                              ],
                            ),
                            Space.w20,
                            Column(
                              children: [
                                Text(
                                  'Вартість',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                                Space.h8,
                                Text(
                                  '${order?.price ?? ' '}',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                              ],
                            ),
                            Space.w20,
                            Column(
                              children: [
                                Text(
                                  'Дата',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                                Space.h8,
                                Text(
                                  order?.timeCreate ?? '',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                              ],
                            ),
                            Space.w20,
                            Column(
                              children: [
                                Text(
                                  'Кількість',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                                Space.h8,
                                Text(
                                  '${order?.items?.length ?? 0}',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                              ],
                            ),
                            Space.w20,
                            Column(
                              children: [
                                Text(
                                  'Тип доставки',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                                Space.h8,
                                Text(
                                  order?.deliveryType ?? '',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                              ],
                            ),
                            Space.w20,
                            Column(
                              children: [
                                Text(
                                  'Тип оплати',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                                Space.h8,
                                Text(
                                  order?.payType ?? '',
                                  style: BS.light14.apply(color: BC.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ));
                  }),
            ));
      }
      return const SizedBox();
    });
  }
}
