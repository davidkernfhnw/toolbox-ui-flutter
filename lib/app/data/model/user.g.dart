// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userId: json['userId'] as String,
    firstName: json['firstName'] as String? ?? 'currentUser',
    lastname: json['lastname'] as String? ?? 'currentUser',
    knowledgeLevel: json['knowledgeLevel'] as String? ?? '1',
    role: json['role'] == null
        ? null
        : Role.fromJson(json['role'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastname': instance.lastname,
      'knowledgeLevel': instance.knowledgeLevel,
      'role': instance.role,
    };
