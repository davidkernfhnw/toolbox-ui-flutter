import 'package:json_annotation/json_annotation.dart';

part 'partner.g.dart';

@JsonSerializable(explicitToJson: true)
class Partner {
  String country;
  List<String> names;

  Partner({required this.country, required this.names});

  factory Partner.fromJson(Map<String, dynamic> json) {
    return _$PartnerFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PartnerToJson(this);
  }
}
