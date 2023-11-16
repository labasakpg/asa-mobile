// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsorship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sponsorship _$SponsorshipFromJson(Map<String, dynamic> json) => Sponsorship(
      id: json['id'] as int,
      name: json['name'] as String?,
      picName: json['picName'] as String?,
      instituteName: json['instituteName'] as String?,
      address: json['address'] as String?,
      userId: json['userId'] as int?,
      branchCode: json['branchCode'] as String?,
      locationId: json['locationId'] as int?,
      picPhotoId: json['picPhotoId'] as int?,
      signatureId: json['signatureId'] as int?,
      createdBy: json['createdBy'] as int?,
      updatedBy: json['updatedBy'] == null
          ? null
          : User.fromJson(json['updatedBy'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      branch: json['branch'] == null
          ? null
          : Branch.fromJson(json['branch'] as Map<String, dynamic>),
      picPhoto: json['picPhoto'] == null
          ? null
          : Picture.fromJson(json['picPhoto'] as Map<String, dynamic>),
      signature: json['signature'] == null
          ? null
          : Picture.fromJson(json['signature'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      key: json['key'] as int?,
      index: json['index'] as int?,
      receiptNumber: json['receiptNumber'] as String?,
      processNumber: json['processNumber'] as String?,
      city: json['city'] as String?,
      nominal: json['nominal'] as int?,
    );

Map<String, dynamic> _$SponsorshipToJson(Sponsorship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiptNumber': instance.receiptNumber,
      'processNumber': instance.processNumber,
      'name': instance.name,
      'picName': instance.picName,
      'instituteName': instance.instituteName,
      'address': instance.address,
      'city': instance.city,
      'nominal': instance.nominal,
      'userId': instance.userId,
      'branchCode': instance.branchCode,
      'locationId': instance.locationId,
      'picPhotoId': instance.picPhotoId,
      'signatureId': instance.signatureId,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'branch': instance.branch,
      'picPhoto': instance.picPhoto,
      'signature': instance.signature,
      'location': instance.location,
      'user': instance.user,
      'key': instance.key,
      'index': instance.index,
    };
