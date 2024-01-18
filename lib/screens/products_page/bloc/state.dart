import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:flutter/services.dart';

abstract class ProductsState {}

class LoadingState extends ProductsState {}

class LoadedState extends ProductsState {
  final List<ProductModel>? products;
  final List<CategoryModel>? categories;

  LoadedState({this.products, this.categories});
}

class ErrorState extends ProductsState {}