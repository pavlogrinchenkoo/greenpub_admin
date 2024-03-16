import 'package:auto_route/annotations.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/screens/products_page/bloc/bloc.dart';
import 'package:delivery/screens/products_page/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:delivery/widgets/selected_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController controller = TextEditingController();
  late ProductsCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<ProductsCubit>();
    _bloc.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ProductsCubit>();
    return BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomTextField(
                    controller: controller,
                    enabled: true,
                    text: 'Пошук',
                    onChanged: (value) {
                      _bloc.search(value);
                    }),
              ),
              !(_bloc.isSearch)
                  ? Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.categories?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final idCategory = state.categories?[index].uuid;
                          final category = state.categories?[index].category;
                          final isSelected = state.categories?[index].isShow;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(category ?? '', style: BS.bold20),
                                  Space.w20,
                                  SelectedButton(
                                    onTap: () => _bloc.showSelectedDialog(
                                        context,
                                        state.categories?[index],
                                        state.products
                                            ?.where((element) =>
                                                element.category?.category ==
                                                category)
                                            .toList()),
                                    isSelected: isSelected ?? false,
                                  ),
                                ],
                              ),
                              Space.h16,
                              GridView.builder(
                                shrinkWrap: true,
                                itemCount: state.products
                                    ?.where((element) =>
                                        element.category?.uuid == idCategory)
                                    .length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 175,
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final product = state.products
                                      ?.where((element) =>
                                          element.category?.uuid ==
                                          idCategory)
                                      .toList()[index];
                                  return _CustomContainer(
                                    product: product,
                                  );
                                },
                              ),
                              Space.h16,
                            ],
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.products?.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 175,
                            crossAxisCount: 4,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final product = state.products?[index];
                            return _CustomContainer(
                              product: product,
                            );
                          })),
            ],
          ),
          floatingActionButton: InkWell(
            onTap: () => _bloc.goAddProductPage(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration:
                  BoxDecoration(color: BC.black, borderRadius: BRadius.r16),
              child: Text(
                'Додати продукт',
                style: BS.bold20.apply(color: BC.white),
              ),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class _CustomContainer extends StatelessWidget {
  final ProductModel? product;

  const _CustomContainer({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ProductsCubit>();
    return InkWell(
      onTap: () => _bloc.goProductPage(context, product?.uuid ?? ''),
      child: Container(
        decoration: BoxDecoration(
          color: BC.white,
          borderRadius: BRadius.r16,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Space.h16,
                      Text(
                        product?.name ?? '',
                        style: BS.bold18,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Space.h8,
                      Text(
                        product?.description ?? '',
                        style: BS.sb14,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Space.h26,
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (product?.oldPrice != null &&
                                      product?.oldPrice != 0)
                                  ? Text('${product?.price ?? '0'}₴',
                                      style: BS.bold16.apply(color: BC.red))
                                  : const SizedBox(),
                              Space.h4,
                              (product?.oldPrice == null ||
                                      product?.oldPrice == 0)
                                  ? Text(
                                      '${product?.price ?? '0'}₴',
                                      style: BS.bold22,
                                    )
                                  : Text(
                                      '${product?.oldPrice ?? '0'}₴',
                                      style: BS.bold12,
                                    ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            '${product?.weight ?? '0'}',
                            style: BS.bold16,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            (product?.isPromo ?? false)
                ? Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                        decoration: BoxDecoration(
                            color: BC.red, borderRadius: BRadius.r4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          'ВИБІР ГУРМАНІВ',
                          style: BS.bold14.apply(color: BC.white),
                        )))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
