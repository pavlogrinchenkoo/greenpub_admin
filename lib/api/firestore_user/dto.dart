import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class UserModel {
  final String? uid;

  final String? firstName;

  final String? phone;

  final String? email;

  final String? birthday;

  final String? avatar;

  final int? points;

  final List<String>? favorites;

  final List<String>? orders;

  final String? timeCreate;

  UserModel(
    this.uid,
    this.firstName,
    this.phone,
    this.email,
    this.birthday,
    this.avatar,
    this.points,
    this.favorites,
    this.orders,
    this.timeCreate,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

//dart run build_runner build -d
}

