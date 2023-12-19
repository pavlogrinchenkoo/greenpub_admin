import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_user/dto.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_appbar.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'bloc/bloc.dart';
import 'bloc/state.dart';

@RoutePage()
class UserPage extends StatefulWidget {
  final String? uid;

  const UserPage({super.key, @PathParam() this.uid});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController controllerUid = TextEditingController();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerPoints = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerBirthday = TextEditingController();
  final TextEditingController controllerTimeCreate = TextEditingController();
  late final UserCubit _bloc;

  @override
  void initState() {
    print('uid ${widget.uid}');
    _bloc = context.read<UserCubit>();
    _bloc.init(context, widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<UserCubit>();
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        final user = state.user;
        controllerUid.text = user?.uid ?? '';
        controllerName.text = user?.firstName ?? '';
        controllerPhone.text = user?.phone ?? '';
        controllerPoints.text = user?.points.toString() ?? '';
        controllerEmail.text = user?.email ?? '';
        controllerBirthday.text = user?.birthday ?? '';
        controllerTimeCreate.text = user?.timeCreate ?? '';
        return CustomScaffold(
            appBar: CustomAppBar(
              user: user?.firstName ?? '',
              onTap: () => _bloc.goUsersPage(context),
              text: 'Профіль',
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            (state.image == null)
                                ? Container(
                                    width: 400,
                                    height: 400,
                                    decoration: BoxDecoration(
                                      borderRadius: BRadius.r16,
                                      color: BC.grey,
                                    ))
                                : ClipRRect(
                                    borderRadius: BRadius.r16,
                                    child: Image.memory(
                                      state.image ?? Uint8List(0),
                                      width: 400,
                                      height: 400,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Space.h32,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 100),
                              child: Column(
                                children: [
                                  CustomButton(
                                    onTap: () {
                                      final points = int.parse(
                                        controllerPoints.text,
                                      );
                                      _bloc.editUser(
                                          context,
                                          UserModel(
                                            controllerUid.text,
                                            controllerName.text,
                                            controllerPhone.text,
                                            controllerEmail.text,
                                            controllerBirthday.text,
                                            user?.avatar ?? '',
                                            points,
                                            user?.favorites,
                                            user?.orders,
                                            controllerTimeCreate.text,
                                          ));
                                    },
                                    icon: Text('Змінити дані',
                                        style:
                                            BS.bold14.apply(color: BC.beige)),
                                  ),
                                  Space.h16,
                                  CustomButton(
                                    onTap: () => _bloc.deleteUser(
                                        context, user?.uid ?? ''),
                                    icon: Text('Видалити користувача',
                                        style:
                                            BS.bold14.apply(color: BC.beige)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Space.w52,
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            CustomTextField(
                              validator: FormBuilderValidators.required(
                                errorText: 'Вкажіть Ім\'я',
                              ),
                              controller: controllerName,
                              text: 'Ім\'я',
                              enabled: true,
                            ),
                            Space.h16,
                            CustomTextField(
                              controller: controllerPhone,
                              text: 'Номер телефону',
                              enabled: false,
                            ),
                            Space.h16,
                            CustomTextField(
                              validator: FormBuilderValidators.required(
                                errorText: 'Вкажіть Email',
                              ),
                              controller: controllerEmail,
                              text: 'Email',
                              enabled: true,
                            ),
                            Space.h16,
                            CustomTextField(
                              controller: controllerUid,
                              text: 'Uid',
                              enabled: false,
                            ),
                            Space.h16,
                            CustomTextField(
                              controller: controllerPoints,
                              text: 'Бали',
                              enabled: true,
                            ),
                            Space.h16,
                            CustomTextField(
                              validator: FormBuilderValidators.required(
                                errorText: 'Вкажіть День Народження',
                              ),
                              controller: controllerBirthday,
                              text: 'День Народження',
                              enabled: true,
                            ),
                            Space.h16,
                            CustomTextField(
                              controller: controllerTimeCreate,
                              text: 'Дата створення',
                              enabled: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Space.h32,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [],
                  ),
                ],
              ),
            ));
      }
      return const SizedBox();
    });
  }


}
