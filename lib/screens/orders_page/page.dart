import 'package:auto_route/annotations.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/state.dart';
import 'widgets/detail_order.dart';
import 'widgets/order_item_widget.dart';

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
        final order = state.order![_bloc.index];
        return CustomScaffold(
          body: Row(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    if (!_bloc.isLoadMoreTriggered) {
                      _bloc.getOrders();
                      _bloc.isLoadMoreTriggered = true;
                    }
                  } else {
                    _bloc.isLoadMoreTriggered = false;
                  }
                  return true;
                },
                child: Expanded(
                  flex: 1,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.order?.length,
                      itemBuilder: (context, index) {
                        final order = state.order?[index];
                        return Column(
                          children: [
                            OrderItemWidget(
                              order: order!,
                              onTap: () => _bloc.selectOrder(index),
                            ),
                            Space.h16,
                          ],
                        );
                      }),
                ),
              ),
              Expanded(
                flex: 2,
                child: DetailOrder(
                  user: state.user,
                  order: state.selectedOrder!,
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class CountContainer extends StatelessWidget {
  final int count;
  final Function() addCount;
  final Function() removeCount;

  const CountContainer(
      {super.key,
      required this.count,
      required this.addCount,
      required this.removeCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: BC.green.withOpacity(0.5),
        borderRadius: BRadius.r10,
      ),
      child: Row(children: [
        Expanded(
            child: InkWell(
                onTap: addCount,
                child: const Icon(
                  Icons.add,
                  size: 16,
                ))),
        const Spacer(),
        Text('$count', style: BS.sb14.apply(color: BC.black)),
        const Spacer(),
        Expanded(
            child: InkWell(
                onTap: removeCount,
                child: const Icon(
                  Icons.remove,
                  size: 16,
                ))),
      ]),
    );
  }
}

class CustomPrice extends StatelessWidget {
  final double price;
  final double oldPrice;

  const CustomPrice({super.key, required this.price, required this.oldPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (oldPrice == 0)
            ? Text(
                '$price₴',
                style: BS.bold22.apply(color: BC.black),
              )
            : const SizedBox(),
        (oldPrice > 0)
            ? Text(
                '$price₴',
                style: BS.bold22.apply(color: BC.red),
              )
            : const SizedBox(),
        (oldPrice > 0)
            ? Text(
                '$oldPrice₴',
                style: BS.bold16
                    .apply(color: BC.black)
                    .apply(decoration: TextDecoration.lineThrough),
              )
            : const SizedBox(),
      ],
    );
  }
}
