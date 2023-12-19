import 'package:auto_route/auto_route.dart';
import 'package:delivery/screens/categories_page/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

@RoutePage()
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    context.read<CategoryCubit>().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<CategoryCubit>();
    return BlocBuilder<CategoryCubit, CategoryState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
          body: ListView.builder(
            itemCount: state.categories?.length ?? 0,
            itemBuilder: (context, index) {
              final category = state.categories?[index];
              return Column(
                children: [
                  (index == 0 && _bloc.isShowTextField)
                      ? _CustomContainer(
                          isShowBorder: state.categories?.isEmpty ?? true,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => _bloc.addImage(),
                                child: (_bloc.image == null)
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BRadius.r16,
                                          color: BC.grey,
                                        ),
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          color: BC.beige,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BRadius.r16,
                                        child: Image.memory(
                                          _bloc.image!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              Space.w22,
                              Expanded(
                                child: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Введіть категорію',
                                    )),
                              ),
                              IconButton(
                                  onPressed: () => _bloc.addCategory(
                                      controller.text, context, controller),
                                  icon: Icon(
                                    Icons.add,
                                    color: BC.black,
                                  ))
                            ],
                          ))
                      : const SizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child: _CustomContainer(
                          isShowBorder:
                              index == (state.categories?.length ?? 0) - 1,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => _bloc.editImage(category?.uuid ?? ''),
                                child: (state.images?[index] == null)
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BRadius.r16,
                                          color: BC.grey,
                                        ),
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          color: BC.beige,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BRadius.r16,
                                        child: Image.memory(
                                          state.images![index]!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              Space.w22,
                              Text(
                                '${index + 1}: ${category?.category ?? ' '}',
                                style: BS.light14.apply(color: BC.black),
                              ),
                              const Spacer(),
                              Row(children: [
                                IconButton(
                                    onPressed: () => _bloc.showEditDialog(
                                        category?.uuid ?? '',
                                        controller,
                                        context),
                                    icon: const Icon(
                                      Icons.edit,
                                    )),
                                IconButton(
                                    onPressed: () => _bloc.showDeleteDialog(
                                        category, context),
                                    icon: const Icon(
                                      Icons.delete,
                                    )),
                              ])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          floatingActionButton: InkWell(
            onTap: () => _bloc.showTextField(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration:
                  BoxDecoration(color: BC.black, borderRadius: BRadius.r16),
              child: Text(
                'Додати категорію',
                style: BS.bold20.apply(color: BC.white),
              ),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class _CustomContainer extends StatelessWidget {
  final Widget child;
  final bool isShowBorder;

  const _CustomContainer(
      {super.key, required this.child, required this.isShowBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BC.black,
            width: (isShowBorder) ? 1 : 0,
          ),
          right: BorderSide(
            color: BC.black,
            width: 1,
          ),
          left: BorderSide(
            color: BC.black,
            width: 1,
          ),
          top: BorderSide(
            color: BC.black,
            width: 1,
          ),
        ),
      ),
      child: child,
    );
  }
}
