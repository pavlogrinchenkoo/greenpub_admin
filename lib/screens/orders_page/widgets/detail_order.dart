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
    final _bloc = context.read<OrdersCubit>();
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
              (!_bloc.isEdit)
                  ? IconButton(
                      onPressed: () => _bloc.startEdit(),
                      icon: const Icon(Icons.edit),
                    )
                  : IconButton(
                      onPressed: () => _bloc.saveOrder(order, context),
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
              isSelected: _bloc.payType == 'Готівкою',
              text: 'Готівкою',
              onTap: () => _bloc.selectPayType('Готівкою'),
            ),
            CustomItem(
              isSelected: _bloc.payType == 'Карткою при отримані',
              text: 'Картою',
              onTap: () => _bloc.selectPayType('Карткою при отримані'),
            ),
            CustomItem(
              isSelected: _bloc.payType == 'Apple Pay',
              text: 'Apple Pay',
              onTap: () => _bloc.selectPayType('Apple Pay'),
            ),
            CustomItem(
              isSelected: _bloc.payType == 'Google Pay',
              text: 'Google Pay',
              onTap: () => _bloc.selectPayType('Google Pay'),
            ),
          ]),
          // FormBuilderChoiceChip(
          //   onChanged: (value) => _bloc.selectPayType(value ?? ''),
          //   initialValue: order.payType,
          //   name: 'choice_chip',
          //   spacing: 16,
          //   runSpacing: 16,
          //   selectedColor: BC.white,
          //   backgroundColor: BC.grey,
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //   ),
          //   options: const [
          //     FormBuilderChipOption(
          //       value: 'Готівкою',
          //       child: Text('Готівкою'),
          //     ),
          //     FormBuilderChipOption(
          //       value: 'Карткою при отримані',
          //       child: Text('Картою'),
          //     ),
          //     FormBuilderChipOption(
          //       value: 'Apple Pay',
          //       child: Text('Apple Pay'),
          //     ),
          //     FormBuilderChipOption(
          //       value: 'Google Pay',
          //       child: Text('Google Pay'),
          //     ),
          //   ],
          // ),
          Space.h8,
          Text(
            'Тип доставки',
            style: BS.light14.apply(color: BC.black),
          ),
          Space.h8,
          CustomChoiceChip(children: [
            CustomItem(
              isSelected: _bloc.deliveryType == 'Курєром',
              text: 'Курєром',
              onTap: () => _bloc.selectDeliveryType('Курєром'),
            ),
            CustomItem(
              isSelected: _bloc.deliveryType == 'Самовивіз',
              text: 'Самовивіз',
              onTap: () => _bloc.selectDeliveryType('Самовивіз'),
            ),
          ]),
          // FormBuilderChoiceChip(
          //   onChanged: (value) => _bloc.selectDeliveryType(value ?? ''),
          //   initialValue: order.deliveryType,
          //   name: 'choice_chip',
          //   spacing: 16,
          //   runSpacing: 16,
          //   selectedColor: BC.white,
          //   backgroundColor: BC.grey,
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //   ),
          //   options: const [
          //     FormBuilderChipOption(
          //       value: 'Курєром',
          //       child: Text('Курєром'),
          //     ),
          //     FormBuilderChipOption(
          //       value: 'Самовивіз',
          //       child: Text('Самовивіз'),
          //     ),
          //   ],
          // ),
          Space.h8,
          Text(
            'Статус доставки',
            style: BS.light14.apply(color: BC.black),
          ),
          Space.h8,
          CustomChoiceChip(children: [
            CustomItem(
              isSelected: _bloc.deliveryStatus == 'moderation',
              text: 'Обробляється',
              onTap: () =>
                  _bloc.selectDeliveryStatus('moderation', order.uid, context),
            ),
            CustomItem(
              isSelected: _bloc.deliveryStatus == 'delivering',
              text: 'Доставляється',
              onTap: () =>
                  _bloc.selectDeliveryStatus('delivering', order.uid, context),
            ),
            CustomItem(
              isSelected: _bloc.deliveryStatus == 'delivered',
              text: 'Доставлено',
              onTap: () =>
                  _bloc.selectDeliveryStatus('delivered', order.uid, context),
            ),
            CustomItem(
              isSelected: _bloc.deliveryStatus == 'cancelled',
              text: 'Скасовано',
              onTap: () =>
                  _bloc.selectDeliveryStatus('cancelled', order.uid, context),
            ),
          ]),
          // FormBuilderChoiceChip(
          //   onChanged: (value) =>
          //       _bloc.selectDeliveryStatus(value ?? '', order.uid, context),
          //   initialValue: order.statusType,
          //   name: 'choice_chip',
          //   spacing: 16,
          //   runSpacing: 16,
          //   selectedColor: BC.white,
          //   backgroundColor: BC.grey,
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //   ),
          //   options: const [
          //     FormBuilderChipOption(
          //       value: 'moderation',
          //       child: Text('Обробляється'),
          //     ),
          //     FormBuilderChipOption(
          //       value: 'delivering',
          //       child: Text('Доставляється'),
          //     ),
          //     FormBuilderChipOption(
          //       value: 'delivered',
          //       child: Text('Доставлено'),
          //     ),
          //     FormBuilderChipOption(
          //       value: 'cancelled',
          //       child: Text('Скасовано'),
          //     ),
          //   ],
          // ),
          Space.h8,
          Row(
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
                    'Знижка: ${order.discount}₴',
                  ),
                  Space.h8,
                  Text(
                    'Бали: ${order.spentPoints}₴',
                  ),
                ],
              ),
              Space.w22,
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
              mainAxisExtent: 290,
            ),
            itemBuilder: (item, index) {
              final item = order.items?[index];
              print(_bloc.images.length);
              return ProductItem(
                product: item,
                image: _bloc.images[index]?.bytes,
              );
            },
          ),
          Space.h8,
          CustomButton(
            onTap: () => _bloc.showAddProductModal(context),
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
