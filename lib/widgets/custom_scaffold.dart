import 'package:delivery/generated/assets.gen.dart';
import 'package:delivery/style.dart';
import 'package:flutter/material.dart';


class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {this.appBar, required this.body, this.bottomNavigationBar, this.floatingActionButton, super.key});
  final Widget? floatingActionButton;
  final Widget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      backgroundColor: BC.beige,
      // appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(child: Column(children: [
        appBar ?? Container(),
        Expanded(child: body)])),
    );
  }
}
