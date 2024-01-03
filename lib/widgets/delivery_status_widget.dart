import 'package:delivery/style.dart';
import 'package:flutter/material.dart';

class DeliveryStatusWidget extends StatelessWidget {
  const DeliveryStatusWidget({super.key, required this.deliveryStatus});

  final String deliveryStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: BoxDecoration(
        color: BC.green.withOpacity(0.2),
        borderRadius: BRadius.r16,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
        child: Text(
          deliveryStatus,
          style: BS.sb14,
        ),
      ),
    );
  }
}
