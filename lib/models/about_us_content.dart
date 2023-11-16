import 'package:json_annotation/json_annotation.dart';

part 'about_us_content.g.dart';

@JsonSerializable()
class AboutUsContent {
  String title;
  String body;

  AboutUsContent({
    required this.title,
    required this.body,
  });

  factory AboutUsContent.fromJson(Map<String, dynamic> json) => _$AboutUsContentFromJson(json);

  Map<String, dynamic> toJson() => _$AboutUsContentToJson(this);
}
