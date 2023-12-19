import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:delivery/screens/add_product_page/bloc/bloc.dart';
import 'package:delivery/screens/add_product_page/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_appbar.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

@RoutePage()
class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerUUID = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerNewPrice = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerWeight = TextEditingController();
  TextEditingController controllerTimeCreate = TextEditingController();
  late AddProductCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<AddProductCubit>();
    _bloc.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductCubit, AddProductState>(
        builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        controllerUUID.text = state.id ?? '';
        controllerTimeCreate.text = state.time ?? '';
        return CustomScaffold(
            appBar:  CustomAppBar(
              onTap: () => context.router.pop(),
              text: 'Добавити продукт',
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
                          InkWell(
                            onTap: () => _bloc.uploadFile(),
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
                                            style: BS.bold14
                                                .apply(color: BC.beige),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BRadius.r16,
                                    child: Image.memory(
                                      state.image ?? Uint8List(0),
                                      width: 400,
                                      height: 400,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Space.h32,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                CustomButton(
                                  onTap: () => _bloc.addProduct(
                                    context,
                                    name: controllerName.text,
                                    price: controllerPrice.text,
                                    description: controllerDescription.text,
                                    weight: controllerWeight.text,
                                    newPrice: controllerNewPrice.text,
                                    isPromo: _bloc.isPromo,
                                    time: controllerTimeCreate.text,
                                    category: _bloc.category,
                                    tags: _bloc.tags,
                                    uuid: controllerUUID.text,
                                    imagePath: state.imagePath,
                                  ),
                                  icon: Text('Додати продукт',
                                      style: BS.bold14.apply(color: BC.beige)),
                                ),
                              ],
                            ),
                          ),
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
                                      text: 'Ціна',
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
                                      text: 'Акційна ціна',
                                    ),
                                    Space.h16,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Promo',
                                            style: BS.light14
                                                .apply(color: BC.black)),
                                        Space.h8,
                                        InkWell(
                                          borderRadius: BRadius.r16,
                                          onTap: () => _bloc.changePromo(),
                                          child: (!_bloc.isPromo)
                                              ? Container(
                                                  width: 90,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 24,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BRadius.r16,
                                                    border: Border.all(
                                                      color: BC.black,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text('ВИКЛ',
                                                      style: BS.light14.apply(
                                                          color: BC.black)),
                                                )
                                              : Container(
                                                  width: 90,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 24,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BRadius.r16,
                                                    color: BC.black,
                                                    border: Border.all(
                                                      color: BC.black,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text('ВКЛ',
                                                        style: BS.light14.apply(
                                                            color: BC.white)),
                                                  ),
                                                ),
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
                                child: CTextField(
                                  controller: controllerDescription,
                                  text: 'Опис продукту',
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
                                          name: 'choice_chip',
                                          spacing: 16,
                                          runSpacing: 16,
                                          selectedColor: BC.white,
                                          backgroundColor: BC.grey,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          options:  [
                                            for (final item in state.categoryList ?? [])
                                              FormBuilderChipOption(
                                                value: item as CategoryModel,
                                                child: Text('${item.category ?? ''}'),
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
                                      onChanged: (value) =>
                                          _bloc.addTegs(value ?? []),
                                      name: 'filter_chip',
                                      spacing: 16,
                                      runSpacing: 16,
                                      selectedColor: BC.white,
                                      backgroundColor: BC.grey,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      options:  [
                                        for (final item in state.tagsList ?? [])
                                          FormBuilderChipOption(
                                            value: item as TagModel,
                                            child: Text('${item.tag ?? ''}'),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ));
      }
      return const SizedBox();
    });
  }
}

class CTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? text;

  const CTextField({super.key, required this.controller, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text ?? '',
          style: BS.light14.apply(color: BC.black),
        ),
        Space.h8,
        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BRadius.r16,
            border: Border.all(
              color: BC.black,
              width: 1,
            ),
          ),
          child: TextField(
              maxLines: 20,
              controller: controller,
              style: BS.light14.apply(color: BC.black),
              decoration: InputDecoration(
                hintText: text,
                hintStyle: BS.light14.apply(color: BC.black.withOpacity(0.5)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              )),
        ),
      ],
    );
  }
}
