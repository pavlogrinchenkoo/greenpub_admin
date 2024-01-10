import 'dart:js';

import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/cache.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_orders/request.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/api/firestore_user/request.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class ShowProductCubit extends Cubit<ShowProductState> {
  final FirestoreProductApi firestoreApi;
  final FirestoreOrdersApi firestoreOrdersApi;
  final FirestoreUserApi firestoreUserApi;
  final Cache cache;

  ShowProductCubit(this.firestoreApi, this.firestoreOrdersApi,
      this.firestoreUserApi, this.cache)
      : super(LoadingState());

  List<ProductModel> products = [];
  List<ItemProduct> selectedProducts = [];
  bool isLoadMoreTriggered = false;
  int count = 0;
  List<ImageModel?> images = [];

  Future<void> init(BuildContext context) async {
    products = [];
    images = [];
    count = 0;
    isLoadMoreTriggered = false;
    selectedProducts = [];
    try {
      emit(LoadingState());
      final products = await firestoreApi.getProducts();
      this.products = products;
      count = products.length;
      for (final product in products) {
        final image = product.image;
        final getImage = await firestoreApi.getImage(image ?? '');
        images.add(getImage);
      }
      // await cache.savePhoto(images);
      emit(LoadedState(
        products: products,
        images: images,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }



  Future<void> getProducts() async {
    try {
      if (count >= 50) {
        final products = await firestoreApi.getProductsList(50, false);
        this.products.addAll(products);
        for (final product in products) {
          final image = product.image;
          final getImage = await firestoreApi.getImage(image ?? '');
          images.add(getImage);
        }
        emit(LoadedState(products: this.products, images: images));
        count = products.length;
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

  void addProduct(ProductModel? productModel) {
    selectedProducts.add(
      ItemProduct(
        count: 1,
        product: productModel,
      ),
    );
    emit(LoadedState(
      products: products,
      images: images,
    ));
  }

  void addCount(ProductModel? productModel) {
    final count = selectedProducts
        .where((element) => element.product?.uuid == productModel?.uuid)
        .first
        .count;
    final plusCount = count! + 1;
    selectedProducts
        .where((element) => element.product?.uuid == productModel?.uuid)
        .first
        .count = plusCount;
    print(
        'count: ${selectedProducts.where((element) => element.product?.uuid == productModel?.uuid).first.count}');
    emit(LoadedState(
      products: products,
      images: images,
    ));
  }

  void removeCount(ProductModel? productModel) {
    final count = selectedProducts
        .where((element) => element.product?.uuid == productModel?.uuid)
        .first
        .count;
    if (count == 1) {
      removeProduct(productModel);
    } else {
      final removeCount = count! - 1;
      selectedProducts
          .where((element) => element.product?.uuid == productModel?.uuid)
          .first
          .count = removeCount;
      emit(LoadedState(
        products: products,
        images: images,
      ));
    }
  }

  void removeProduct(ProductModel? productModel) {
    selectedProducts.removeWhere(
      (element) => element.product?.uuid == productModel?.uuid,
    );
    emit(LoadedState(
      products: products,
      images: images,
    ));
  }

  void goBack(BuildContext context) {
    context.router.pop().whenComplete(() =>
        context.read<OrdersCubit>().addProduct(selectedProducts, context));
  }
}
