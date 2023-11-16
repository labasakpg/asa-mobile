import 'package:json_annotation/json_annotation.dart';

part 'picture.g.dart';

@JsonSerializable()
class Picture {
  final int? id;
  final int? index;
  final String? slug;
  final String? extension;

  Picture({
    this.id,
    this.index,
    this.slug,
    this.extension,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => _$PictureFromJson(json);

  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
