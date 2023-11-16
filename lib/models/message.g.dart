// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as int?,
      body: json['body'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      file: json['file'] == null
          ? null
          : Picture.fromJson(json['file'] as Map<String, dynamic>),
      key: json['key'] as int?,
      index: json['index'] as int?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'user': instance.user,
      'file': instance.file,
      'key': instance.key,
      'index': instance.index,
    };
