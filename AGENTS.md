## Goal
- Keep changes small, correct, and production-ready.
- Prefer consistency with the existing Novda architecture over personal style.

## Project Boundaries
- `lib/` is app layer (features, screens, app flow).
- `packages/novda_core/` is core infra (services, base view model, shared app logic).
- `packages/novda_components/` is reusable UI components and theme tokens.
- `packages/novda_sdk/` is API client, gateways, models, and use-cases.
- Do not refactor across layers unless explicitly requested.

## Coding Principles
- Prefer clear, simple code over clever code.
- Keep functions focused and short.
- Avoid duplicate logic; extract private helpers when reused.
- Preserve existing naming conventions and file structure.
- Divide the views into smaller parts and join them into one, like factory principle
- A single view, viewmodel, or interactor should not exceed 500 lines.

## Flutter UI Rules
- Reuse `AppTypography`, `context.appColors`, and shared components first.
- Keep widgets composable: avoid declaring multiple widget classes in a single `.dart` file (including private ones); extract view-specific UI pieces into extension files and import them.
- Avoid hardcoding magic numbers repeatedly; reuse constants in-file when repeated.
- Ensure mobile-safe layout with `SafeArea`, overflow-safe text, and scrollable content.
- Keep tap targets and spacing accessible.
- Default to UI extension methods (`WidgetExtensions`, context extensions, etc.) to keep view code concise and consistent.
- Use extensions as much as possible for common layout/styling patterns; avoid verbose raw widget wrappers when an extension exists.
- If a UI pattern repeats and no extension exists yet, add/expand an extension in the shared layer and reuse it.

## State Management Rules
- Use existing `BaseViewModel` + `Provider` pattern unless told otherwise.
- A view should have a ViewModel and interactor when the view is complex.
- ViewModel handles business/data loading; widgets handle rendering only.
- Keep view state explicit (`idle/loading/success/error`).
- Never call SDK directly from deeply nested presentation widgets if ViewModel exists.

## Networking and Data Rules
- Access backend via `services.sdk.<use_case>` only.
- Gateway parsing must tolerate backend envelope differences when possible.
- Do not silently swallow critical errors; either surface or gracefully fallback.
- Keep model parsing defensive for nullable/missing fields.

## Error Handling Rules
- User-facing flows should degrade gracefully (empty states, retry actions).
- Prefer typed API exceptions over generic catches when possible.
- Do not crash UI for non-critical sections (load partial content where possible).

## Localization Rules
- New user-facing strings must be added to l10n resources and localize them.
- Avoid embedding product text in widgets unless temporary debug text.

## Performance Rules
- Avoid unnecessary rebuilds and heavy work in `build`.
- Use lazy lists/grids for collections.
- Keep async calls parallel when independent.

## Testing and Validation
- After edits, run `flutter analyze`.
- Run focused tests for changed logic where tests exist.
- For UI-heavy changes, verify empty/loading/error states manually.

## Git and Change Hygiene
- Do not revert unrelated local changes.
- Keep diffs minimal and task-focused.
- Do not introduce unrelated formatting churn.
- Add brief inline comments only for non-obvious logic.

## Output Expectations
- For each task, provide:
- What changed
- Why it changed
- Validation performed
- Any known limitations
