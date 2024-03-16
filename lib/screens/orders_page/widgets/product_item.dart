import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/positions/dto.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/screens/orders_page/page.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ItemProduct? product;
  final String? image;

  const ProductItem({super.key, this.product, this.image});

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<OrdersCubit>();
    final item = product?.product;
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
                    child: CachedNetworkImage(
                      imageUrl: image ?? '',
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CustomIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                    Space.h8,
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                        itemCount: item?.options?.length ?? 0,
                        itemBuilder: (context, index) {
                      final option = item?.options?[index];
                    return Text('${option?.name ?? ''}X${option?.positions?[0].count ?? 0}',style: BS.sb14.apply(color: BC.black),);
                        }),
                  ),
                    Space.h8,
                    Row(
                      children: [
                        CustomPrice(
                          price: item?.price ?? 0,
                          oldPrice: item?.oldPrice ?? 0,
                        ),
                        Space.w16,
                        Expanded(
                          child: CountContainer(
                            count: product?.count ?? 0,
                            addCount: () => _bloc.addCount(product),
                            removeCount: () => _bloc.removeCount(product),
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
