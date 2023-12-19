import 'package:delivery/api/firestore_product/dto.dart';
import 'package:flutter/services.dart';

abstract class ProductsState {}

class LoadingState extends ProductsState {}

class LoadedState extends ProductsState {
  final List<ProductModel>? products;
  final List<Uint8List?>? images;

  LoadedState({this.products, this.images});
}

class ErrorState extends ProductsState {}