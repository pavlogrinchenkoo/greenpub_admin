import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:flutter/material.dart';

class ItemCountButton extends StatefulWidget {
  const ItemCountButton({
    this.loading = false,
    this.onTap,
    super.key,
    this.product,
    this.width,
    this.style,
  });

  final void Function()? onTap;
  final bool loading;
  final ItemProduct? product;
  final double? width;
  final TextStyle? style;

  @override
  State<ItemCountButton> createState() => _ItemCountButtonState();
}

class _ItemCountButtonState extends State<ItemCountButton> {
  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? Container(color: BC.black)
        : Container(
          width: widget.width ?? 103,
          decoration: BoxDecoration(
            color: BC.green,
            borderRadius: BRadius.r10,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(13, 4, 13, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  // onTap: () => cartBloc.removeCount(widget.product),
                  child: Text(
                    '-',
                    style: widget.style ??
                        BS.bold14.copyWith(
                          color: BC.green,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Space.w8,
                Text(
                  '${widget.product?.count ?? 0}',
                  style: widget.style ??
                      BS.bold14.copyWith(
                        color: BC.green,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Space.w8,
                GestureDetector(
                  // onTap: () => cartBloc.addCount(widget.product),
                  child: Text(
                    '+',
                    style: widget.style ??
                        BS.bold14.copyWith(
                          color: BC.green,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
