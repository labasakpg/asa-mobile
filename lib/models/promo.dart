import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/picture.dart';

part 'promo.g.dart';

@JsonSerializable()
class Promo {
  final int? id;
  final String? code;
  final String? type;
  final double? value;
  final String? title;
  final String? description;
  final String? tnc;
  final String? startAt;
  final String? expiredAt;
  final int? bannerId;
  final Picture? banner;
  final String? createdAt;
  final String? updatedAt;

  Promo({
    this.id,
    this.code,
    this.type,
    this.title,
    this.description,
    this.tnc,
    this.value,
    this.startAt,
    this.expiredAt,
    this.bannerId,
    this.banner,
    this.createdAt,
    this.updatedAt,
  });

  static List<Promo> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data)
          .map((data) => Promo.fromJson(data))
          .toList();

  factory Promo.fromJson(Map<String, dynamic> json) => _$PromoFromJson(json);

  Map<String, dynamic> toJson() => _$PromoToJson(this);
}
