import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:flutter/services.dart';

abstract class ShowProductState {}

class LoadingState extends ShowProductState {}

class LoadedState extends ShowProductState {
  final List<ProductModel>? products;
  final List<ImageModel?>? images;
  LoadedState({this.products, this.images});
}

class ErrorState extends ShowProductState {}
