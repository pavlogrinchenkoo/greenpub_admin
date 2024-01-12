import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class SystemModel {
  final String? startTime;
  final String? endTime;
  final double? deliveryPrice;

  SystemModel(
      { this.startTime,
       this.endTime,
       this.deliveryPrice});

  factory SystemModel.fromJson(Map<String, dynamic> json) =>
      _$SystemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SystemModelToJson(this);
}
