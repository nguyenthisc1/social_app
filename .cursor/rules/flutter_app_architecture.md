---
description: Clean Architecture patterns, DI, data flow, and project structure conventions.
alwaysApply: true
---

# Flutter App Architecture

## Project Layout

Split layout: `lib/features/<name>/` holds **data + domain** layers; `lib/presentation/<area>/` holds **UI + BLoC**.

- `lib/core/` — Shared infrastructure: DI (`get_it`), networking (`ApiClient`), routing (`GoRouter`), theme, locale, errors, utils, widgets.
- `lib/features/<name>/data/` — Data sources (remote + local), models, repository implementations.
- `lib/features/<name>/domain/` — Entities, mappers, repository interfaces, use cases.
- `lib/presentation/<area>/` — BLoCs, pages/screens, widgets.

## Architecture Layers

1. **Presentation** → **BLoC** → **UseCase** → **Repository** → **DataSource** (unidirectional).
2. Only allow communication between adjacent layers.
3. The UI layer must not access data sources or repositories directly.
4. BLoCs receive use cases via constructor injection and emit state changes.
5. Use cases are single-purpose classes that call repository methods.
6. Repositories implement domain interfaces and coordinate between remote/local data sources.

## Data Flow and State

1. State flows from data → domain → presentation. Events flow in the opposite direction.
2. Data changes happen in the repository (single source of truth), not in UI or BLoC.
3. UI reflects immutable state snapshots from BLoC. Trigger rebuilds only via state changes.
4. Repository interfaces return `Either<Failure, T>` (dartz) for error handling.

## Dependency Injection (GetIt)

1. Register all dependencies in `lib/core/di/service_locator.dart`.
2. Follow registration order: External → Core → Data Sources → Repositories → Use Cases → BLoCs.
3. Use `registerLazySingleton` for singletons (ApiClient, repos, data sources, BLoCs).
4. Use `registerFactory` for use cases (new instance per resolution).
5. Use lazy resolution or closures to break circular dependencies.

## Data Sources

1. `*RemoteDataSource` — wraps API calls (`ApiClient`) or Firebase SDK calls.
2. `*LocalDataSource` — wraps `SharedPreferences` or local cache.
3. Data sources return/accept **models** (JSON-serializable), not entities.
4. Firebase calls go in remote data sources, following the same pattern as REST API calls.

## Mappers

1. Use dedicated mapper classes in `domain/mappers/` to convert between models and entities.
2. Never expose data models to the presentation layer — always map to domain entities.

## Networking

1. `ApiClient` handles HTTP requests, token attachment, and error responses.
2. Custom exceptions (`UnauthorizedException`, `ServerException`, `NetworkException`, `ValidationException`) are thrown in the data layer.
3. Repositories catch exceptions and map them to domain `Failure` types.
4. Mark auth endpoints (login, register, refresh) with `authenticated: false` to skip token attachment.

## Best Practices

1. Use `StatelessWidget` when possible. Keep build methods simple.
2. Use `const` constructors to improve performance.
3. Keep state as local as possible to minimize rebuilds.
4. Implement pagination for large lists.
5. Keep files focused on a single responsibility.
6. Use `final` for fields and top-level variables when possible.
7. Follow Dart naming conventions and format code using `dart format`.
