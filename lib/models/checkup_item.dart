import 'package:json_annotation/json_annotation.dart';

part 'checkup_item.g.dart';

@JsonSerializable()
class CheckupItem {
  final String testCode;
  final String? name;
  final int? price3;
  final String? description;
  final String? abbreviation;
  final int? key;
  final int? index;

  CheckupItem({
    required this.testCode,
    this.name,
    this.price3,
    this.description,
    this.abbreviation,
    this.key,
    this.index,
  });

  static List<CheckupItem> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => CheckupItem.fromJson(data)).toList();

  factory CheckupItem.fromJson(Map<String, dynamic> json) => _$CheckupItemFromJson(json);

  Map<String, dynamic> toJson() => _$CheckupItemToJson(this);
}
