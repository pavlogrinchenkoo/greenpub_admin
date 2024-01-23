// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      uuid: json['uuid'] as String?,
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      isPromo: json['isPromo'] as bool? ?? false,
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      image: json['image'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      weight: json['weight'] as String?,
      timeCreate: json['timeCreate'] as String?,
      isShow: json['isShow'] as bool? ?? true,
      filterOrders: json['filterOrders'] as int? ?? 0,
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => PositionGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'oldPrice': instance.oldPrice,
      'price': instance.price,
      'isPromo': instance.isPromo,
      'category': instance.category,
      'tags': instance.tags,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'weight': instance.weight,
      'timeCreate': instance.timeCreate,
      'isShow': instance.isShow,
      'filterOrders': instance.filterOrders,
      'positions': instance.positions,
    };

PositionGroupModel _$PositionGroupModelFromJson(Map<String, dynamic> json) =>
    PositionGroupModel(
      name: json['name'] as String?,
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => ProductModelPosition.fromJson(e as Map<String, dynamic>))
          .toList(),
      required: json['required'] as bool?,
    );

Map<String, dynamic> _$PositionGroupModelToJson(PositionGroupModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'positions': instance.positions,
      'required': instance.required,
    };

ProductModelPosition _$ProductModelPositionFromJson(
        Map<String, dynamic> json) =>
    ProductModelPosition(
      uuid: json['uuid'] as String?,
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      isPromo: json['isPromo'] as bool? ?? false,
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      image: json['image'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      weight: json['weight'] as String?,
      timeCreate: json['timeCreate'] as String?,
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductModelPositionToJson(
        ProductModelPosition instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'oldPrice': instance.oldPrice,
      'price': instance.price,
      'isPromo': instance.isPromo,
      'category': instance.category,
      'tags': instance.tags,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'weight': instance.weight,
      'timeCreate': instance.timeCreate,
      'required': instance.required,
    };
