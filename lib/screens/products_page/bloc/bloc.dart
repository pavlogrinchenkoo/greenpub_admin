import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/cache.dart';
import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_category/request.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/style.dart';
import 'package:delivery/widgets/custom_show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final FirestoreProductApi firestoreApi;
  final FirestoreCategoryApi firestoreCategoryApi;
  final Cache cache;

  ProductsCubit(this.firestoreApi, this.cache, this.firestoreCategoryApi)
      : super(LoadingState());

  List<ProductModel> products = [];
  List<CategoryModel> categories = [];
  bool isSearch = false;

  Future<void> init(BuildContext context) async {
    dispose();
    try {
      emit(LoadingState());
      await getCategories();
      await getProducts();
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> search(String? value) async {
    try {
      isSearch = true;
      print('value: $value');
     List<ProductModel> products = [...this.products];
     final filteredProducts = this
          .products
          .where((product) =>
          product.name!.toLowerCase().contains(value!.toLowerCase()))
          .toList();
     if(value?.isEmpty ?? true) {
       isSearch = false;
     }
      emit(LoadedState(products: filteredProducts, categories: categories));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getCategories() async {
    try {
      final categories = await firestoreCategoryApi.getCategoriesList();
      this.categories.addAll(categories);
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getProducts() async {
    try {
      final products = await firestoreApi.getProducts();
     // final filter = products.where((element) => element.category?.category == 'М\'ясні страви').toList();
     // print('filter: $filter');
      final idCategory = 'dcd8f180-c6ea-1e4b-80ad-8d7afac92046';
     final filter = products.where((element) => element.category?.uuid == idCategory).toList();
      print('filter: $filter');
      this.products.addAll(products);
      emit(LoadedState(products: this.products, categories: categories));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void showSelectedDialog(BuildContext context, CategoryModel? category,
      List<ProductModel>? products) {
    bool isShow = category?.isShow ?? true;
    showDialog(
      context: context,
      builder: (context) {
        return CustomShowDialog(
          title: 'Ви впевнені, що хочете змінити категорію?',
          buttonOne: 'Змінити',
          buttonTwo: 'Скасувати',
          onTapOne: () async {
            emit(LoadingState());
            if(context.mounted) context.router.pop();
             firestoreCategoryApi.updateShow(
                category?.uuid ?? '', !isShow);
            for(final product in products ?? []) {
              await firestoreApi.updateShow(product.uuid , !isShow);
            }
            categories = [];
            this.products = [];
            await getCategories();
            await getProducts();
          },
          onTapTwo: () {
            context.router.pop();
          },
        );
      },
    );
  }

  void goAddProductPage(BuildContext context) {
    context.router.push(const AddProductRoute());
  }

  void goProductPage(BuildContext context, String id) {
    context.router.push(ProductRoute(id: id));
  }

  void dispose() {
    products = [];
    categories = [];

  }
}
