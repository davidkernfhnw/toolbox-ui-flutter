import 'package:geiger_toolbox/app/services/parser_helpers/abstract/utility_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(explicitToJson: true)
class Country {
  final String? id;
  String name;

  Country({String? id, required this.name}) : id = id ?? UtilityData.uuid;

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
