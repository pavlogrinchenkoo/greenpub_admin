import 'package:auto_route/annotations.dart';
import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:delivery/screens/add_product_page/page.dart';
import 'package:delivery/screens/product_page/bloc/bloc.dart';
import 'package:delivery/screens/product_page/bloc/state.dart';
import 'package:delivery/screens/show_position/show_pisition.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_appbar.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:delivery/widgets/selected_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'widgets/positions_group.dart';

@RoutePage()
class ProductPage extends StatefulWidget {
  final String? id;

  const ProductPage({super.key, @PathParam() this.id});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerUUID = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerNewPrice = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerWeight = TextEditingController();
  TextEditingController controllerTimeCreate = TextEditingController();
  TextEditingController controllerFilterOrders = TextEditingController();
  late ProductCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<ProductCubit>();
    _bloc.init(context, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ProductCubit>();
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        final product = state.product;
        controllerUUID.text = state.product?.uuid ?? '';
        controllerName.text = state.product?.name ?? '';
        controllerPrice.text = '${state.product?.price ?? ' '}';
        controllerNewPrice.text = '${state.product?.oldPrice ?? ' '}';
        controllerDescription.text = state.product?.description ?? '';
        controllerWeight.text = state.product?.weight ?? ' ';
        controllerTimeCreate.text = state.product?.timeCreate ?? '';
        controllerFilterOrders.text = '${state.product?.filterOrders ?? ' '}';

        return CustomScaffold(
          appBar: CustomAppBar(
            text: 'Продукт',
            onTap: () => _bloc.goProductsPage(context),
            user: state.product?.name ?? '',
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => _bloc.uploadImage(),
                          child: (state.image == null)
                              ? Container(
                                  width: 400,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    borderRadius: BRadius.r16,
                                    color: BC.grey,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline,
                                          size: 40,
                                          color: BC.beige,
                                        ),
                                        Space.h8,
                                        Text(
                                          'Додати фото',
                                          style:
                                              BS.bold14.apply(color: BC.beige),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BRadius.r16,
                                  child: Image.memory(
                                    state.image?.bytes ?? Uint8List(0),
                                    width: 400,
                                    height: 400,
                                    fit: BoxFit.cover,
                                  )),
                        ),
                        Space.h32,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              CustomButton(
                                onTap: () => _bloc.editProduct(
                                  context,
                                  name: controllerName.text,
                                  price: controllerPrice.text,
                                  description: controllerDescription.text,
                                  weight: controllerWeight.text,
                                  newPrice: controllerNewPrice.text,
                                  time: controllerTimeCreate.text,
                                  category: _bloc.category,
                                  tags: _bloc.tags,
                                  uuid: controllerUUID.text,
                                  imagePath: _bloc.imagePath,
                                  isPromo: _bloc.isPromo,
                                  isShow: _bloc.isShow,
                                  positions: _bloc.positions,
                                  filterOrders: controllerFilterOrders.text,
                                ),
                                icon: Text('Змінити Продукт',
                                    style: BS.bold14.apply(color: BC.beige)),
                              ),
                              Space.h16,
                              CustomButton(
                                onTap: () => _bloc.deleteProduct(context),
                                icon: Text('Видалити Продукт',
                                    style: BS.bold14.apply(color: BC.beige)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Space.w52,
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      errorText: 'Вкажіть назву',
                                    ),
                                    controller: controllerName,
                                    enabled: true,
                                    text: 'Назва',
                                  ),
                                  Space.h16,
                                  CustomTextField(
                                    validator: FormBuilderValidators.required(
                                      errorText: 'Вкажіть ціну',
                                    ),
                                    controller: controllerPrice,
                                    enabled: true,
                                    text: 'Ціна/Акційна ціна',
                                  ),
                                  Space.h16,
                                  CustomTextField(
                                    validator: FormBuilderValidators.required(
                                      errorText: 'Вкажіть масу',
                                    ),
                                    controller: controllerWeight,
                                    enabled: true,
                                    text: 'Маса',
                                  ),
                                  Space.h16,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Дата публікації',
                                        style:
                                            BS.light14.apply(color: BC.black),
                                      ),
                                      Space.h8,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        decoration: BoxDecoration(
                                          borderRadius: BRadius.r16,
                                          border: Border.all(
                                            color: BC.black,
                                            width: 1,
                                          ),
                                        ),
                                        child: FormBuilderDateTimePicker(
                                          controller: controllerTimeCreate,
                                          name: 'date_picker',
                                          onChanged: (value) {},
                                          inputType: InputType.date,
                                          style: BS.light14.apply(
                                            color: BC.black,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          initialTime: const TimeOfDay(
                                              hour: 8, minute: 0),
                                          initialValue: DateTime.now(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Space.w22,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                    controller: controllerUUID,
                                    enabled: false,
                                    text: 'UUID',
                                  ),
                                  Space.h16,
                                  CustomTextField(
                                    controller: controllerNewPrice,
                                    enabled: true,
                                    text: 'Стара ціна',
                                  ),
                                  Space.h16,
                                  Row(
                                    children: [
                                      IsSelectedButton(
                                        onTap: () =>
                                            _bloc.changePromo(_bloc.isPromo),
                                        title: 'Promo',
                                        isSelected: _bloc.isPromo,
                                      ),
                                      Space.w20,
                                      IsSelectedButton(
                                        onTap: () =>
                                            _bloc.changeIsShow(_bloc.isShow),
                                        title: 'Активне',
                                        isSelected: _bloc.isShow,
                                      ),
                                    ],
                                  ),
                                  Space.h16,
                                  Space.h8,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Приоритет',
                                        style: BS.light14.apply(color: BC.black),
                                      ),
                                      Space.h8,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: BRadius.r16,
                                          border: Border.all(color: BC.black),
                                        ),
                                        child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            controller: controllerFilterOrders,
                                            decoration: const InputDecoration(
                                              hintText: 'Пріоритет',
                                              border: InputBorder.none,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Space.h32,
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CTextField(
                                    controller: controllerDescription,
                                    text: 'Опис продукту',
                                  ),
                                  Space.h16,
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BRadius.r16,
                                      color: BC.white,
                                    ),
                                    child: ListView.builder(
                                        itemCount: _bloc.positions.length,
                                        itemBuilder: (context, index) {
                                          final position =
                                              _bloc.positions[index];
                                          return PositionsGroup(
                                            position: position,
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                            Space.w52,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Категорія',
                                        style:
                                            BS.light14.apply(color: BC.black),
                                      ),
                                      Space.h8,
                                      FormBuilderChoiceChip(
                                        onChanged: (value) =>
                                            _bloc.addCategory(value),
                                        initialValue: product?.category?.uuid,
                                        name: 'choice_chip',
                                        spacing: 16,
                                        runSpacing: 16,
                                        selectedColor: BC.white,
                                        backgroundColor: BC.grey,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        options: [
                                          for (final item
                                              in state.categoryList ?? [])
                                            FormBuilderChipOption(
                                              value: item.uuid,
                                              child: Text(item.category ?? ''),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Space.h16,
                                  Text(
                                    'Теги',
                                    style: BS.light14.apply(color: BC.black),
                                  ),
                                  Space.h8,
                                  FormBuilderFilterChip(
                                    onChanged: (value) {
                                      print(value);
                                      _bloc.addTags(value ?? []);
                                    },
                                    name: 'filter_chip',
                                    initialValue: product?.tags
                                        ?.map((e) => e.uuid)
                                        .toList(),
                                    spacing: 16,
                                    runSpacing: 16,
                                    selectedColor: BC.white,
                                    backgroundColor: BC.grey,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    options: [
                                      for (final item in state.tagsList ?? [])
                                        FormBuilderChipOption(
                                          value: item.uuid,
                                          child: Text(item.tag ?? ''),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Space.h32,
                        CustomButton(
                          onTap: () => _bloc.showPosition(context, null),
                          icon: Text(
                            'Показати позиціЇ',
                            style: BS.bold14.apply(color: BC.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class IsSelectedButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isSelected;

  const IsSelectedButton(
      {super.key, required this.title, this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BS.light14.apply(color: BC.black)),
        Space.h8,
        InkWell(
          borderRadius: BRadius.r16,
          onTap: onTap,
          child: (!isSelected)
              ? Container(
                  width: 90,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BRadius.r16,
                    border: Border.all(
                      color: BC.black,
                      width: 1,
                    ),
                  ),
                  child: Text('ВИКЛ', style: BS.light14.apply(color: BC.black)),
                )
              : Container(
                  width: 90,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BRadius.r16,
                    color: BC.black,
                    border: Border.all(
                      color: BC.black,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child:
                        Text('ВКЛ', style: BS.light14.apply(color: BC.white)),
                  ),
                ),
        ),
      ],
    );
  }
}
