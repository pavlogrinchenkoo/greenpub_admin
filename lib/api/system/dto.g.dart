// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemModel _$SystemModelFromJson(Map<String, dynamic> json) => SystemModel(
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      deliveryPrice: (json['deliveryPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SystemModelToJson(SystemModel instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'deliveryPrice': instance.deliveryPrice,
    };
