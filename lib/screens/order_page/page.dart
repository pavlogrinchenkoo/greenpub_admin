import 'package:auto_route/annotations.dart';
import 'package:delivery/screens/order_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_appbar.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'bloc/state.dart';

@RoutePage()
class OrderPage extends StatefulWidget {
  final String? uid;

  const OrderPage({super.key, @PathParam() this.uid});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController controllerUuid = TextEditingController();
  TextEditingController controllerUserUid = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerTime = TextEditingController();

  late OrderCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<OrderCubit>();
    _bloc.init(context, widget.uid ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        controllerTime.text = state.order?.timeCreate ?? '';
        controllerUuid.text = state.order?.uid ?? '';
        controllerUserUid.text = state.order?.userId ?? '';
        controllerAddress.text = state.order?.address?.address ?? '';
        final order = state.order;
        return CustomScaffold(
            appBar: CustomAppBar(
              text: 'Замовлення',
              // onTap: () => _bloc.goOrdersPage(context),
              user: order?.address?.address ?? '',
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CustomTextField(
                              validator: FormBuilderValidators.required(
                                errorText: 'Вкажіть UUID',
                              ),
                              controller: controllerUuid,
                              enabled: false,
                              text: 'UUID замовлення'),
                          Space.h16,
                          CustomTextField(
                              validator: FormBuilderValidators.required(
                                errorText: 'Вкажіть uid користувача',
                              ),
                              controller: controllerUserUid,
                              enabled: false,
                              text: 'Uid користувача'),
                          Space.h16,
                          CustomTextField(
                              validator: FormBuilderValidators.required(
                                errorText: 'Вкажіть адресу',
                              ),
                              controller: controllerAddress,
                              enabled: true,
                              text: 'Адреса'),
                          Space.h16,
                          CustomTextField(
                              validator: FormBuilderValidators.required(
                                errorText: 'Вкажіть час',
                              ),
                              controller: controllerTime,
                              enabled: false,
                              text: 'Час'),
                          Space.h16,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Спосіб оплати',
                                style: BS.light14.apply(color: BC.black),
                              ),
                              Space.h8,
                              FormBuilderChoiceChip(
                                onChanged: (value) =>
                                    _bloc.changePayType(value ?? ''),
                                initialValue: order?.payType,
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
                                    value: 'googlePay',
                                    child: Text('Google Pay'),
                                  ),
                                  FormBuilderChipOption(
                                    value: 'applePay',
                                    child: Text('Apple Pay'),
                                  ),
                                  FormBuilderChipOption(
                                    value: 'cash',
                                    child: Text('Cash'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Space.h16,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Спосіб доставки',
                                style: BS.light14.apply(color: BC.black),
                              ),
                              Space.h8,
                              FormBuilderChoiceChip(
                                onChanged: (value) =>
                                    _bloc.changeDeliveryType(value ?? ''),
                                initialValue: order?.deliveryType,
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
                                    value: 'pickup',
                                    child: Text('Pickup'),
                                  ),
                                  FormBuilderChipOption(
                                    value: 'delivery',
                                    child: Text('Delivery'),
                                  ),
                                ],
                              ),
                              Space.h32,
                              Row(
                                children: [
                                  CustomButton(
                                    onTap: () =>
                                        _bloc.updateOrder(
                                          context,
                                          // address: controllerAddress.text,
                                          timeCreate: controllerTime.text,
                                          uuid: controllerUuid.text,
                                          userId: controllerUserUid.text,
                                        ),
                                    icon: Text(
                                      'Зберегти зміни',
                                      style: BS.bold14.apply(color: BC.white),
                                    ),
                                  ),
                                  Space.w16,
                                  CustomButton(
                                    onTap: () =>
                                        _bloc.deleteOrder(
                                            context, order?.uid ?? ''),
                                    icon: Text(
                                      'Видалити замовлення',
                                      style: BS.bold14.apply(color: BC.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Space.w52,
                    Expanded(
                      child: Container(
                        height: 900,
                        decoration: BoxDecoration(
                            borderRadius: BRadius.r16,
                            border: Border.all(
                              color: BC.black,
                              width: 1,
                            )),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Text('Загальна вартість: '),
                                  Text('${_bloc.price} грн'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: state.order?.items?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final item = state.order?.items?[index];
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          borderRadius: BRadius.r16,
                                          border: Border.all(
                                            color: BC.black,
                                            width: 1,
                                          )),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(item?.product?.name ?? ''),
                                              const Spacer(),
                                              _CountItems(
                                                count: item?.count ?? 0,
                                                price: item?.product?.price ?? 0,
                                                uuid: item?.product?.uuid ?? '',
                                              )
                                            ],
                                          ),
                                          Space.h8,
                                          Row(
                                            children: [
                                              const Text('Ціна: '),
                                              Text('${item?.product?.price ?? '0'}'),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () =>
                                                    _bloc.delete(
                                                        context, item?.product?.uuid ?? ''),
                                                child: const Icon(
                                                  Icons.delete,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ));
      }
      return const SizedBox();
    });
  }
}

class _CountItems extends StatefulWidget {
  int count;
  final double price;
  final String uuid;

  _CountItems({super.key,
    required this.count,
    required this.price, required this.uuid,
  });

  @override
  State<_CountItems> createState() => _CountItemsState();
}

class _CountItemsState extends State<_CountItems> {
  void add() {
    setState(() {
      widget.count++;
      context.read<OrderCubit>().sumPrice(widget.price, widget.uuid, widget.count);
    });
  }

  void remove() {
    setState(() {
      if (widget.count == 0) {
        return;
      }
      widget.count--;
      context.read<OrderCubit>().sumPrice(-widget.price, widget.uuid, widget.count);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(onTap: () => remove(), child: const Icon(Icons.remove)),
        Space.w8,
        Text('${widget.count}'),
        Space.w8,
        InkWell(onTap: () => add(), child: const Icon(Icons.add)),
      ],
    );
  }
}
