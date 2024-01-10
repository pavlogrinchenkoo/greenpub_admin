import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/screens/orders_page/page.dart';
import 'package:delivery/screens/orders_page/widgets/show_product/bloc/bloc.dart';
import 'package:delivery/screens/orders_page/widgets/show_product/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowProduct extends StatefulWidget {
  const ShowProduct({super.key});

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    context.read<ShowProductCubit>().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ShowProductCubit>();
    return BlocBuilder<ShowProductCubit, ShowProductState>(
        builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                if (!_bloc.isLoadMoreTriggered) {
                  _bloc.getProducts();
                  _bloc.isLoadMoreTriggered = true;
                }
              } else {
                _bloc.isLoadMoreTriggered = false;
              }
              return true;
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      BackButton(
                        onPressed: () => _bloc.goBack(context),
                      ),
                      Space.w20,
                      Expanded(
                        child: TextField(
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Пошук',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: BC.grey,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    controller: controller,
                    itemCount: state.products?.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 290,
                      crossAxisCount: 6,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final image = state.images?[index];
                      final item = state.products?[index];
                      return _CustomItemProduct(
                        item: item,
                        image: image,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class _CustomItemProduct extends StatelessWidget {
  final ProductModel? item;
  final Uint8List? image;

  const _CustomItemProduct({super.key, this.item, this.image});

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<ShowProductCubit>();
    return Container(
        decoration: BoxDecoration(
            color: BC.white,
            borderRadius: BRadius.r10,
            boxShadow: BShadow.light,
            border: Border.all(
              color: BC.grey,
              width: 1,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (image != null)
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.memory(
                      image!,
                      width: 250,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 250,
                    height: 100,
                    color: BC.grey,
                  ),
            Space.h16,
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
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
                    Row(
                      children: [
                        CustomPrice(
                          price: item?.price ?? 0,
                          oldPrice: item?.oldPrice ?? 0,
                        ),
                        Space.w16,
                        (_bloc.selectedProducts.any((element) =>
                                element.product?.uuid == item?.uuid))
                            ?
                        Expanded(
                          child: CountContainer(
                            count:
                            _bloc.selectedProducts
                                    .where((element) =>
                                        element.product?.uuid == item?.uuid)
                                    .first
                                    .count ??
                                0,
                            addCount: () => _bloc.addCount(item),
                            removeCount: () => _bloc.removeCount(item),
                          ),
                        )
                            : Expanded(
                              child: CustomButton(
                                  onTap: () => _bloc.addProduct(item),
                                  icon: Text('Додати',
                                      style: BS.sb14.apply(color: BC.white)),
                                  color: BC.green,
                                ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
