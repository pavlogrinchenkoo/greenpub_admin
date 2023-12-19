// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      uid: json['uid'] as String?,
      userId: json['userId'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ItemProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: (json['price'] as num?)?.toDouble(),
      address: json['address'] as String?,
      payType: json['payType'] as String?,
      deliveryType: json['deliveryType'] as String?,
      timeCreate: json['timeCreate'] as String?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userId': instance.userId,
      'items': instance.items,
      'price': instance.price,
      'address': instance.address,
      'payType': instance.payType,
      'deliveryType': instance.deliveryType,
      'timeCreate': instance.timeCreate,
    };

ItemProduct _$ItemProductFromJson(Map<String, dynamic> json) => ItemProduct(
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      count: json['count'] as int?,
      uuid: json['uuid'] as String?,
    );

Map<String, dynamic> _$ItemProductToJson(ItemProduct instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'price': instance.price,
      'count': instance.count,
    };
