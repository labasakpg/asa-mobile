import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/picture.dart';

part 'personal_data.g.dart';

@JsonSerializable()
class PersonalData {
  final int? id;
  final String? name;
  final String? dateOfBirth;
  final String? address;
  final String? email;
  final String? phoneNumber;
  final Picture? picture;
  final Picture? photo;
  final String? jobPosition;
  final String? city;
  final String? gender;
  final String? job;
  final String? ktp;
  final String? title;

  PersonalData({
    this.id,
    this.name,
    this.dateOfBirth,
    this.address,
    this.email,
    this.phoneNumber,
    this.picture,
    this.photo,
    this.jobPosition,
    this.city,
    this.gender,
    this.job,
    this.ktp,
    this.title,
  });

  factory PersonalData.fromJson(Map<String, dynamic> json) => _$PersonalDataFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalDataToJson(this);
}
