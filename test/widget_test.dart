import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/core/di/injection_container.dart';
import 'package:social_app/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Reset GetIt to ensure clean state
    await GetIt.instance.reset();

    // Set up mock SharedPreferences before initialization
    SharedPreferences.setMockInitialValues({});

    // Initialize dependencies (this will use the mocked SharedPreferences)
    await InjectionContainer.init();
  });

  tearDownAll(() async {
    await GetIt.instance.reset();
  });

  testWidgets('App initializes and shows splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // App should show MaterialApp (typically the Splash or home screen)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Unauthenticated user is shown login or auth screen', (
    WidgetTester tester,
  ) async {
    // Assuming MyApp shows a login/auth screen if not authenticated.
    // You may need to adjust the text/key for your specific auth screen.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Typically, you would search for a widget or text that's only present on the login/auth screen.
    // Replace 'Login' with the actual text on your authentication screen if needed.
    expect(
      find.textContaining('Login', findRichText: true).evaluate().isNotEmpty ||
          find
              .textContaining('Sign In', findRichText: true)
              .evaluate()
              .isNotEmpty,
      true,
      reason: 'Should show some authentication indicator',
    );
  });
}
