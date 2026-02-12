import 'package:novda/features/auth/models/registrantion_data.dart';
import 'package:novda_core/novda_core.dart';
import 'package:novda_sdk/novda_sdk.dart';

export 'package:novda_core/novda_core.dart' show VerificationViewModel;

enum PostVerificationRoute { goHome, selectChild, createChild }

/// View model for the entire authentication flow
class AuthorizationViewModel extends BaseViewModel
    implements VerificationViewModel {
  AuthorizationViewModel({
    AuthUseCase? authUseCase,
    UserUseCase? userUseCase,
    ChildrenUseCase? childrenUseCase,
    MeasurementsUseCase? measurementsUseCase,
    TokenStorage? tokenStorage,
  }) : _authUseCase = authUseCase ?? services.sdk.auth,
       _userUseCase = userUseCase ?? services.sdk.user,
       _childrenUseCase = childrenUseCase ?? services.sdk.children,
       _measurementsUseCase = measurementsUseCase ?? services.sdk.measurements,
       _tokenStorage = tokenStorage ?? services.tokenStorage;

  final AuthUseCase _authUseCase;
  final UserUseCase _userUseCase;
  final ChildrenUseCase _childrenUseCase;
  final MeasurementsUseCase _measurementsUseCase;
  final TokenStorage _tokenStorage;

  final RegistrationData _registrationData = RegistrationData();
  int _otpExpiresIn = 60;
  Child? _createdChild;

  /// Get registration data
  RegistrationData get registrationData => _registrationData;

  /// OTP expiration time in seconds
  int get otpExpiresIn => _otpExpiresIn;

  /// Created child after registration
  Child? get createdChild => _createdChild;

  // --- VerificationViewModel Implementation ---

  @override
  String get destination => _registrationData.phoneNumber ?? '';

  @override
  Future<bool> verify(String code) => verifyOtp(code);

  @override
  Future<bool> resend() => resendOtp();

  // -------------------------------------------

  /// Request OTP for phone number
  Future<bool> requestOtp(String phoneNumber) async {
    setLoading();
    try {
      final response = await _authUseCase.requestOtp(phone: phoneNumber);
      _registrationData.phoneNumber = phoneNumber;
      _otpExpiresIn = response.expiresIn;
      setSuccess();
      return true;
    } catch (e) {
      handleException(e);
      return false;
    }
  }

  /// Verify OTP code
  Future<bool> verifyOtp(String code) async {
    if (_registrationData.phoneNumber == null) {
      setError('Phone number not set');
      return false;
    }

    setLoading();
    try {
      final tokens = await _authUseCase.verifyOtp(
        phone: _registrationData.phoneNumber!,
        code: code,
      );

      await _tokenStorage.saveTokens(
        access: tokens.access,
        refresh: tokens.refresh,
      );

      _registrationData.verificationCode = code;
      setSuccess();
      return true;
    } catch (e) {
      handleException(e);
      return false;
    }
  }

  /// Resend OTP code
  Future<bool> resendOtp() async {
    if (_registrationData.phoneNumber == null) {
      setError('Phone number not set');
      return false;
    }

    setLoading();
    try {
      final response = await _authUseCase.requestOtp(
        phone: _registrationData.phoneNumber!,
      );
      _otpExpiresIn = response.expiresIn;
      setSuccess();
      return true;
    } catch (e) {
      handleException(e);
      return false;
    }
  }

  /// Set baby gender
  void setGender(Gender gender) {
    _registrationData.gender = gender;
    notifyListeners();
  }

  /// Set baby name
  void setBabyName(String name) {
    _registrationData.babyName = name;
    notifyListeners();
  }

  /// Set baby birthdate
  void setBirthdate(DateTime birthdate) {
    _registrationData.birthdate = birthdate;
    notifyListeners();
  }

  /// Set baby weight
  void setWeight(double weight) {
    _registrationData.weight = weight;
    notifyListeners();
  }

  /// Set baby height
  void setHeight(double height) {
    _registrationData.height = height;
    notifyListeners();
  }

  /// Complete registration by creating child and measurements
  Future<bool> completeRegistration() async {
    if (!_registrationData.isComplete) {
      setError('Registration data incomplete');
      return false;
    }

    setLoading();
    try {
      // Create child
      final child = await _childrenUseCase.createChild(
        name: _registrationData.babyName!,
        gender: _registrationData.gender!,
        birthDate: _registrationData.birthdate!,
      );

      _createdChild = child;

      // Add initial measurements
      await Future.wait([
        _measurementsUseCase.createMeasurement(
          child.id,
          type: MeasurementType.weight,
          value: _registrationData.weight!,
          takenAt: _registrationData.birthdate!,
        ),
        _measurementsUseCase.createMeasurement(
          child.id,
          type: MeasurementType.height,
          value: _registrationData.height!,
          takenAt: _registrationData.birthdate!,
        ),
      ]);

      setSuccess();
      return true;
    } catch (e) {
      handleException(e);
      return false;
    }
  }

  /// Check if user has existing children
  Future<bool> checkExistingChildren() async {
    try {
      final children = await loadChildren();
      return children.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Decide the next route after OTP verification.
  ///
  /// Flow:
  /// 1) Read user profile and `last_active_child`
  /// 2) Load children list
  /// 3) If `last_active_child` exists in list -> activate and go home
  /// 4) If no children -> create child flow
  /// 5) Otherwise -> children selection
  Future<PostVerificationRoute> resolvePostVerificationRoute() async {
    try {
      final user = await _userUseCase.getProfile();
      final children = await _childrenUseCase.getChildren();

      if (children.isEmpty) {
        return PostVerificationRoute.createChild;
      }

      final lastActiveChildId = user.lastActiveChild;
      if (lastActiveChildId != null) {
        final childExists = children.any(
          (child) => child.id == lastActiveChildId,
        );
        if (childExists) {
          await _childrenUseCase.selectChild(lastActiveChildId);
          return PostVerificationRoute.goHome;
        }
      }

      return PostVerificationRoute.selectChild;
    } catch (e) {
      handleException(e);
      return PostVerificationRoute.createChild;
    }
  }

  /// Load all children for current user
  Future<List<ChildListItem>> loadChildren() async {
    setLoading();
    try {
      final children = await _childrenUseCase.getChildren();
      setSuccess();
      return children;
    } catch (e) {
      handleException(e);
      return [];
    }
  }

  /// Select a child as active
  Future<bool> selectChild(int childId) async {
    setLoading();
    try {
      await _childrenUseCase.selectChild(childId);
      setSuccess();
      return true;
    } catch (e) {
      handleException(e);
      return false;
    }
  }

  /// Resolve app theme from the current profile preference.
  Future<ThemeVariant> resolveThemeVariant() {
    return services.resolveThemeVariant();
  }

  /// Clear registration data
  void clearRegistrationData() {
    _registrationData
      ..phoneNumber = null
      ..verificationCode = null
      ..gender = null
      ..babyName = null
      ..birthdate = null
      ..weight = null
      ..height = null;
    _createdChild = null;
    setIdle();
  }
}
