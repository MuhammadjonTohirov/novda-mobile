import 'package:novda/core/extensions/parsing_extensions.dart';
import 'package:novda_sdk/novda_sdk.dart';

class ChildFormState {
  const ChildFormState({
    required this.name,
    required this.day,
    required this.month,
    required this.year,
    required this.weight,
    required this.height,
    required this.gender,
  });

  final String name;
  final String day;
  final String month;
  final String year;
  final String weight;
  final String height;
  final Gender? gender;

  DateTime? get birthDate => DateParsing.tryParseBirthDate(
        day: day,
        month: month,
        year: year,
      );

  double? get weightValue => weight.toMetricValue(max: 200);
  double? get heightValue => height.toMetricValue(max: 250);

  bool get _isBirthDateInputComplete =>
      day.trim().isNotEmpty &&
      month.trim().isNotEmpty &&
      year.trim().isNotEmpty;

  bool get hasBirthDateError => _isBirthDateInputComplete && birthDate == null;
  bool get hasWeightError => weight.trim().isNotEmpty && weightValue == null;
  bool get hasHeightError => height.trim().isNotEmpty && heightValue == null;

  bool get isComplete =>
      name.trim().isNotEmpty &&
      gender != null &&
      birthDate != null &&
      weightValue != null &&
      heightValue != null;
}
