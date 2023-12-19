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
      weight: json['weight'] as int?,
      timeCreate: json['timeCreate'] as String?,
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
    };
