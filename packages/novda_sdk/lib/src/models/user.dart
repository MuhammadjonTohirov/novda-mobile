import 'package:equatable/equatable.dart';

import 'enums.dart';

/// User profile model
class User extends Equatable {
  const User({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    required this.preferredLocale,
    required this.themePreference,
    required this.notificationsEnabled,
    this.termsAcceptedAt,
    this.lastActiveChild,
    this.ageInWeeks,
  });

  final int id;
  final String phone;
  final String name;
  final String? email;
  final PreferredLocale preferredLocale;
  final ThemePreference themePreference;
  final bool notificationsEnabled;
  final DateTime? termsAcceptedAt;
  final int? lastActiveChild;
  final int? ageInWeeks;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      phone: json['phone'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      preferredLocale:
          PreferredLocale.fromString(json['preferred_locale'] as String? ?? 'en'),
      themePreference:
          ThemePreference.fromString(json['theme_preference'] as String? ?? 'auto'),
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      termsAcceptedAt: json['terms_accepted_at'] != null
          ? DateTime.parse(json['terms_accepted_at'] as String)
          : null,
      lastActiveChild: json['last_active_child'] as int?,
      ageInWeeks: json['age_in_weeks'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        phone,
        name,
        email,
        preferredLocale,
        themePreference,
        notificationsEnabled,
        termsAcceptedAt,
        lastActiveChild,
        ageInWeeks,
      ];
}

/// Request model for updating user profile
class UserUpdateRequest {
  const UserUpdateRequest({
    this.name,
    this.email,
    this.preferredLocale,
    this.themePreference,
    this.notificationsEnabled,
  });

  final String? name;
  final String? email;
  final PreferredLocale? preferredLocale;
  final ThemePreference? themePreference;
  final bool? notificationsEnabled;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (preferredLocale != null) 'preferred_locale': preferredLocale!.name,
      if (themePreference != null) 'theme_preference': themePreference!.name,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
    };
  }
}
