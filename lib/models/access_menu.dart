import 'package:json_annotation/json_annotation.dart';

part 'access_menu.g.dart';

@JsonSerializable()
class AccessMenu {
  final String key;
  final String label;

  AccessMenu(this.key, this.label);

  factory AccessMenu.fromJson(Map<String, dynamic> json) => _$AccessMenuFromJson(json);

  Map<String, dynamic> toJson() => _$AccessMenuToJson(this);
}
