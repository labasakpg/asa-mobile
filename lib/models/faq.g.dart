// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Faq _$FaqFromJson(Map<String, dynamic> json) => Faq(
      id: json['id'] as int?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      key: json['key'] as int?,
      index: json['index'] as int?,
    );

Map<String, dynamic> _$FaqToJson(Faq instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'key': instance.key,
      'index': instance.index,
    };
