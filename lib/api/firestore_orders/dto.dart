import 'package:delivery/api/firestore_product/dto.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class OrderModel {
  final String? uid;
  final String? userId;
  final List<ItemProduct>? items;
  final Address? address;
  final String? payType;
  final String? deliveryType;
  final String? statusType;
  final String? timeCreate;
  double? price;
  double? discount;
  double? totalPrice;
  final String? comment;
  final int? spentPoints;
  final int? deliveryPrice;
  final String? deliveryTime;

  OrderModel(
      {this.uid,
      this.userId,
      this.items,
      this.price,
      this.address,
      this.payType,
      this.deliveryType,
      this.statusType,
      this.timeCreate,
      this.discount,
      this.totalPrice,
      this.comment,
      this.spentPoints,
      this.deliveryPrice,
      this.deliveryTime,
      });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

@JsonSerializable()
class ItemProduct {
  final ProductModel? product;
  int? count;

  ItemProduct({this.count, this.product});

  factory ItemProduct.fromJson(Map<String, dynamic> json) =>
      _$ItemProductFromJson(json);

  Map<String, dynamic> toJson() => _$ItemProductToJson(this);
}

@JsonSerializable()
class Address {
  final String? address;
  final String? apartment;
  final String? code;
  final String? entrance;
  final String? floor;
  final String? nameAddress;

  Address(
      {this.address,
      this.apartment,
      this.code,
      this.entrance,
      this.floor,
      this.nameAddress});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

class ImageModel {
  final String? path;
  final String? bytes;

  ImageModel({this.path, this.bytes});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      path: json['path'] as String?,
      bytes: json['bytes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'bytes': bytes,
    };
  }
}
