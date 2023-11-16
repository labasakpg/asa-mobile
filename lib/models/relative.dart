import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/patient.dart';
import 'package:anugerah_mobile/models/personal_data.dart';

part 'relative.g.dart';

@JsonSerializable()
class Relative {
  final int? id;
  final int? userId;
  final String? patientId;
  final int? personalDataId;

  final PersonalData? personalData;
  final Patient? patient;

  Relative({
    this.id,
    this.personalData,
    this.userId,
    this.patientId,
    this.personalDataId,
    this.patient,
  });

  static List<Relative> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => Relative.fromJson(data)).toList();

  factory Relative.fromJson(Map<String, dynamic> json) => _$RelativeFromJson(json);

  Map<String, dynamic> toJson() => _$RelativeToJson(this);
}
