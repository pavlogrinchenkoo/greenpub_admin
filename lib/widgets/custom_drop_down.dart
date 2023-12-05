import 'package:delivery/style.dart';
import 'package:flutter/material.dart';


class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    this.width,
    this.items,
    this.child,
    required this.tooltipController,
    required this.link,
    super.key,
  });

  final double? width;
  final List<Widget>? items;
  final Widget? child;
  final OverlayPortalController tooltipController;
  final LayerLink link;

  /// width of the button after the widget rendered
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: OverlayPortal(
          controller: tooltipController,
          overlayChildBuilder: (BuildContext context) {
            return CompositedTransformFollower(
                link: link,
                targetAnchor: Alignment.bottomLeft,
                offset: Offset(-32, 0),
                child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: MenuWidget(
                      items: [...?items],
                    )));
          },
          child: child),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    this.items,
    this.height,
  });

  final double? height;
  final List<Widget>? items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 200,
      // height: height,
      decoration: BoxDecoration(
          borderRadius: BRadius.r16, color: BC.green, boxShadow: BShadow.light),
      child: ClipRRect(
        borderRadius: BRadius.r16,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [...?items]),
      ),
    );
  }
}
