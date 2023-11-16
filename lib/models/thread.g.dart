// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) => Thread(
      id: json['id'] as int,
      title: json['title'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      isReadByPatient: json['isReadByPatient'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      key: json['key'] as int?,
      index: json['index'] as int?,
    );

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'status': instance.status,
      'isReadByPatient': instance.isReadByPatient,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'user': instance.user,
      'key': instance.key,
      'index': instance.index,
    };
