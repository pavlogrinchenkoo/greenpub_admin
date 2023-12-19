import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:flutter/services.dart';

abstract class ProductState {}

class LoadingState extends ProductState {}

class LoadedState extends ProductState {
  final ProductModel? product;
  final Uint8List? image;
  final String? imagePath;
  final List<CategoryModel>? categoryList;
  final List<TagModel>? tagsList;

  LoadedState(
      {this.product,
      this.image,
      this.imagePath,
      this.categoryList,
      this.tagsList});
}

class ErrorState extends ProductState {}
