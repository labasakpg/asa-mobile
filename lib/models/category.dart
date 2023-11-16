import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final String? code;
  final String? name;
  final String? group;
  final int? print;
  final int? sort;
  final String? nameE;

  Category({
    this.code,
    this.name,
    this.group,
    this.print,
    this.sort,
    this.nameE,
  });

  static List<Category> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => Category.fromJson(data)).toList();

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
