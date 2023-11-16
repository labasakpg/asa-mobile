import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/patient.dart';

part 'checkup_result.g.dart';

@JsonSerializable()
class CheckupResult {
  final String? id;
  final String? patientId;
  final String? checkUpDate;
  final String? description;
  final String? doctorId;
  final String? createdAt;
  final String? instituteId;
  final String? key;
  final int? index;
  final Patient? patient;

  CheckupResult({
    this.id,
    this.patientId,
    this.checkUpDate,
    this.description,
    this.doctorId,
    this.createdAt,
    this.instituteId,
    this.key,
    this.index,
    this.patient,
  });

  static List<CheckupResult> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => CheckupResult.fromJson(data)).toList();

  factory CheckupResult.fromJson(Map<String, dynamic> json) => _$CheckupResultFromJson(json);

  Map<String, dynamic> toJson() => _$CheckupResultToJson(this);
}
