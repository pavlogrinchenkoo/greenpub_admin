import 'dart:typed_data';

import 'package:auto_route/annotations.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/delivery_status_widget.dart';
import 'package:delivery/widgets/item_count_button.dart';
import 'package:delivery/widgets/order_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

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
                        return OrderItemWidget(
                          order: order!,
                          onTap: () => _bloc.selectOrder(index),
                        );
                      }),
                ),
              ),
              Expanded(
                flex: 2,
                child: DetailOrder(
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

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key, required this.order, this.onTap});

  final OrderModel order;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String price = '';
    if (order.price != null && order.discount != null) {
      price = (order.price!.toInt() - order.discount!.toInt()).toString();
    }

    final DateTime? dateTimeString = order.timeCreate == null
        ? null
        : DateFormat("yyyy-MM-dd HH:mm").parse(order.timeCreate!);
    final time = dateTimeString != null
        ? DateFormat('dd.MM.yyyy о HH:mm').format(dateTimeString)
        : '';

    final address = order.address;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: BC.white,
          borderRadius: BRadius.r10,
          boxShadow: BShadow.light,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Замовлення $time',
                style: BS.bold18,
              ),
              Space.h8,
              if (address != null && address.address != null)
                Text(address.address!, style: BS.sb14),
              Space.h16,
              Row(
                children: [
                  if (order.statusType != null)
                    DeliveryStatusWidget(
                      deliveryStatus: order.statusType!,
                    ),
                  const Spacer(),
                  if (order.price != null) OrderPriceWidget(price: price),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailOrder extends StatelessWidget {
  final OrderModel order;

  const DetailOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<OrdersCubit>();
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BC.white,
        borderRadius: BRadius.r10,
        boxShadow: BShadow.light,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Деталі замовлення', style: BS.bold18),
              const Spacer(),
              IconButton(
                onPressed: () => _bloc.saveOrder(order),
                icon: const Icon(Icons.save_alt_sharp),
              ),
            ],
          ),
          Space.h16,
          Text(
            'Номер замовлення: ${order.uid}',
            style: BS.bold16,
          ),
          Space.h8,
          Text(
            'Дата: ${order.timeCreate}',
          ),
          Space.h8,
          Text(
            'Користувач: ${order.userId}',
          ),
          Space.h8,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BRadius.r10,
              border: Border.all(
                color: BC.black,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Адреса: ${order.address?.address}',
                    ),
                    Space.h8,
                    Text(
                      'Квартира: ${order.address?.apartment}',
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Підїзд: ${order.address?.entrance}',
                    ),
                    Space.h8,
                    Text(
                      'Код домофону: ${order.address?.code}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Space.h8,
          Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BRadius.r10,
              border: Border.all(
                color: BC.black,
                width: 1,
              ),
            ),
            child: Text(
              'Коментар: ${order.comment}',
            ),
          ),
          Space.h8,
          Text(
            'Тип оплати',
            style: BS.light14.apply(color: BC.black),
          ),
          Space.h8,
          FormBuilderChoiceChip(
            onChanged: (value) => _bloc.selectPayType(value ?? ''),
            initialValue: order.payType,
            name: 'choice_chip',
            spacing: 16,
            runSpacing: 16,
            selectedColor: BC.white,
            backgroundColor: BC.grey,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            options: const [
              FormBuilderChipOption(
                value: 'Готівкою',
                child: Text('Готівкою'),
              ),
              FormBuilderChipOption(
                value: 'Картою',
                child: Text('Картою'),
              ),
              FormBuilderChipOption(
                value: 'Apple Pay',
                child: Text('Apple Pay'),
              ),
              FormBuilderChipOption(
                value: 'Google Pay',
                child: Text('Google Pay'),
              ),
            ],
          ),
          Space.h8,
          Text(
            'Тип доставки',
            style: BS.light14.apply(color: BC.black),
          ),
          Space.h8,
          FormBuilderChoiceChip(
            onChanged: (value) => _bloc.selectDeliveryType(value ?? ''),
            initialValue: order.deliveryType,
            name: 'choice_chip',
            spacing: 16,
            runSpacing: 16,
            selectedColor: BC.white,
            backgroundColor: BC.grey,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            options: const [
              FormBuilderChipOption(
                value: 'Курєром',
                child: Text('Курєром'),
              ),
              FormBuilderChipOption(
                value: 'Самовивіз',
                child: Text('Самовивіз'),
              ),
            ],
          ),
          Space.h8,
          Text(
            'Статус доставки',
            style: BS.light14.apply(color: BC.black),
          ),
          Space.h8,
          FormBuilderChoiceChip(
            onChanged: (value) => _bloc.selectDeliveryStatus(value ?? ''),
            initialValue: order.statusType,
            name: 'choice_chip',
            spacing: 16,
            runSpacing: 16,
            selectedColor: BC.white,
            backgroundColor: BC.grey,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            options: const [
              FormBuilderChipOption(
                value: 'moderation',
                child: Text('обробляється'),
              ),
              FormBuilderChipOption(
                value: 'delivering',
                child: Text('Доставляється'),
              ),
              FormBuilderChipOption(
                value: 'delivered',
                child: Text('Доставлено'),
              ),
              FormBuilderChipOption(
                value: 'cancelled',
                child: Text('Скасовано'),
              ),
            ],
          ),
          Space.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Кількість: ${order.items?.length}',
              ),
              Space.h8,
              Text(
                'Знижка: ${order.discount}₴',
              ),
              Space.h8,
              Text(
                'Загальна вартість: ${order.price}₴',
              ),
              Space.h8,
              Text(
                'Загальна вартість зі знижкою: ${order.totalPrice}₴',
              ),
              Space.h8,
              Text(
                'Товари:',
              ),
            ],
          ),
          Space.h8,
          Expanded(
            child: GridView.builder(
              itemCount: order.items?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
                mainAxisExtent: 250,
              ),
              itemBuilder: (item, index) {
                final item = order.items?[index];
                print(_bloc.images.length);
                return ProductItem(
                  product: item,
                  image: _bloc.images[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final ItemProduct? product;
  final Uint8List? image;

  const ProductItem({super.key, this.product, this.image});

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<OrdersCubit>();
    final item = product?.product;
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: BC.white,
          borderRadius: BRadius.r10,
          boxShadow: BShadow.light,
        ),
        child: Column(
          children: [
            (image != null)
                ? ClipRRect(
                    borderRadius: BRadius.r10,
                    child: Image.memory(
                      image!,
                      width: 100,
                      height: 100,
                    ),
                  )
                : Container(
                    width: 400,
                    height: 400,
                    color: BC.grey,
                  ),
            Space.h16,
            Text(
              item?.name ?? '',
              style: BS.bold18.apply(color: BC.black),
            ),
            Space.h8,
            Text(
              item?.description ?? '',
              style: BS.sb14.apply(color: BC.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            const Spacer(),
            Row(children: [
              Text(
                '${item?.price ?? 0}₴',
                style: BS.bold22.apply(color: BC.black),
              ),
            ])
          ],
        ));
  }
}
