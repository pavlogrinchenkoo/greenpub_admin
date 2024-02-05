import 'dart:html';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_category/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/widgets/custom_show_dialog.dart';
import 'package:delivery/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';
import 'state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final FirestoreCategoryApi categoriesApi;
  final uuid = const Uuid();

  CategoryCubit(this.categoriesApi) : super(LoadingState());

  bool isShowTextField = false;
  List<CategoryModel> categories = [];
  List<String?> images = [];
  String? imagePath;
  Uint8List? image;
  String? uid;

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      await getCategoriesList();
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getCategoriesList() async {
    try {
      final categoriesList = await categoriesApi.getCategoriesList();
      categories = categoriesList;
      images.clear();
      for (final category in categories) {
        final image = category.image;
        final getImage = await categoriesApi.getImage(image ?? '');
        images.add(getImage);
      }
      emit(LoadedState(categories: categoriesList,
          images: images
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void showTextField() {
    imagePath = null;
    image = null;
    uid = null;
    isShowTextField = true;
    uid = uuid.v1();
    emit(LoadedState(categories: categories,
        images: images,
        uuid: uid));
  }

  Future<void> addCategory(String category, BuildContext context,
      TextEditingController controller) async {
    try {
      if (category.isNotEmpty) {
        await categoriesApi.addCategory(category, imagePath ?? '', uid ?? '');
        await getCategoriesList();
        if (context.mounted) {
          SnackBarService.showSnackBar(context, 'Категорію додано', false);
        }
        isShowTextField = false;
        controller.clear();
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Категорію не додано', true);
      }
    }
  }

  Future<void> editCategory(
      String uid, String newTag, String filterOrder, BuildContext context) async {
    try {
      int filterOrderInt = int.parse(filterOrder);
      await categoriesApi.editCategory(uid, newTag, filterOrderInt);
      await getCategoriesList();
      if (context.mounted) {
        context.router.pop();
        SnackBarService.showSnackBar(context, 'Категорію змінено', false);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Категорію не змінено', true);
      }
    }
  }

  Future<void> deleteCategory(String uid, BuildContext context) async {
    try {
      await categoriesApi.deleteCategory(uid);
      await getCategoriesList();
      if (context.mounted) {
        context.router.pop();
        SnackBarService.showSnackBar(context, 'Категорію видалено', false);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Категорію не видалено', true);
      }
    }
  }

  void showDeleteDialog(CategoryModel? categoryModel, BuildContext context) {
    if (context.mounted) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CustomShowDialog(
              title: 'Видалити Категорію?',
              content:
                  'Ви впевнені, що хочете видалити Категорію <${categoryModel?.category}>?',
              buttonOne: 'Видалити',
              onTapOne: () =>
                  deleteCategory(categoryModel?.uuid ?? '', context),
              buttonTwo: 'Скасувати',
              onTapTwo: () {
                context.router.pop();
              }));
    }
  }

  void showEditDialog(
      CategoryModel? category, TextEditingController controller, BuildContext context, TextEditingController textController) {
    controller.text = category?.category ?? '';
    textController.text = category?.filterOrders.toString() ?? '';
    if (context.mounted) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CustomEditCategoryDialog(
              controller: controller,
              controller1: textController,
              title: 'Змінити Категорію?',
              buttonOne: 'Змінити',
              onTapOne: () {
                editCategory(category?.uuid ?? '', controller.text, textController.text, context);
              },
              buttonTwo: 'Скасувати',
              onTapTwo: () {
                context.router.pop();
              }));
    }
  }

  Future<void> addImage() async {
    final Uint8List? pickedFile = await ImagePickerWeb.getImageAsBytes();
    final imagePath = await categoriesApi.saveImage(pickedFile, uid ?? '');
    image = pickedFile;
    this.imagePath = imagePath;
    emit(LoadedState(categories: categories,
        // images: images
    ));
  }

  Future<void> editImage(String? uid) async {
    final Uint8List? pickedFile = await ImagePickerWeb.getImageAsBytes();
    categoriesApi.deleteImage(uid ?? '');
    final imagePath = await categoriesApi.saveImage(pickedFile, uid ?? '');
    image = pickedFile;
    this.imagePath = imagePath;
    categoriesApi.editImage(uid ?? '', imagePath);
    await getCategoriesList();
  }
}
