import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/services/parser_helpers/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner.g.dart';

@JsonSerializable(explicitToJson: true)
class Partner {
  final String? id;
  Country location;
  List<String> names;
  String locale;

  Partner(
      {String? id,
      required this.location,
      required this.names,
      this.locale: "en"})
      : id = id ?? Uuids.uuid;

  factory Partner.fromJson(Map<String, dynamic> json) {
    return _$PartnerFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PartnerToJson(this);
  }

  @override
  String toString() {
    super.toString();
    return '{"id":$id, "location":$location, "names":$names, "locale"$locale}';
  }
}
