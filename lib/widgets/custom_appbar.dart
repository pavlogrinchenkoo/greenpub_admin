import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String? user;
  final String? text;
  final Function()? onTap;
  const CustomAppBar({super.key,  this.user, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: false,
      title: Text('$text ${user ?? ''}'),
      leading: BackButton(onPressed: () => context.router.pop()),
    );
  }
}
