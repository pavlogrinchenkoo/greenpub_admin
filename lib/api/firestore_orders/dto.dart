import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class OrderModel {
  final String? uid;

  final String? userId;

  final List<ItemProduct>? items;

  final double? price;

  final String? address;

  final String? payType;

  final String? deliveryType;

  final String? timeCreate;

  OrderModel(
      {this.uid,
      this.userId,
      this.items,
      this.price,
      this.address,
      this.payType,
      this.deliveryType,
      this.timeCreate});

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

@JsonSerializable()
class ItemProduct {
  final String? uuid;
  final String? name;
  final double? price;
   int? count;

  ItemProduct({this.name, this.price, this.count, this.uuid});

  factory ItemProduct.fromJson(Map<String, dynamic> json) =>
      _$ItemProductFromJson(json);

  Map<String, dynamic> toJson() => _$ItemProductToJson(this);
}
