import 'package:equatable/equatable.dart';

import 'enums.dart';
import 'measurement.dart';

/// Full child model with computed fields
class Child extends Equatable {
  const Child({
    required this.id,
    required this.userId,
    required this.name,
    required this.gender,
    required this.birthDate,
    this.avatarImage,
    this.themeOverride,
    required this.ageInWeeks,
    required this.ageDisplay,
    this.latestMeasurements,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final String name;
  final Gender gender;
  final DateTime birthDate;
  final String? avatarImage;
  final ThemePreference? themeOverride;
  final int ageInWeeks;
  final String ageDisplay;
  final LatestMeasurements? latestMeasurements;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] as int,
      userId: json['user'] as int,
      name: json['name'] as String,
      gender: Gender.fromString(json['gender'] as String),
      birthDate: DateTime.parse(json['birth_date'] as String),
      avatarImage: json['avatar_image'] as String?,
      themeOverride: json['theme_override'] != null
          ? ThemePreference.fromString(json['theme_override'] as String)
          : null,
      ageInWeeks: int.tryParse(json['age_in_weeks'].toString()) ?? 0,
      ageDisplay: json['age_display'] as String? ?? '',
      latestMeasurements: json['latest_measurements'] != null &&
              json['latest_measurements'] is Map<String, dynamic>
          ? LatestMeasurements.fromJson(
              json['latest_measurements'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        gender,
        birthDate,
        avatarImage,
        themeOverride,
        ageInWeeks,
        ageDisplay,
        latestMeasurements,
        createdAt,
        updatedAt,
      ];
}

/// Lightweight child model for lists
class ChildListItem extends Equatable {
  const ChildListItem({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    this.avatarImage,
    required this.ageInWeeks,
    required this.ageDisplay,
    required this.createdAt,
  });

  final int id;
  final String name;
  final Gender gender;
  final DateTime birthDate;
  final String? avatarImage;
  final int ageInWeeks;
  final String ageDisplay;
  final DateTime createdAt;

  factory ChildListItem.fromJson(Map<String, dynamic> json) {
    return ChildListItem(
      id: json['id'] as int,
      name: json['name'] as String,
      gender: Gender.fromString(json['gender'] as String),
      birthDate: DateTime.parse(json['birth_date'] as String),
      avatarImage: json['avatar_image'] as String?,
      ageInWeeks: int.tryParse(json['age_in_weeks'].toString()) ?? 0,
      ageDisplay: json['age_display'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        gender,
        birthDate,
        avatarImage,
        ageInWeeks,
        ageDisplay,
        createdAt,
      ];
}

/// Request model for creating a child
class ChildCreateRequest {
  const ChildCreateRequest({
    required this.name,
    required this.gender,
    required this.birthDate,
    this.themeOverride,
  });

  final String name;
  final Gender gender;
  final DateTime birthDate;
  final ThemePreference? themeOverride;

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender.name,
        'birth_date':
            '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}',
        if (themeOverride != null) 'theme_override': themeOverride!.name,
      };
}

/// Request model for updating a child
class ChildUpdateRequest {
  const ChildUpdateRequest({
    this.name,
    this.gender,
    this.birthDate,
    this.themeOverride,
  });

  final String? name;
  final Gender? gender;
  final DateTime? birthDate;
  final ThemePreference? themeOverride;

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (gender != null) 'gender': gender!.name,
        if (birthDate != null)
          'birth_date':
              '${birthDate!.year}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}',
        if (themeOverride != null) 'theme_override': themeOverride!.name,
      };
}
