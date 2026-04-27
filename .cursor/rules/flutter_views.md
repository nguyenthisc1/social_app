---
description: UI-related rules for Flutter presentation layer including BLoC, pages, screens, and widgets.
globs: lib/presentation/**/*
alwaysApply: false
---

# Presentation Layer Rules

- UI lives in `lib/presentation/<area>/` with `bloc/`, `pages/`, `screens/`, `widgets/` subdirectories.
- Use `BlocBuilder`, `BlocConsumer`, or `BlocSelector` for state-driven UI — never call use cases directly from widgets.
- Use `BlocListener` for side effects (navigation, snackbars, dialogs).
- Keep widgets small, focused, and extract reusable ones into separate files.
- Use `StatelessWidget` when possible; avoid unnecessary `StatefulWidget`.
- Implement routing with GoRouter — define routes in `lib/core/routes/app_router.dart`.
- Use Material 3 design via `flex_color_scheme` and `Theme.of(context)` for styling.
- Use proper form validation with `Form` and `TextFormField`.
- Handle all BLoC states explicitly: initial, loading, success, failure.
- Use `context.read<T>()` in callbacks, `BlocBuilder`/`BlocSelector` in build methods.
