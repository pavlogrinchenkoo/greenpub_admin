import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:flutter/services.dart';

abstract class ShowProductState {}

class LoadingState extends ShowProductState {}

class LoadedState extends ShowProductState {
  final List<ProductModel>? products;
  LoadedState({this.products});
}

class ErrorState extends ShowProductState {}
