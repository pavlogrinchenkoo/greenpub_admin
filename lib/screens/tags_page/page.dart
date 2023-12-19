import 'package:auto_route/auto_route.dart';
import 'package:delivery/screens/tags_page/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

@RoutePage()
class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    context.read<TagsCubit>().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<TagsCubit>();
    return BlocBuilder<TagsCubit, TagsState>(builder: (context, state) {
      if (state is LoadingState) {
        return const CustomIndicator();
      }
      if (state is LoadedState) {
        return CustomScaffold(
          body: ListView.builder(
            itemCount: state.tags?.length,
            itemBuilder: (context, index) {
              final tag = state.tags?[index];
              return Column(
                children: [
                  (index == 0 && _bloc.isShowTextField)
                      ? _CustomContainer(
                          isShowBorder: state.tags?.isEmpty ?? true,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Введіть тег',
                                    )),
                              ),
                              IconButton(
                                  onPressed: () => _bloc.addTag(controller.text, context, controller),
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
                          isShowBorder: index == (state.tags?.length ?? 0) - 1,
                          child: Row(
                            children: [
                              Text(
                               '${index + 1}: #${tag?.tag ?? ' '}',
                                style: BS.light14.apply(color: BC.black),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () => _bloc.showEditDialog(tag?.uuid ?? '', controller, context),
                                      icon: const Icon(
                                        Icons.edit,
                                      )
                                  ),
                                  IconButton(
                                    onPressed: () => _bloc.showDeleteDialog(tag, context),
                                    icon: const Icon(
                                      Icons.delete,
                                    )
                                  ),
                                ]
                              )
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
                'Додати тег',
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
