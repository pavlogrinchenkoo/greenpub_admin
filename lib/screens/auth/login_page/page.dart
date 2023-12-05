import 'package:auto_route/annotations.dart';
import 'package:delivery/screens/auth/login_page/bloc/bloc.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/state.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    context.read<LoginCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      if (state is LoadingState) {
        return const SizedBox();
      }
      if (state is LoadedState) {
        return CustomScaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CustomTextField(
                  controller: emailController,
                  text: 'Email',
                ),
                Space.h16,
                _CustomTextField(
                  controller: passwordController,
                  text: 'Password',
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? text;

  const _CustomTextField({super.key, required this.controller,   this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BRadius.r50,
          border: Border.all(color: BC.black, width: 1)),
      child: TextField(
          controller: controller,
          decoration:  InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            hintText: text,
            border: InputBorder.none,
          )),
    );
  }
}
