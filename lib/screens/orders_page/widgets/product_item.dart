import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/screens/orders_page/page.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ItemProduct? product;
  final Uint8List? image;

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
              child: Image.memory(
                image!,
                width: 250,
                height: 100,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              width: 400,
              height: 400,
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