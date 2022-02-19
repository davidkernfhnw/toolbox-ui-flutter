import 'package:json_annotation/json_annotation.dart';

part 'cert.g.dart';

@JsonSerializable(explicitToJson: true)
class Cert {
  String? id;
  String? name;
  String? locationId;

  Cert({this.id, this.name, this.locationId});

  factory Cert.fromJson(Map<String, dynamic> json) {
    return _$CertFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CertToJson(this);
  }

  @override
  String toString() {
    return "{'id':$id, 'name':$name, 'locationId':$locationId}";
  }
}
