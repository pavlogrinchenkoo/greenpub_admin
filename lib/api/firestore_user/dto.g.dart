// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['uid'] as String?,
      json['firstName'] as String?,
      json['phone'] as String?,
      json['email'] as String?,
      json['birthday'] as String?,
      json['avatar'] as String?,
      json['points'] as int?,
      (json['favorites'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['orders'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['timeCreate'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'firstName': instance.firstName,
      'phone': instance.phone,
      'email': instance.email,
      'birthday': instance.birthday,
      'avatar': instance.avatar,
      'points': instance.points,
      'favorites': instance.favorites,
      'orders': instance.orders,
      'timeCreate': instance.timeCreate,
    };
