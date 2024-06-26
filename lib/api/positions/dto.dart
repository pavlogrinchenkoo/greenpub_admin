import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class PositionGroupModel {
  final String? uuid;
  final String? name;
  final List<String>? positions;
  bool? required;

  PositionGroupModel({this.uuid, this.name, this.positions, this.required});

  factory PositionGroupModel.fromJson(Map<String, dynamic> json) =>
      _$PositionGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionGroupModelToJson(this);
}

@JsonSerializable()
class PositionOrdersGroupModel {
  final String? uuid;
  final String? name;
  final List<ProductModelPosition>? positions;
  final int? count;
  bool? required;

  PositionOrdersGroupModel(
      {this.uuid, this.name, this.positions, this.required, this.count});

  factory PositionOrdersGroupModel.fromJson(Map<String, dynamic> json) =>
      _$PositionOrdersGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionOrdersGroupModelToJson(this);
}

@JsonSerializable()
class ProductModelPosition {
  final int? count;
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

  ProductModelPosition({
    this.count,
    this.uuid,
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
    this.required = false,
  });

  factory ProductModelPosition.fromJson(Map<String, dynamic> json) =>
      _$ProductModelPositionFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelPositionToJson(this);
}
