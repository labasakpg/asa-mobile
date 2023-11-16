import 'package:json_annotation/json_annotation.dart';

part 'faq.g.dart';

@JsonSerializable()
class Faq {
  final int? id;
  final String? question;
  final String? answer;
  final String? createdAt;
  final String? updatedAt;
  final int? key;
  final int? index;

  Faq({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.key,
    this.index,
  });

  static List<Faq> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => Faq.fromJson(data)).toList();

  factory Faq.fromJson(Map<String, dynamic> json) => _$FaqFromJson(json);

  Map<String, dynamic> toJson() => _$FaqToJson(this);
}
