import '../gateways/children_gateway.dart';
import '../models/child.dart';
import '../models/enums.dart';

/// Use case interface for children operations
abstract interface class ChildrenUseCase {
  /// Get all children for current user
  Future<List<ChildListItem>> getChildren();

  /// Get detailed child information
  Future<Child> getChild(int childId);

  /// Create a new child profile
  Future<Child> createChild({
    required String name,
    required Gender gender,
    required DateTime birthDate,
    ThemePreference? themeOverride,
  });

  /// Update child profile
  Future<Child> updateChild(
    int childId, {
    String? name,
    Gender? gender,
    DateTime? birthDate,
    ThemePreference? themeOverride,
  });

  /// Delete child profile
  Future<void> deleteChild(int childId);

  /// Set child as active/selected
  Future<void> selectChild(int childId);
}

/// Implementation of ChildrenUseCase
class ChildrenUseCaseImpl implements ChildrenUseCase {
  ChildrenUseCaseImpl(this._gateway);

  final ChildrenGateway _gateway;

  @override
  Future<List<ChildListItem>> getChildren() {
    return _gateway.getChildren();
  }

  @override
  Future<Child> getChild(int childId) {
    return _gateway.getChild(childId);
  }

  @override
  Future<Child> createChild({
    required String name,
    required Gender gender,
    required DateTime birthDate,
    ThemePreference? themeOverride,
  }) {
    return _gateway.createChild(ChildCreateRequest(
      name: name,
      gender: gender,
      birthDate: birthDate,
      themeOverride: themeOverride,
    ));
  }

  @override
  Future<Child> updateChild(
    int childId, {
    String? name,
    Gender? gender,
    DateTime? birthDate,
    ThemePreference? themeOverride,
  }) {
    return _gateway.updateChild(
      childId,
      ChildUpdateRequest(
        name: name,
        gender: gender,
        birthDate: birthDate,
        themeOverride: themeOverride,
      ),
    );
  }

  @override
  Future<void> deleteChild(int childId) {
    return _gateway.deleteChild(childId);
  }

  @override
  Future<void> selectChild(int childId) {
    return _gateway.selectChild(childId);
  }
}
