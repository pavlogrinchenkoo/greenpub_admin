import 'package:delivery/api/firestore_category/dto.dart';
import 'package:flutter/services.dart';

abstract class CategoryState {}

class LoadingState extends CategoryState {}

class LoadedState extends CategoryState {
  final List<CategoryModel>? categories;
  final List<Uint8List?>? images;
  final String? uuid;

  LoadedState( {this.categories, this.images, this.uuid});
}

class ErrorState extends CategoryState {}