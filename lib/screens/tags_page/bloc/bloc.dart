import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:delivery/api/firestore_tags/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/widgets/custom_show_dialog.dart';
import 'package:delivery/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class TagsCubit extends Cubit<TagsState> {
  final FirestoreTagsApi tagsApi;

  TagsCubit(this.tagsApi) : super(LoadingState());

  bool isShowTextField = false;
  List<TagModel> tags = [];

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      final tagsList = await tagsApi.getTagsList();
      tags = tagsList;
      emit(LoadedState(tags: tags));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void showTextField() {
    isShowTextField = true;
    emit(LoadedState(tags: tags));
  }

  Future<void> addTag(String tag, BuildContext context, TextEditingController controller) async {
    try {
      if (tag.isNotEmpty) {
        await tagsApi.addTag(tag);
        final tagsList = await tagsApi.getTagsList();
        tags = tagsList;
        emit(LoadedState(tags: tags));
        if (context.mounted) {
          SnackBarService.showSnackBar(context, 'Тег додано', false);
        }
        isShowTextField = false;
        controller.clear();
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Тег не додано', true);
      }
    }
  }

  Future<void> editTag(String uid, String newTag, BuildContext context) async {
    try {
      await tagsApi.editTag(uid, newTag);
      final tagsList = await tagsApi.getTagsList();
      tags = tagsList;
      emit(LoadedState(tags: tags));
      if (context.mounted) {
        context.router.pop();
        SnackBarService.showSnackBar(context, 'Тег змінено', false);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Тег не змінено', true);
      }
    }
  }

  Future<void> deleteTag(String uid, BuildContext context) async {
    try {
      await tagsApi.deleteTag(uid);
      final tagsList = await tagsApi.getTagsList();
      tags = tagsList;
      emit(LoadedState(tags: tags));
      if (context.mounted) {
        context.router.pop();
        SnackBarService.showSnackBar(context, 'Тег видалено', false);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Тег не видалено', true);
      }
    }
  }

  void showDeleteDialog(TagModel? teg, BuildContext context) {
    if (context.mounted) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CustomShowDialog(
              title: 'Видалити тег?',
              content: 'Ви впевнені, що хочете видалити тег <${teg?.tag}>?',
              buttonOne: 'Видалити',
              onTapOne: () => deleteTag(teg?.uuid ?? '', context),
              buttonTwo: 'Скасувати',
              onTapTwo: () {
                context.router.pop();
              }));
    }
  }

  void showEditDialog(
      String? uid, TextEditingController controller, BuildContext context) {
    if (context.mounted) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CustomEditDialog(
              controller: controller,
              title: 'Змінити тег?',
              buttonOne: 'Змінити',
              onTapOne: () {
                editTag(uid ?? '', controller.text, context);
              },
              buttonTwo: 'Скасувати',
              onTapTwo: () {
                context.router.pop();
              }));
    }
  }
}
