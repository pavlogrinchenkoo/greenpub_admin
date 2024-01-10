import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/delivery_status_widget.dart';
import 'package:delivery/widgets/order_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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