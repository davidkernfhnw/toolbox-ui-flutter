import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(explicitToJson: true)
class Country {
  String id;
  String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return _$CountryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CountryToJson(this);
  }

  @override
  String toString() {
    super.toString();
    return '{"id":$id,  "name":$name}';
  }
}
