// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      patientId: json['patientId'] as String?,
      personalDataId: json['personalDataId'] as int?,
      patientName: json['patientName'] as String?,
      checkupName: json['checkupName'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      discount: json['discount'],
      discountRupiah: json['discountRupiah'],
      net: (json['net'] as num?)?.toDouble(),
      personalData: json['personalData'] == null
          ? null
          : PersonalData.fromJson(json['personalData'] as Map<String, dynamic>),
      isEven: json['isEven'] as bool? ?? true,
      testCode: json['testCode'] as String,
      name: json['name'] as String?,
      price3: json['price3'] as int?,
      description: json['description'] as String?,
      abbreviation: json['abbreviation'] as String?,
      key: json['key'] as int?,
      index: json['index'] as int?,
    );

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'testCode': instance.testCode,
      'name': instance.name,
      'price3': instance.price3,
      'description': instance.description,
      'abbreviation': instance.abbreviation,
      'key': instance.key,
      'index': instance.index,
      'patientId': instance.patientId,
      'personalDataId': instance.personalDataId,
      'patientName': instance.patientName,
      'checkupName': instance.checkupName,
      'price': instance.price,
      'discount': instance.discount,
      'discountRupiah': instance.discountRupiah,
      'net': instance.net,
      'personalData': instance.personalData,
      'isEven': instance.isEven,
    };
