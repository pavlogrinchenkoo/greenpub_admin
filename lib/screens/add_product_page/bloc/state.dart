import 'dart:typed_data';

import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_tags/dto.dart';

abstract class AddProductState {}

class LoadingState extends AddProductState {}

class LoadedState extends AddProductState {
  final String? id;
  final String? time;
  final String? imagePath;
  final Uint8List? image;
  final List<CategoryModel>? categoryList;
  final List<TagModel>? tagsList;


  LoadedState({ this.id,  this.time, this.image, this.imagePath, this.categoryList, this.tagsList});
}

class ErrorState extends AddProductState {}