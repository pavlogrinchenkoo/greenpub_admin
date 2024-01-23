import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class CategoryModel {
  final String? uuid;
  final String? category;
  final String? image;
  final bool? isShow;
  final int? filterOrders;

  CategoryModel( {
    this.image,
    this.uuid,
    this.category,
    this.isShow = true,
    this.filterOrders = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
