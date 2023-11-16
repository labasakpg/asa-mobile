import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final int id;
  final String longitude;
  final String latitude;
  final String? createdAt;
  final String? branchCode;

  Location({
    required this.id,
    required this.longitude,
    required this.latitude,
    this.createdAt,
    this.branchCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  LatLng toLatLng() => LatLng(double.parse(latitude), double.parse(longitude));
}
