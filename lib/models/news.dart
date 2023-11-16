import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/picture.dart';
import 'package:anugerah_mobile/models/promo.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  final int id;
  final String? slug;
  final String? title;
  final String? body;
  final int? bannerId;
  final String? createdAt;
  final String? updatedAt;
  final Picture? banner;
  final List<Picture>? files;
  final Promo? promo;

  News({
    required this.id,
    this.slug,
    this.title,
    this.body,
    this.bannerId,
    this.createdAt,
    this.updatedAt,
    this.banner,
    this.files,
    this.promo,
  });

  static List<News> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => News.fromJson(data)).toList();

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
