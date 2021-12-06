import 'package:geiger_toolbox/app/data/model/country.dart';
import 'package:geiger_toolbox/app/services/localStorage/abstract/utility_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner.g.dart';

@JsonSerializable(explicitToJson: true)
class Partner {
  final String? id;
  Country location;
  List<String> names;

  Partner({String? id, required this.location, required this.names})
      : id = id ?? UtilityData.uuid;

  factory Partner.fromJson(Map<String, dynamic> json) {
    return _$PartnerFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PartnerToJson(this);
  }
}
