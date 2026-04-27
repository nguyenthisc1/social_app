---
description: Firebase integration patterns for Auth, Firestore, Storage, and Messaging.
globs: lib/**/*firebase*, lib/**/*fire*
alwaysApply: false
---

# Firebase Rules

## Initialization
- Call `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` in `main()` before `runApp()`.
- Generate config with `flutterfire configure` — do not manually edit `firebase_options.dart`.

## Architecture
- Firebase SDK calls belong in `*RemoteDataSource` classes only — never in BLoCs, use cases, or widgets.
- Wrap Firebase exceptions in domain `Failure` types at the repository layer.
- Register Firebase-backed data sources in `service_locator.dart` like any other dependency.

## Firebase Auth
- Use `FirebaseAuth.instance` inside an auth data source, not directly in UI.
- Map `FirebaseAuthException` codes to typed domain failures (`InvalidCredentialsFailure`, `EmailAlreadyInUseFailure`, etc.).
- Listen to `authStateChanges()` stream for real-time auth state — pipe through BLoC, not directly to widgets.
- Store additional user profile data in Firestore, not in Firebase Auth custom claims.

## Cloud Firestore
- Define collection names as constants in a single location.
- Use typed model classes with `fromFirestore` / `toFirestore` factory methods.
- Prefer batch writes for multiple related updates.
- Use `withConverter<T>()` for type-safe collection references.
- Index compound queries — Firestore throws if a required index is missing.
- Handle `FirebaseException` with code-specific error mapping in the data layer.

## Firebase Storage
- Upload/download through a dedicated `StorageDataSource`.
- Use structured paths: `users/{uid}/profile`, `posts/{postId}/images/{filename}`.
- Set proper security rules — never allow unauthenticated uploads in production.
- Delete associated storage files when the parent document is deleted.

## Firebase Messaging (FCM)
- Request notification permissions at an appropriate UX moment, not on app launch.
- Handle foreground, background, and terminated-state messages separately.
- Store FCM tokens in Firestore user documents for targeted push.
- Use `FirebaseMessaging.onMessageOpenedApp` for notification tap handling.

## Security Rules
- Always write Firestore and Storage security rules — never deploy with open rules.
- Test rules with the Firebase Emulator Suite before deploying.

## Testing
- Use Firebase Emulator Suite for local development and integration tests.
- Mock Firebase services in unit tests — never call live Firebase in tests.
