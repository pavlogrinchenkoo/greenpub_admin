import 'dart:typed_data';
import 'package:auto_route/annotations.dart';
import 'package:delivery/api/firestore_shared/dto.dart';
import 'package:delivery/screens/shares_page/bloc/bloc.dart';
import 'package:delivery/screens/shares_page/bloc/state.dart';
import 'package:delivery/style.dart';
import 'package:delivery/utils/spaces.dart';
import 'package:delivery/widgets/custom_buttom.dart';
import 'package:delivery/widgets/custom_indicator.dart';
import 'package:delivery/widgets/custom_scaffold.dart';
import 'package:delivery/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

@RoutePage()
class SharesPage extends StatefulWidget {
  const SharesPage({super.key});

  @override
  State<SharesPage> createState() => _SharesPageState();
}

class _SharesPageState extends State<SharesPage> {
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  late SharesCubit _bloc;

  @override
  void initState() {
    _bloc = context.read<SharesCubit>();
    _bloc.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<SharesCubit>();
    return BlocBuilder<SharesCubit, SharesState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const CustomIndicator();
        }
        if (state is LoadedState) {
          return CustomScaffold(
            body: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.shares.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => _bloc.selectIndex(index),
                              child: _SharesContainer(
                                shares: state.shares[index],
                                image: _bloc.images[index],
                              ),
                            ),
                            Space.h16,
                          ],
                        );
                      }),
                ),
                Expanded(
                  flex: 2,
                  child: _DetailContainer(
                    controllerTitle: controllerTitle,
                    controllerDescription: controllerDescription,
                    image: _bloc.image,
                  ),
                ),
              ],
            ),
            floatingActionButton: (!_bloc.isAddShared)
                ? InkWell(
                    onTap: () => _bloc.changeIsAddShared(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                          color: BC.black, borderRadius: BRadius.r16),
                      child: Text(
                        'Додати акцію',
                        style: BS.bold20.apply(color: BC.white),
                      ),
                    ),
                  )
                : null,
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _SharesContainer extends StatelessWidget {
  final SharesModel shares;
  final Uint8List? image;

  const _SharesContainer({super.key, required this.shares, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BRadius.r10,
        color: BC.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BRadius.r10,
            child: image == null
                ? Container(
                    width: 100,
                    height: 100,
                    color: BC.grey,
                  )
                : Image.memory(
                    image ?? Uint8List(0),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          Space.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shares.title ?? '',
                  style: BS.bold18,
                ),
                Space.h16,
                Text(
                  shares.description ?? '',
                  style: BS.sb14,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailContainer extends StatelessWidget {
  final TextEditingController controllerTitle;
  final TextEditingController controllerDescription;
  final Uint8List? image;

  const _DetailContainer(
      {super.key,
      required this.controllerTitle,
      required this.controllerDescription,
      this.image});

  @override
  Widget build(BuildContext context) {
    final _bloc = context.read<SharesCubit>();
    final shared = _bloc.shared;
    controllerTitle.text = shared?.title ?? '';
    controllerDescription.text = shared?.description ?? '';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BRadius.r10,
        color: BC.white,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BRadius.r10,
                  child: InkWell(
                    onTap: () => _bloc.uploadImage(),
                    child: (_bloc.image == null)
                        ? Container(
                            width: 400,
                            height: 400,
                            color: BC.grey,
                            child: const Icon(Icons.add_circle_outline),
                          )
                        : Image.memory(
                            _bloc.image ?? Uint8List(0),
                            width: 400,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                  )),
              Space.w16,
              Expanded(
                  child: Column(
                children: [
                  CustomTextField(controller: controllerTitle, enabled: true),
                  Column(
                    children: [
                      Space.h16,
                      (_bloc.isAddShared)
                          ? const SizedBox()
                          : CustomButton(
                              onTap: () => _bloc.deleteShares(context),
                              icon: Text('Видалити',
                                  style: BS.bold14.apply(color: BC.white)),
                            ),
                      Space.h16,
                      (_bloc.isAddShared)
                          ? const SizedBox()
                          : CustomButton(
                              onTap: () => _bloc.editShared(
                                  controllerTitle.text,
                                  controllerDescription.text,
                                  _bloc.imagePath ?? '',
                                  context),
                              icon: Text('Редагувати',
                                  style: BS.bold14.apply(color: BC.white)),
                            )
                    ],
                  )
                ],
              )),
            ],
          ),
          Space.h32,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Опис',
                style: BS.light14.apply(color: BC.black),
              ),
              Space.h8,
              Container(
                height: 230,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BRadius.r16,
                  border: Border.all(
                    color: BC.black,
                    width: 1,
                  ),
                ),
                child: FormBuilderTextField(
                  controller: controllerDescription,
                  name: 'text_field',
                  decoration: const InputDecoration(
                    hintText: 'Опис',
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: null,
                ),
              ),
              Space.h16,
              (_bloc.isAddShared)
                  ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomButton(
                    icon: Text('Опублікувати',
                        style: BS.bold14.apply(color: BC.white)),
                    onTap: () {
                      _bloc.addShares(
                          controllerTitle.text,
                          controllerDescription.text,
                          _bloc.imagePath ?? '',
                          context);
                    }),
                  )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
