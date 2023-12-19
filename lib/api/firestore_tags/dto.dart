import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class TagModel {
  final String? uuid;
  final String? tag;
  TagModel(
      {this.uuid,
        this.tag,
       });

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TegModelFromJson(json);

  Map<String, dynamic> toJson() => _$TegModelToJson(this);
}