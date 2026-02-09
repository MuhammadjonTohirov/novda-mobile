import '../../base/base_view_model.dart';

/// Abstract ViewModel for verification screens
abstract class VerificationViewModel extends BaseViewModel {
  /// The destination (phone/email) being verified
  String get destination;

  /// Verify the input code
  Future<bool> verify(String code);

  /// Resend the verification code
  Future<bool> resend();
}
