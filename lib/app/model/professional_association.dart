import 'package:json_annotation/json_annotation.dart';

part 'professional_association.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalAssociation {
  String? id;
  String? name;
  String? locationId;

  ProfessionalAssociation({this.id, this.name, this.locationId});

  factory ProfessionalAssociation.fromJson(Map<String, dynamic> json) {
    return _$ProfessionalAssociationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProfessionalAssociationToJson(this);
  }

  @override
  String toString() {
    return '{"id":$id, "name":$name, "locationId":$locationId}';
  }
}
