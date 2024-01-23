import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class ProductModel {
  final String? uuid; //disabled
  final double? oldPrice;
  final double? price;
  final bool? isPromo;
  final CategoryModel? category;
  final List<TagModel>? tags;
  final String? image;
  final String? name;
  final String? description;
  final String? weight;
  final String? timeCreate;
  final bool? isShow;
  final int? filterOrders;
  final List<PositionGroupModel>? positions;

  ProductModel(
      {this.uuid,
      this.oldPrice,
      this.price,
      this.isPromo = false,
      this.category,
      this.tags,
      this.image,
      this.name,
      this.description,
      this.weight,
      this.timeCreate,
      this.isShow = true,
      this.filterOrders = 0,
      this.positions});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class PositionGroupModel {
  final String? name;
  final List<ProductModelPosition>? positions;
   bool? required;

  PositionGroupModel({this.name, this.positions, this.required});

  factory PositionGroupModel.fromJson(Map<String, dynamic> json) =>
      _$PositionGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionGroupModelToJson(this);
}

@JsonSerializable()
class ProductModelPosition {
  final String? uuid; //disabled
  final double? oldPrice;
  final double? price;
  final bool? isPromo;
  final CategoryModel? category;
  final List<TagModel>? tags;
  final String? image;
  final String? name;
  final String? description;
  final String? weight;
  final String? timeCreate;
  bool? required;

  ProductModelPosition(
      {this.uuid,
      this.oldPrice,
      this.price,
      this.isPromo = false,
      this.category,
      this.tags,
      this.image,
      this.name,
      this.description,
      this.weight,
      this.timeCreate,
      this.required = false});

  factory ProductModelPosition.fromJson(Map<String, dynamic> json) =>
      _$ProductModelPositionFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelPositionToJson(this);
}
