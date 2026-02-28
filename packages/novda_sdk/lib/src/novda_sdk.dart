import 'core/network/api_client.dart';
import 'gateways/gateways.dart';
import 'use_cases/use_cases.dart';

/// Abstraction for locale configuration to avoid exposing [ApiClient].
abstract interface class LocaleConfigurable {
  void setLocale(String locale);
}

/// Main SDK class that provides access to all use cases.
/// Gateways are internal and not exposed.
class NovdaSDK {
  NovdaSDK._({
    required AuthUseCase auth,
    required UserUseCase user,
    required ChildrenUseCase children,
    required ActivitiesUseCase activities,
    required MeasurementsUseCase measurements,
    required ProgressUseCase progress,
    required RemindersUseCase reminders,
    required ArticlesUseCase articles,
    required ArticlesV2UseCase articlesV2,
    LocaleConfigurable? localeConfigurable,
  })  : _auth = auth,
       _user = user,
       _children = children,
       _activities = activities,
       _measurements = measurements,
       _progress = progress,
       _reminders = reminders,
       _articles = articles,
       _articlesV2 = articlesV2,
       _localeConfigurable = localeConfigurable;

  final AuthUseCase _auth;
  final UserUseCase _user;
  final ChildrenUseCase _children;
  final ActivitiesUseCase _activities;
  final MeasurementsUseCase _measurements;
  final ProgressUseCase _progress;
  final RemindersUseCase _reminders;
  final ArticlesUseCase _articles;
  final ArticlesV2UseCase _articlesV2;
  final LocaleConfigurable? _localeConfigurable;

  /// Authentication use case
  AuthUseCase get auth => _auth;

  /// User profile use case
  UserUseCase get user => _user;

  /// Children management use case
  ChildrenUseCase get children => _children;

  /// Activities use case
  ActivitiesUseCase get activities => _activities;

  /// Measurements use case
  MeasurementsUseCase get measurements => _measurements;

  /// Progress use case
  ProgressUseCase get progress => _progress;

  /// Reminders use case
  RemindersUseCase get reminders => _reminders;

  /// Articles use case
  ArticlesUseCase get articles => _articles;

  /// Articles v2 use case
  ArticlesV2UseCase get articlesV2 => _articlesV2;

  /// Set the locale for API requests
  void setLocale(String locale) {
    _localeConfigurable?.setLocale(locale);
  }

  /// Create a new instance of NovdaSDK with default implementations
  factory NovdaSDK.create({
    required String baseUrl,
    required String apiKey,
    required TokenProvider tokenProvider,
    String defaultLocale = 'en',
  }) {
    final config = ApiClientConfig(
      baseUrl: baseUrl,
      apiKey: apiKey,
      defaultLocale: defaultLocale,
    );

    final apiClient = DioApiClient(
      config: config,
      tokenProvider: tokenProvider,
    );

    // Create gateways (internal)
    final authGateway = AuthGatewayImpl(apiClient);
    final userGateway = UserGatewayImpl(apiClient);
    final childrenGateway = ChildrenGatewayImpl(apiClient);
    final activitiesGateway = ActivitiesGatewayImpl(apiClient);
    final measurementsGateway = MeasurementsGatewayImpl(apiClient);
    final progressGateway = ProgressGatewayImpl(apiClient);
    final remindersGateway = RemindersGatewayImpl(apiClient);
    final articlesGateway = ArticlesGatewayImpl(apiClient);
    final articlesV2Gateway = ArticlesV2GatewayImpl(apiClient);

    // Create use cases
    final authUseCase = AuthUseCaseImpl(authGateway);
    final userUseCase = UserUseCaseImpl(userGateway);
    final childrenUseCase = ChildrenUseCaseImpl(childrenGateway);
    final activitiesUseCase = ActivitiesUseCaseImpl(activitiesGateway);
    final measurementsUseCase = MeasurementsUseCaseImpl(measurementsGateway);
    final progressUseCase = ProgressUseCaseImpl(progressGateway);
    final remindersUseCase = RemindersUseCaseImpl(remindersGateway);
    final articlesUseCase = ArticlesUseCaseImpl(articlesGateway);
    final articlesV2UseCase = ArticlesV2UseCaseImpl(
      articlesV2Gateway: articlesV2Gateway,
      articlesGateway: articlesGateway,
    );

    return NovdaSDK._(
      auth: authUseCase,
      user: userUseCase,
      children: childrenUseCase,
      activities: activitiesUseCase,
      measurements: measurementsUseCase,
      progress: progressUseCase,
      reminders: remindersUseCase,
      articles: articlesUseCase,
      articlesV2: articlesV2UseCase,
      localeConfigurable: _ApiClientLocaleAdapter(apiClient),
    );
  }

  /// Create a new instance of NovdaSDK with custom use case implementations.
  /// Useful for testing.
  factory NovdaSDK.withUseCases({
    required AuthUseCase auth,
    required UserUseCase user,
    required ChildrenUseCase children,
    required ActivitiesUseCase activities,
    required MeasurementsUseCase measurements,
    required ProgressUseCase progress,
    required RemindersUseCase reminders,
    required ArticlesUseCase articles,
    required ArticlesV2UseCase articlesV2,
  }) {
    return NovdaSDK._(
      auth: auth,
      user: user,
      children: children,
      activities: activities,
      measurements: measurements,
      progress: progress,
      reminders: reminders,
      articles: articles,
      articlesV2: articlesV2,
    );
  }
}

/// Adapts [ApiClient.setLocale] to [LocaleConfigurable].
class _ApiClientLocaleAdapter implements LocaleConfigurable {
  _ApiClientLocaleAdapter(this._client);
  final ApiClient _client;

  @override
  void setLocale(String locale) => _client.setLocale(locale);
}
