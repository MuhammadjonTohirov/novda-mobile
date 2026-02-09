
import 'package:novda_sdk/novda_sdk.dart';

/// Registration data collected during auth flow
class RegistrationData {
  String? phoneNumber;
  String? verificationCode;
  Gender? gender;
  String? babyName;
  DateTime? birthdate;
  double? weight;
  double? height;

  bool get hasPhoneNumber => phoneNumber != null;
  bool get hasVerificationCode => verificationCode != null;
  bool get hasGender => gender != null;
  bool get hasBabyName => babyName != null && babyName!.isNotEmpty;
  bool get hasBirthdate => birthdate != null;
  bool get hasWeight => weight != null;
  bool get hasHeight => height != null;

  bool get isComplete =>
      hasPhoneNumber &&
      hasGender &&
      hasBabyName &&
      hasBirthdate &&
      hasWeight &&
      hasHeight;
}