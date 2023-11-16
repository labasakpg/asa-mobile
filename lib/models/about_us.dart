import 'package:json_annotation/json_annotation.dart';
import 'package:anugerah_mobile/models/about_us_content.dart';

part 'about_us.g.dart';

@JsonSerializable()
class AboutUs {
  AboutUsContent introduction;
  AboutUsContent tagline;
  AboutUsContent vision;
  AboutUsContent mission;
  AboutUsContent address;
  AboutUsContent website;
  AboutUsContent phone;
  AboutUsContent whatsapp;
  AboutUsContent tiktok;
  AboutUsContent instagram;
  AboutUsContent facebook;

  AboutUs({
    required this.introduction,
    required this.tagline,
    required this.vision,
    required this.mission,
    required this.address,
    required this.website,
    required this.phone,
    required this.whatsapp,
    required this.tiktok,
    required this.instagram,
    required this.facebook,
  });

  factory AboutUs.fromJson(Map<String, dynamic> json) => _$AboutUsFromJson(json);

  Map<String, dynamic> toJson() => _$AboutUsToJson(this);
}
