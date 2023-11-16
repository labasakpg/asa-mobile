// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      id: json['id'] as int,
      slug: json['slug'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      bannerId: json['bannerId'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      banner: json['banner'] == null
          ? null
          : Picture.fromJson(json['banner'] as Map<String, dynamic>),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => Picture.fromJson(e as Map<String, dynamic>))
          .toList(),
      promo: json['promo'] == null
          ? null
          : Promo.fromJson(json['promo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'body': instance.body,
      'bannerId': instance.bannerId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'banner': instance.banner,
      'files': instance.files,
      'promo': instance.promo,
    };
