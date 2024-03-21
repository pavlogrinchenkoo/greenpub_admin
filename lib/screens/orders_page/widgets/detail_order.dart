import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_user/dto.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/screens/orders_page/widgets/product_item.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_choice_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DetailOrder extends StatelessWidget {
  final UserModel? user;
  final OrderModel order;

  const DetailOrder({super.key, required this.order, this.user});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OrdersCubit>();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BC.white,
        borderRadius: BRadius.r10,
        boxShadow: BShadow.light,
      ),
      child: ListView(
        children: [
          Row(
            children: [
              Text('Деталі замовлення', style: BS.bold18),
              const Spacer(),
              (!bloc.isEdit)
                  ? IconButton(
                      onPressed: () => bloc.startEdit(),
                      icon: const Icon(Icons.edit),
                    )
                  : IconButton(
                      onPressed: () => bloc.saveOrder(order, context),
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
            'Час доставки: ${order.deliveryTime}',
          ),
          Space.h8,
          Text(
            'Користувач: ${order.userId}',
          ),
          Space.h8,
          Row(
            children: [
              Text('Ім\'я: ${user?.firstName ?? ''}'),
              Space.w16,
              Text('Номер телефону: ${user?.phone ?? ''}'),
            ],
          ),

          Space.h8,
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BRadius.r10,
                    border: Border.all(
                      color: BC.black,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Адреса: ${order.address?.address}',
                      ),
                      Text(
                        'Квартира: ${order.address?.apartment}',
                      ),
                      Text(
                        'Підїзд: ${order.address?.entrance}',
                      ),
                      Text(
                        'Код домофону: ${order.address?.code}',
                      ),
                    ],
                  ),
                ),
              ),
              Space.w16,
              Expanded(
                child: Container(
                  height: 115,
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
              ),
            ],
          ),
          Space.h8,
          Text(
            'Тип оплати',
            style: BS.light14.apply(color: BC.black),
          ),
          Space.h8,
          CustomChoiceChip(children: [
            CustomItem(
              isSelected: bloc.payType == 'cache',
              text: 'Готівкою',
              onTap: () => bloc.selectPayType('cache'),
            ),
            CustomItem(
              isSelected: bloc.payType == 'payWithCard',
              text: 'Картою',
              onTap: () => bloc.selectPayType('payWithCard'),
            ),
            CustomItem(
              isSelected: bloc.payType == 'applePay',
              text: 'Apple Pay',
              onTap: () => bloc.selectPayType('applePay'),
            ),
            CustomItem(
              isSelected: bloc.payType == 'googlePay',
              text: 'Google Pay',
              onTap: () => bloc.selectPayType('googlePay'),
            ),
            CustomItem(
              isSelected: bloc.payType == 'transactionToCard',
              text: 'Траезакція на карту',
              onTap: () => bloc.selectPayType('transactionToCard'),
            ),
          ]),
          Space.h8,
          Text(
            'Тип доставки',
            style: BS.light14.apply(color: BC.black),
          ),
          Space.h8,
          CustomChoiceChip(children: [
            CustomItem(
              isSelected: bloc.deliveryType == 'delivery',
              text: 'Курєром',
              onTap: () => bloc.selectDeliveryType('delivery'),
            ),
            CustomItem(
              isSelected: bloc.deliveryType == 'pickup',
              text: 'Самовивіз',
              onTap: () => bloc.selectDeliveryType('pickup'),
            ),
          ]),
          Space.h8,
          Text(
            'Статус доставки',
            style: BS.light14.apply(color: BC.black),
          ),
          Space.h8,
          CustomChoiceChip(children: [
            CustomItem(
              isSelected: bloc.deliveryStatus == 'moderation',
              text: 'Обробляється',
              onTap: () =>
                  bloc.selectDeliveryStatus('moderation', order.uid, context),
            ),
            CustomItem(
              isSelected: bloc.deliveryStatus == 'delivering',
              text: 'Доставляється',
              onTap: () =>
                  bloc.selectDeliveryStatus('delivering', order.uid, context),
            ),
            CustomItem(
              isSelected: bloc.deliveryStatus == 'delivered',
              text: 'Доставлено',
              onTap: () =>
                  bloc.selectDeliveryStatus('delivered', order.uid, context),
            ),
            CustomItem(
              isSelected: bloc.deliveryStatus == 'cancelled',
              text: 'Скасовано',
              onTap: () =>
                  bloc.selectDeliveryStatus('cancelled', order.uid, context),
            ),
          ]),
          Space.h8,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Загальна вартість: ${order.price}₴',
                  ),
                  Space.h8,
                  Text(
                    'Загальна вартість зі знижкою: ${order.totalPrice}₴',
                  ),
                ],
              ),
              Space.w52,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Знижка: ${order.discount ?? 0}₴',
                  ),
                  Space.h8,
                  Text(
                    'Бали: ${order.countedPoints ?? 0}₴',
                  ),
                ],
              ),
              Space.w22,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Доставка: ${order.deliveryPrice ?? 0}₴',
                  ),
                ],
              ),
            ],
          ),
          Space.h8,
          Text(
            'Товари:',
            style: BS.sb14,
          ),
          Space.h8,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items?.length ?? 0,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              mainAxisExtent: 360,
            ),
            itemBuilder: (item, index) {
              final item = order.items?[index];
              print(bloc.images.length);
              return ProductItem(
                product: item,
                image: bloc.images[index]?.bytes,
              );
            },
          ),
          Space.h8,
          CustomButton(
            onTap: () => bloc.showAddProductModal(context),
            icon: Text(
              'Додати продукт',
              style: BS.bold14.apply(color: BC.white),
            ),
          ),
        ],
      ),
    );
  }
}
