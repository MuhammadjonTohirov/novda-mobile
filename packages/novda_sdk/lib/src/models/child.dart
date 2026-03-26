import 'package:equatable/equatable.dart';

import 'enums.dart';
import 'measurement.dart';

int _parseInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

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
    final birthDate = DateTime.tryParse(json['birth_date']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    return Child(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user']),
      name: json['name'] as String? ?? '',
      gender: Gender.fromString(json['gender']?.toString() ?? ''),
      birthDate: birthDate,
      avatarImage: json['avatar_image'] as String?,
      themeOverride: json['theme_override'] != null
          ? ThemePreference.fromString(json['theme_override'].toString())
          : null,
      ageInWeeks: _parseInt(json['age_in_weeks']),
      ageDisplay: json['age_display'] as String? ?? '',
      latestMeasurements: json['latest_measurements'] is Map<String, dynamic>
          ? LatestMeasurements.fromJson(
              json['latest_measurements'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          birthDate,
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          birthDate,
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
    final birthDate = DateTime.tryParse(json['birth_date']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    return ChildListItem(
      id: _parseInt(json['id']),
      name: json['name'] as String? ?? '',
      gender: Gender.fromString(json['gender']?.toString() ?? ''),
      birthDate: birthDate,
      avatarImage: json['avatar_image'] as String?,
      ageInWeeks: _parseInt(json['age_in_weeks']),
      ageDisplay: json['age_display'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          birthDate,
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
        'birth_date': _formatDate(birthDate),
        if (themeOverride != null) 'theme_override': themeOverride!.name,
      };
}

String _formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

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
        if (birthDate != null) 'birth_date': _formatDate(birthDate!),
        if (themeOverride != null) 'theme_override': themeOverride!.name,
      };
}
