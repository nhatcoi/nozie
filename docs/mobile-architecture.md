# Mobile app conventions

## Flat structure

```
lib/
├── app/            router, guards, app widget
├── core/           shared code, one level of folders
│   ├── config/ network/ session/ storage/ services/      plumbing
│   ├── theme/      colors, typography, spacing + radius tokens, ThemeData
│   ├── widgets/    shared UI components (flat: buttons, cards, skeletons, state views, ...)
│   ├── utils/ models/ enums/ extension/ constants/ layouts/
├── features/<feature>/   files sit side by side, the suffix says the role
│   ├── <feature>_screen.dart          a screen (kept short; it only composes widgets)
│   ├── <feature>_<part>.dart          extracted widgets of that screen
│   ├── <feature>_providers.dart / *_notifier.dart       state
│   ├── <feature>_repository.dart / *_api.dart            data access
│   └── <thing>.dart                   a model
└── i18n/           slang translations (strings*.i18n.yaml -> translations.g.dart)
```

Rules (most are enforced by `analysis_options.yaml` and `flutter analyze` in CI):

- Package imports only (`package:nozie_mobile/...`), no relative imports.
- A feature never imports another feature's screens; share through `core/`.
- One widget per class and no `Widget _buildX()` helpers for anything non-trivial: extract a class so it can be `const`, rebuilt independently and tested.
- No literal colours or magic spacing in UI: use `AppColors`, `AppSpacing`, `AppRadius` and the theme's text styles.
- Every async screen goes through `AsyncValueView`: loading (skeleton), error with retry, empty, data.
- Errors shown to people come from `errorMessage(error)` (maps the API's error code to i18n text); never `error.toString()`.
- User-facing text lives in `lib/i18n`; no hardcoded strings in widgets.
- Prices go through `PriceUtils` ("Free" for 0, grouped VND, `$` with two decimals).
- Anything tappable has a semantic label; layouts must survive text scale 1.6 and a 320 dp wide screen (see `test/core/widgets`).
- Files stay under ~300 lines; split before they grow past that.

## Adding a screen

1. `features/<feature>/<name>_screen.dart` composes small widgets from the same folder.
2. Data comes from a Riverpod provider that calls a repository; the screen only `watch`es it.
3. Wrap the provider's `AsyncValue` in `AsyncValueView` with a skeleton as `loading`.
4. Add i18n keys to both `strings.i18n.yaml` and `strings_vi.i18n.yaml`, then `dart run slang`.
5. Add a widget test for the loading, error and data states.
