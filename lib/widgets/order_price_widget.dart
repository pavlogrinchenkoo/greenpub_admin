import 'package:delivery/style.dart';
import 'package:flutter/material.dart';

class OrderPriceWidget extends StatelessWidget {
  const OrderPriceWidget({super.key, required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: price,
            style: BS.bold22,
          ),
          TextSpan(
            text: '₴',
            style: TextStyle(
              color: BC.black,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.lineThrough,
              decorationThickness: 2,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
