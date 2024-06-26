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
      options: (json['options'] as List<dynamic>?)
          ?.map((e) =>
              PositionOrdersGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceWithOptions: (json['priceWithOptions'] as num?)?.toDouble(),
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
      'options': instance.options,
      'priceWithOptions': instance.priceWithOptions,
    };
