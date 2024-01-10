

import 'package:json_annotation/json_annotation.dart';


part 'dto.g.dart';

@JsonSerializable()
class SharesModel {
  final String? uid;
  final String? title;
  final String? description;
  final String? image;

  SharesModel(
      { this.uid,
       this.title,
       this.description,
       this.image});

  factory SharesModel.fromJson(Map<String, dynamic> json) =>
      _$SharesModelFromJson(json);

  Map<String, dynamic> toJson() => _$SharesModelToJson(this);
}
