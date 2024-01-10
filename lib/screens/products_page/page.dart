import 'package:auto_route/annotations.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/screens/products_page/bloc/bloc.dart';
import 'package:delivery/screens/products_page/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
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
  late ProductsCubit _bloc;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    _bloc = context.read<ProductsCubit>();
    _bloc.init(context, false);
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
              Expanded(
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
                      child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(20),
                          controller: controller,
                          itemCount: state.products?.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 375,
                            crossAxisCount: 5,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final product = state.products?[index];
                            return _CustomContainer(
                              product: product,
                              image: state.images?[index]?.bytes,
                            );
                          })))
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
  final Uint8List? image;

  const _CustomContainer({super.key, this.product, this.image});

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
                (image == null)
                    ? Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          color: BC.grey,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.memory(
                          image!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                              (product?.oldPrice != null && product?.oldPrice != 0)
                                  ? Text('${product?.price ?? '0'}₴',
                                      style: BS.bold16.apply(color: BC.red))
                                  : const SizedBox(),
                              Space.h4,
                              (product?.oldPrice == null || product?.oldPrice == 0)
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
                            '${product?.weight ?? '0'} г',
                            style: BS.bold16,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            (product?.isPromo ?? false) ? Positioned(
              right: 8,
              top: 8,
                child: Container(
                    decoration:
                        BoxDecoration(color: BC.red, borderRadius: BRadius.r4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'ВИБІР ГУРМАНІВ',
                      style: BS.bold14.apply(color: BC.white),
                    ))): const SizedBox(),
          ],
        ),
      ),
    );
  }
}
