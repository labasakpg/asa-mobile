import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient {
  final String? id;
  final String? name;
  final String? dateOfBirth;
  final String? address;
  final String? email;
  final String? phoneNumber;

  Patient({
    this.id,
    this.name,
    this.dateOfBirth,
    this.address,
    this.email,
    this.phoneNumber,
  });

  static List<Patient> toList(dynamic data) =>
      List<Map<String, dynamic>>.from(data).map((data) => Patient.fromJson(data)).toList();

  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);

  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
