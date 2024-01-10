// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharesModel _$SharesModelFromJson(Map<String, dynamic> json) => SharesModel(
      uid: json['uid'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$SharesModelToJson(SharesModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
