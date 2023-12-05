import 'package:delivery/generated/assets.gen.dart';
import 'package:flutter/material.dart';


class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {this.appBar, required this.body, this.bottomNavigationBar, super.key});

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.bg.image().image,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(child: body),
      ),
    );
  }
}
