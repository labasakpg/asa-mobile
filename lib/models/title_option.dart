import 'package:json_annotation/json_annotation.dart';

part 'title_option.g.dart';

@JsonSerializable()
class TitleOption {
  final String? kode;
  final String? nama;
  final String? kelamin;
  final String? userId;
  final String? userupdate;

  TitleOption({
    this.kode,
    this.nama,
    this.kelamin,
    this.userId,
    this.userupdate,
  });

  static List<TitleOption> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => TitleOption.fromJson(data)).toList();

  factory TitleOption.fromJson(Map<String, dynamic> json) => _$TitleOptionFromJson(json);

  Map<String, dynamic> toJson() => _$TitleOptionToJson(this);
}
