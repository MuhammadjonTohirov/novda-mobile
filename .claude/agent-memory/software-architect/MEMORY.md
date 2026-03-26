# Novda Project - Architectural Memory

## Project Structure
- Flutter app with multi-package architecture
- `packages/novda_sdk/` - API SDK: gateways, use cases, models
- `packages/novda_core/` - App services: service locator, auth, theme
- `packages/novda_components/` - Shared UI components
- `lib/` - Main app: features, l10n, core extensions

## Key Architecture Patterns
- **Use case interfaces** defined as `abstract interface class` in `novda_sdk`
- **Decorator pattern** used for caching layer (see `cached_*_use_case.dart`)
- **Service locator** at `novda_core/lib/src/services/service_locator.dart` for DI
- **NovdaSDK** has two factories: `create()` (production) and `withUseCases()` (testing/decoration)
- `withUseCases()` accepts optional `LocaleConfigurable` parameter
- Locale config lives on the raw SDK's ApiClient; cached SDK delegates to raw SDK

## SDK Barrel Export
- `packages/novda_sdk/lib/novda_sdk.dart` - exports interfaces (not impls), models, cached decorators, SDK class

## Caching Layer (added 2026-03)
- `InMemoryCache<T>` generic TTL cache at `novda_sdk/lib/src/core/cache/in_memory_cache.dart`
- Children: 2min TTL on getChildren/getChild, mutations invalidate
- User: 2min TTL on getProfile, updateProfile invalidates
- Activities: 10min TTL on getActivityTypes/getConditionTypes (rarely change)
