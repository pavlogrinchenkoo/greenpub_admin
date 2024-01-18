import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/cache.dart';
import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_category/request.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:delivery/api/firestore_tags/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/product_page/widgets/show_pisition.dart';
import 'package:delivery/screens/products_page/bloc/bloc.dart';
import 'package:delivery/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FirestoreProductApi firestoreApi;
  final FirestoreCategoryApi firestoreCategoryApi;
  final FirestoreTagsApi firestoreTagsApi;
  final Cache cache;

  ProductCubit(this.firestoreApi, this.firestoreCategoryApi,
      this.firestoreTagsApi, this.cache)
      : super(LoadingState());

  ProductModel? product;
  ImageModel? image;
  bool isPromo = false;
  List<TagModel>? tags = [];
  List<CategoryModel> categoryList = [];
  List<TagModel> tagsList = [];
  String? imagePath;
  CategoryModel? category;
  bool isShow = true;
  List<ProductModel> sauces = [];
  List<ProductModelPosition> positions = [];

  Future<void> init(BuildContext context, String? id) async {
    try {
      dispose();
      emit(LoadingState());
      final product = await firestoreApi.getProductData(id ?? '');
      final tagsList = await firestoreTagsApi.getTagsList();
      final categoryList = await firestoreCategoryApi.getCategoriesList();
      this.tagsList = tagsList;
      this.categoryList = categoryList;
      this.product = product;
      isPromo = product?.isPromo ?? false;
      final imagePath = product?.image ?? '';
      this.imagePath = imagePath;
      final image = await firestoreApi.getImage(imagePath);
      this.image = image;
      isShow = product?.isShow ?? true;
      category = product?.category;
      tags = product?.tags;
      positions = product?.positions ?? [];
      final sauces = await firestoreApi.searchProductsSauces();
      for (final sauce in sauces) {
        if (sauce.category?.uuid == 'ebc7dc00-0a3e-1dfc-960e-83d41c06d6e2') {
          this.sauces.add(sauce);
        }
      }

      emit(LoadedState(
          product: product,
          image: image,
          imagePath: this.imagePath,
          categoryList: categoryList,
          tagsList: tagsList));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> editProduct(BuildContext context,
      {String? name,
      String? price,
      String? newPrice,
      CategoryModel? category,
      String? description,
      String? weight,
      String? time,
      bool? isPromo,
      String? imagePath,
      String? uuid,
      List<TagModel>? tags,
      bool? isShow,
      List<ProductModelPosition>? positions}) async {
    try {
      final dTime = DateTime.now();
      final numPrice = double.tryParse(price ?? '0');
      final numNewPrice = double.tryParse(newPrice ?? '0');
      // final numWeight = int.tryParse(weight ?? '0');

      final time = '${dTime.day}.${dTime.month}.${dTime.year}';
      final product = ProductModel(
          uuid: uuid,
          name: name,
          price: numPrice,
          oldPrice: numNewPrice,
          category: category,
          description: description,
          weight: weight,
          timeCreate: time,
          isPromo: isPromo,
          tags: tags,
          image: imagePath,
          isShow: isShow,
          positions: positions);
      print(product.category);
      print(product.tags);
      print(product.image);
      emit(LoadingState());
      await firestoreApi.editProduct(product);
      emit(LoadedState(
          product: product,
          image: image,
          imagePath: imagePath,
          categoryList: categoryList,
          tagsList: tagsList));
      if (context.mounted) {
        SnackBarService.showSnackBar(context, 'Продукт Збережено', false);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(
            context, 'Не вдалось змінити продукт', true);
      }
    }
  }

  Future<void> goProductsPage(BuildContext context) async {
    if (context.mounted) {
      context.router
          .pop()
          .whenComplete(() => context.read<ProductsCubit>().init(context));
    }
  }

  Future<void> deleteProduct(BuildContext context) async {
    try {
      await firestoreApi.deleteProduct(product?.uuid ?? '');
      if (context.mounted) {
        context.router
            .pop()
            .whenComplete(() => context.read<ProductsCubit>().init(context));
      }
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  void changeIsShow(bool isShow) {
    this.isShow = !isShow;
    emit(LoadedState(
        product: product,
        image: image,
        imagePath: imagePath,
        categoryList: categoryList,
        tagsList: tagsList));
  }

  Future<void> uploadImage() async {
    try {
      final Uint8List? pickedFile = await ImagePickerWeb.getImageAsBytes();
      firestoreApi.deleteImage(product?.uuid ?? '');
      final imagePath =
          await firestoreApi.saveImage(pickedFile, product?.uuid ?? '');
      image = ImageModel(
        bytes: pickedFile,
        path: imagePath,
      );
      this.imagePath = imagePath;
      cache.deletePhoto();
      emit(LoadedState(
          product: product,
          image: image,
          imagePath: imagePath,
          categoryList: categoryList,
          tagsList: tagsList));
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void addTags(List<dynamic> uuids) {
    tags = tagsList.where((element) => uuids.contains(element.uuid)).toList();
    print(tags?.length);
  }

  void addCategory(String? uuid) {
    category = categoryList.firstWhere((element) => element.uuid == uuid);
    print(category?.category);
  }

  void changePromo(bool promo) {
    isPromo = !promo;
    emit(LoadedState(
        product: product,
        image: image,
        categoryList: categoryList,
        tagsList: tagsList));
  }

  void showPosition(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (pageContext, _, __) {
          return Material(child: ShowPosition(sauces: sauces));
        });
  }

  void addSauce(ProductModel? sauce) {
    final position = ProductModelPosition(
      uuid: sauce?.uuid,
      oldPrice: sauce?.oldPrice,
      price: sauce?.price,
      isPromo: sauce?.isPromo,
      category: sauce?.category,
      tags: sauce?.tags,
      image: sauce?.image,
      name: sauce?.name,
      description: sauce?.description,
      weight: sauce?.weight,
      timeCreate: sauce?.timeCreate,
      required: false,
    );
    positions.add(position);
  }

  void removeSauce(String? uuid) {
    positions.removeWhere((element) => element.uuid == uuid);
  }

  void editSauce(String? uuid) {
    final required = positions.where((element) => element.uuid == uuid).first.required;
     positions.where((element) => element.uuid == uuid).first.required = !(required ?? false);

  }

  dispose() {
    positions.clear();
    sauces.clear();
  }

  void back(BuildContext context) {
    if (context.mounted) {
      context.router.pop();
    }
    emit(LoadedState(
        product: product,
        image: image,
        imagePath: imagePath,
        categoryList: categoryList,
        tagsList: tagsList
    ));
  }
}
