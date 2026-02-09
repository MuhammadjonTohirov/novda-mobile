import 'package:flutter/foundation.dart';
import 'package:novda_sdk/novda_sdk.dart';

/// View state enum for managing UI states
enum ViewState {
  idle,
  loading,
  success,
  error,
}

/// Base class for all view models
abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  /// Current view state
  ViewState get state => _state;

  /// Error message if state is error
  String? get errorMessage => _errorMessage;

  /// Whether the view model is currently loading
  bool get isLoading => _state == ViewState.loading;

  /// Whether there's an error
  bool get hasError => _state == ViewState.error;

  /// Set the view state
  @protected
  void setState(ViewState state, {String? error}) {
    _state = state;
    _errorMessage = error;
    notifyListeners();
  }

  /// Set loading state
  @protected
  void setLoading() => setState(ViewState.loading);

  /// Set success state
  @protected
  void setSuccess() => setState(ViewState.success);

  /// Set error state with message
  @protected
  void setError(String message) => setState(ViewState.error, error: message);

  /// Set idle state
  @protected
  void setIdle() => setState(ViewState.idle);

  /// Handle API exceptions and set appropriate error messages
  @protected
  void handleException(Object error) {
    if (error is ApiException) {
      setError(error.message);
    } else {
      setError(error.toString());
    }
  }
}
