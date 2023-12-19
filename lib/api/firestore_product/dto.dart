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
  final int? weight;
  final String? timeCreate;

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
      this.timeCreate});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
