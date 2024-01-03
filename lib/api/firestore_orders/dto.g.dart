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
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      payType: json['payType'] as String?,
      deliveryType: json['deliveryType'] as String?,
      statusType: json['statusType'] as String?,
      timeCreate: json['timeCreate'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
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
      'statusType': instance.statusType,
      'timeCreate': instance.timeCreate,
      'discount': instance.discount,
      'totalPrice': instance.totalPrice,
      'comment': instance.comment,
    };

ItemProduct _$ItemProductFromJson(Map<String, dynamic> json) => ItemProduct(
      count: json['count'] as int?,
      product: json['product'] == null
          ? null
          : ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemProductToJson(ItemProduct instance) =>
    <String, dynamic>{
      'product': instance.product,
      'count': instance.count,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      address: json['address'] as String?,
      apartment: json['apartment'] as String?,
      code: json['code'] as String?,
      entrance: json['entrance'] as String?,
      floor: json['floor'] as String?,
      nameAddress: json['nameAddress'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'address': instance.address,
      'apartment': instance.apartment,
      'code': instance.code,
      'entrance': instance.entrance,
      'floor': instance.floor,
      'nameAddress': instance.nameAddress,
    };
