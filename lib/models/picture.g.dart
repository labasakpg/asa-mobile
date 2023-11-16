// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picture _$PictureFromJson(Map<String, dynamic> json) => Picture(
      id: json['id'] as int?,
      index: json['index'] as int?,
      slug: json['slug'] as String?,
      extension: json['extension'] as String?,
    );

Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'slug': instance.slug,
      'extension': instance.extension,
    };
