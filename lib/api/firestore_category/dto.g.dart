// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      image: json['image'] as String?,
      uuid: json['uuid'] as String?,
      category: json['category'] as String?,
      isShow: json['isShow'] as bool? ?? true,
      filterOrders: json['filterOrders'] as int? ?? 0,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'category': instance.category,
      'image': instance.image,
      'isShow': instance.isShow,
      'filterOrders': instance.filterOrders,
    };
